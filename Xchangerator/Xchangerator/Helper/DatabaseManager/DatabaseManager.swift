//
//  DatabaseManager.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-09.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

//Todo: Change from singleton to dependency injection with protocols
//https://swiftwithmajid.com/2019/03/06/dependency-injection-in-swift-with-protocols/

class DatabaseManager {
    static var shared = DatabaseManager()
    var db = Firestore.firestore()

    func addDeviceToken(token firebaseMsgDeviceToken:String) {
        // [START add_ada_lovelace]
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "DBtest",
            "last": "Zhang",
            "born": 1987,
            "deviceToken":firebaseMsgDeviceToken
        ]) { err in
            if let err = err {
                Logger.error("Error adding document: \(err), and token \(firebaseMsgDeviceToken)")
            } else {
                Logger.info("Document added with ID: \(String(describing: ref?.documentID)), token:\(firebaseMsgDeviceToken)")
            }
        }
        // [END add_ada_lovelace]
    }
    
    func registerUser(token firebaseMsgDeviceToken:String) {
        // [START add_ada_lovelace]
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "DBtest",
            "last": "Zhang",
            "born": 1987,
            "deviceToken":firebaseMsgDeviceToken
        ]) { err in
            if let err = err {
                Logger.error("Error adding document: \(err), and token \(firebaseMsgDeviceToken)")
            } else {
                Logger.info("Document added with ID: \(String(describing: ref?.documentID)), token:\(firebaseMsgDeviceToken)")
            }
        }
        // [END add_ada_lovelace]
    }
}
