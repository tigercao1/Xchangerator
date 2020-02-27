//
//  EnvironStateStore.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation


class ReduxRootStateStore: ObservableObject {
    @Published var curRoute: Key = .auth
    @Published var secondaryRoute: ContentSubKey = .home
    @Published var user: User_DBDoc = User_DBDoc ()

    enum Key: String, CaseIterable {
        case auth, content
    }
    enum ContentSubKey: String, CaseIterable {
        case home, favorites, alerts, settings
    }
}

