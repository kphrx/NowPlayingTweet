/**
 *  Credentials.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Foundation

protocol Credentials {

    static var oauthVersion: OAuth { get }

    var apiKey: String { get }
    var apiSecret: String { get }

}
