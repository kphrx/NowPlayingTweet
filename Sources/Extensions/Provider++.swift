/**
 *  Provider++.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Cocoa

extension Provider {

    var accounts: ProviderAccounts.Type? {
        switch self {
        case .Twitter:
            return TwitterAccounts.self
        }
    }

    var client: Client.Type? {
        switch self {
        case .Twitter:
            return TwitterClient.self
        default:
            return nil
        }
    }

    var credentials: Credentials.Type? {
        switch self {
        case .Twitter:
            return TwitterCredentials.self
        default:
            return nil
        }
    }

    var logo: NSImage? {
        switch self {
        case .Twitter:
            return NSImage(named: "Twitter Logo")
        default:
            return nil
        }
    }

    var brand: NSImage? {
        switch self {
        case .Twitter:
            return nil
        default:
            return nil
        }
    }

    var clientKey: (String, String)? {
        switch self {
        case .Twitter:
            let apiKey: String = "uH6FFqSPBi1ZG80I6taO5xt24"
            let apiSecret: String = "0gIbzrGYW6CU2W3DoehwuLQz8SXojr8v5z5I2DaBPjm9kHbt16"
            return (apiKey, apiSecret)
        default:
            return nil
        }
    }

}
