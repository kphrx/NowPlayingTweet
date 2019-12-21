/**
 *  D14nAuthorizeByCallback.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Foundation

protocol D14nAuthorizeByCallback: AuthorizeByCallback {

    static func authorize(base: URL?, key: String, secret: String, urlScheme: String, success: @escaping Client.TokenSuccess, failure: Client.Failure?)

}

extension D14nAuthorizeByCallback {

    static func authorize(base baseURL: URL?, key: String, secret: String, urlScheme: String, success: @escaping Client.TokenSuccess) {
        Self.authorize(base: baseURL, key: key, secret: secret, urlScheme: urlScheme, success: success, failure: nil)
    }

    static func authorize(key: String, secret: String, urlScheme: String, success: @escaping Client.TokenSuccess, failure: Client.Failure?) {
        Self.authorize(base: nil, key: key, secret: secret, urlScheme: urlScheme, success: success, failure: failure)
    }

}