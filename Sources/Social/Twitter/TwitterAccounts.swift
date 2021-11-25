/**
 *  TwitterAccounts.swift
 *  NowPlayingTweet
 *
 *  © 2019 kPherox.
**/

import Foundation
import KeychainAccess

class TwitterAccounts: ProviderAccounts {

    private(set) var storage: [String : (Account, Credentials)] = [:]

    private let keychainPrefix: String

    private var keychainName: String {
        return "\(self.keychainPrefix).\(Provider.Twitter)"
    }

    required init(keychainPrefix: String) {
        self.keychainPrefix = keychainPrefix
        let keychain = Keychain(service: self.keychainName)

        var ids = keychain.allKeys()
        self.initializeNotification(ids.count)

        for id in keychain.allKeys() {
            guard let encodedCredentials: Data = try? keychain.getData(id)
                , let credentials: TwitterCredentials = try? JSONDecoder().decode(TwitterCredentials.self, from: encodedCredentials) else {
                    self.deleteFromKeychain(id: id)
                    ids.removeAll { $0 == id }
                    self.initializeNotification(ids.count)
                    continue
            }

            TwitterClient(credentials)!.verify(handler: {
                account in
                defer {
                    ids.removeAll { $0 == id }
                    self.initializeNotification(ids.count)
                }

                guard let account = account as? TwitterAccount else {
                    self.deleteFromKeychain(id: id)
                    return
                }

                self.storage[id] = (account, credentials)
            }, failure: { _ in
                self.deleteFromKeychain(id: id)
                ids.removeAll { $0 == id }
                self.initializeNotification(ids.count)
            })
        }
    }

    private func initializeNotification(_ count: Int) {
        if count == 0 {
            NotificationQueue.default.enqueue(.init(name: .socialAccountsInitialize,
                                                    object: nil,
                                                    userInfo: ["provider": Provider.Twitter]),
                                              postingStyle: .whenIdle)
        }
    }

    func saveToKeychain(account: Account, credentials: Credentials) {
        guard let account = account as? TwitterAccount
            , let credentials = credentials as? TwitterCredentials
            , let data: Data = try? JSONEncoder().encode(credentials) else {
            return
        }

        let keychain = Keychain(service: self.keychainName)
        try? keychain.set(data, key: account.id)
        self.storage[account.id] = (account, credentials)
    }

    func deleteFromKeychain(id: String) {
        let keychain = Keychain(service: self.keychainName)
        try? keychain.remove(id)
        self.storage.removeValue(forKey: id)
    }

}
