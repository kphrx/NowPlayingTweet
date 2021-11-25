/**
 *  Account.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Foundation

protocol Account {

    static var provider: Provider { get }

    var id: String { get }
    var name: String { get }
    var username: String { get }
    var avaterUrl: URL { get }

    init(id: String, name: String, username: String, avaterUrl: URL)

}

extension Account {

    func isEqual(_ account: Account?) -> Bool {
        guard let account = account else {
            return false
        }

        return type(of: self).provider == type(of: account).provider
            && self.id == account.id
    }

}
