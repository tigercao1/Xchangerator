//
//  UserRepoManger.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-25.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class UserRepoManager {
    enum Key: String, CaseIterable {
        case name, avatarData, fcmToken
        func make(for userID: String) -> String {
            return self.rawValue + "_" + userID
        }
    }
    let userDefaults: UserDefaults
    // MARK: - Lifecycle
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    // MARK: - API
    func storeCurDeviceToken(forUserID userID: String, token: String) {
        saveValue(forKey: .fcmToken, value: token, userID: userID)
    }
    
    func storeInfo(forUserID userID: String, name: String, avatarData: Data) {
        saveValue(forKey: .name, value: name, userID: userID)
        saveValue(forKey: .avatarData, value: avatarData, userID: userID)
    }
    
    func getUserInfo(forUserID userID: String) -> (name: String?, avatarData: Data?) {
        let name: String? = readValue(forKey: .name, userID: userID)
        let avatarData: Data? = readValue(forKey: .avatarData, userID: userID)
        return (name, avatarData)
    }
    
    func removeUserInfo(forUserID userID: String) {
        Key
            .allCases
            .map { $0.make(for: userID) }
            .forEach { key in
                userDefaults.removeObject(forKey: key)
        }
    }
    // MARK: - Private
    private func saveValue(forKey key: Key, value: Any, userID: String) {
        #if DEBUG
        Logger.info("\(key.make(for: userID)) stored in User Repo")
        #endif
        userDefaults.set(value, forKey: key.make(for: userID))
    }
    private func readValue<T>(forKey key: Key, userID: String) -> T? {
        return userDefaults.value(forKey: key.make(for: userID)) as? T
    }
}
