/**
 *  TwitterAccount.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Foundation

struct TwitterAccount: Account, Equatable {

    static let provider = Provider.Twitter

    public let id: String
    public let name: String
    public let username: String
    public let avaterUrl: URL

    init(id: String, name: String, username: String, avaterUrl: URL) {
        self.id = id
        self.name = name
        self.username = username
        self.avaterUrl = avaterUrl
    }

}
