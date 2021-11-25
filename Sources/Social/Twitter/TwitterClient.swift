/**
 *  TwitterClient.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Foundation
import SwifterMac

class TwitterClient: Client, CallbackHandler {

    static func handleCallback(_ event: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else { return }

        return Swifter.handleOpenURL(URL(string: urlString)!)
    }

    static func authorize(key: String, secret: String, callbackURLScheme urlScheme: String?, handler: ((Credentials) -> Void)?, failure: Client.Failure?) {
        guard let urlScheme = urlScheme
            , let callbackURL = URL(string: "\(urlScheme)://\(String(describing: Provider.Twitter).lowercased())") else {
            failure?(SocialError.FailedAuthorize("Invalid callback url scheme."))
            return
        }

        let swifter = Swifter(consumerKey: key, consumerSecret: secret)

        swifter.authorize(withCallback: callbackURL, forceLogin: true, success: { accessToken, _ in
            guard let token = accessToken else {
                failure?(SocialError.FailedAuthorize("Invalid token."))
                return
            }

            handler?(TwitterCredentials(apiKey: key, apiSecret: secret, oauthToken: token.key, oauthSecret: token.secret))
        }, failure: failure)
    }

    let credentials: Credentials

    required init?(_ credentials: Credentials) {
        guard let credentials = credentials as? TwitterCredentials else {
            return nil
        }

        self.credentials = credentials
    }

    private func getSwifter() -> Swifter? {
        guard let credentials = self.credentials as? TwitterCredentials else {
            return nil
        }

        return Swifter(consumerKey: credentials.apiKey,
                       consumerSecret: credentials.apiSecret,
                       oauthToken: credentials.oauthToken,
                       oauthTokenSecret: credentials.oauthSecret)
    }

    func revoke(handler: Client.Success?, failure: Client.Failure?) {
        failure?(SocialError.NotImplements(className: NSStringFromClass(type(of: self)), function: #function))
    }

    func verify(handler: ((Account) -> Void)?, failure: Client.Failure?) {
        guard let swifter = self.getSwifter() else {
            failure?(SocialError.FailedVerify("Cannot get client."))
            return
        }

        swifter.verifyAccountCredentials(includeEntities: false, skipStatus: true, includeEmail: false, success: { json in
            guard let object = json.object
                , let id = object["id_str"]?.string
                , let name = object["name"]?.string
                , let screenName = object["screen_name"]?.string
                , let avaterURL = object["profile_image_url_https"]?.string else {
                    failure?(SocialError.FailedVerify("Invalid response."))
                    return
            }

            let account = TwitterAccount(id: id, name: name, username: screenName, avaterUrl: URL(string: avaterURL)!)
            handler?(account)
        }, failure: failure)
    }

    func post(text: String, image: Data?, handler: Client.Success?, failure: Client.Failure?) {
        guard let swifter = self.getSwifter() else {
            failure?(SocialError.FailedPost("Cannot get client."))
            return
        }

        if image == nil {
            swifter.postTweet(status: text, success:  { _ in handler?() }, failure: failure)
            return
        }

        swifter.postMedia(image!, success: { json in
            guard let object = json.object
                , let mediaID = object["media_id_string"]?.string else {
                    failure?(SocialError.FailedPost("Invalid response."))
                    return
            }
            swifter.postTweet(status: text, mediaIDs: [mediaID], success: { _ in handler?() }, failure: failure)
        }, failure: failure)
    }

}
