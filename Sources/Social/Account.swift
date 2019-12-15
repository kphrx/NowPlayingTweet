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

    var name: String { get set }
    var username: String { get set }
    var avaterUrl: URL { get set }

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
