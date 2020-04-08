//
//  DatabaseManager.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-09.
//  Copyright © 2020 YYES. All rights reserved.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseUI
import Foundation

// TODO: Change from singleton to dependency injection with protocols
// https://swiftwithmajid.com/2019/03/06/dependency-injection-in-swift-with-protocols/

class DatabaseManager {
    static var shared = DatabaseManager()
    private var db = Firestore.firestore()

    func updateUserAlert(index: Int, myAlerts: MyAlerts, completion: @escaping (Result<MyAlerts?, NetworkError>) -> Void) {
        let doc = Notification_Document(myAlerts.getModel()[index])
        if let user = Auth.auth().currentUser {
            // User is signed in.
            let userCollectionRef = db.collection("users")
            try? userCollectionRef
                .document("\(Constant.xDBtokenPrefix)\(user.uid)")
                .collection("notifications")
                .document("\(user.uid)\(Constant.xDBnotiSuffix)\(index)")
                .setData(from: doc) { err in
                    if let err = err {
                        Logger.error("Error set notif: \(err), \(user.uid)\(Constant.xDBnotiSuffix)\(index)")
                        completion(.failure(.auth("DB set Notif err")))
                        return
                    } else {
                        let myNewAlerts = myAlerts.copy() as! MyAlerts
                        completion(.success(myNewAlerts))
                        return
                    }
                }

        } else {
            // No user is signed in.
            // ...
            Logger.error("Not signed in when setting notifications")
            completion(.failure(.auth("DBuserAuth failure")))
            return
        }
    }

    private func addDocsToNotifications(userRef: DocumentReference, alerts: MyAlerts, user: User) {
        let Doc1 = Notification_Document(alerts.getModel()[0])
        let Doc2 = Notification_Document(alerts.getModel()[1])
        _ = try? userRef.collection("notifications")
            .document("\(user.uid)\(Constant.xDBnotiSuffix)0")
            .setData(from: Doc1) { err in
                if let err = err {
                    Logger.error("Err adding notif1: \(err)")
                } else {
                    Logger.debug("added: \(user.uid)\(Constant.xDBnotiSuffix)0")
                    _ = try? userRef.collection("notifications")
                        .document("\(user.uid)\(Constant.xDBnotiSuffix)1")
                        .setData(from: Doc2) { err in
                            if let err = err {
                                Logger.error("Err adding notif2: \(err)")
                            } else {
                                Logger.debug("added: \(user.uid)\(Constant.xDBnotiSuffix)1")
                            }
                        }
                }
            }
    }

    func registerUser(fcmToken firebaseMsgDeviceToken: String?, fbAuthRet authDataResult: AuthDataResult, alerts: MyAlerts, completion: @escaping ([QueryDocumentSnapshot]) -> Void) {
        // Result<Countries?, NetworkError>
        // [START add_ada_lovelace]
        /*
                    anonymous:BOOL
                    emailVerified:BOOL
                    refreshToken:NSString
                    providerData:NSArray https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Protocols/FIRUserInfo.html
                    FIRUserMetadata:metadata
         r  */
        let user = authDataResult.user
        // The user's ID, unique to the Firebase project.
        // Do NOT use this value to authenticate with your backend server,
        // if you have one. Use getTokenWithCompletion:completion: instead.
        let uid = user.uid
        let userCollectionRef = db.collection("users")
        let userRef = userCollectionRef.document("\(Constant.xDBtokenPrefix)\(uid)")
        userRef.getDocument { document, error in
            var userProfile: User_Profile
            var newTokenArr = [String]()

            if let document = document, document.exists {
                // handle existing user
                let deviceTokens = document.get("profile.deviceTokens") as? [String]
                newTokenArr = deviceTokens ?? [String]()

                if let wrappedFcmToken = firebaseMsgDeviceToken {
                    if !newTokenArr.contains(wrappedFcmToken) {
                        newTokenArr.append(wrappedFcmToken)
                    }
                }
                newTokenArr = newTokenArr.filter { $0 != "" }
                Logger.debug("Old user:pre tokens count \(deviceTokens?.count ?? 0);new tokens count \(newTokenArr.count)")

            } else {
                // create all the fields for the new user
                if let wrappedFcmToken = firebaseMsgDeviceToken {
                    newTokenArr.append(wrappedFcmToken)
                }
            }
            userProfile = User_Profile(email: user.email ?? "\(uid)@Xchangerator.com", photoURL: user.photoURL, deviceTokens: newTokenArr, name: user.displayName ?? "Loyal Customer")

            let userDoc = User_DBDoc(profile: userProfile)
            // set user profile everytime you logged in
            try? userRef.setData(from: userDoc) { err in
                if let err = err {
                    Logger.error("Error adding document: \(err), and token \(String(describing: firebaseMsgDeviceToken))")
                } else {
                    userRef.collection("notifications").getDocuments { querySnapshot, err in
                        if let err = err {
                            Logger.error("Error getting documents: \(err)")
                        } else { // notif docs in DB < 2
                            if querySnapshot!.documents.count < 2 {
                                // init local alerts
                                self.addDocsToNotifications(userRef: userRef, alerts: alerts, user: user)
                            } else {
                                // fetch real alerts data
                                completion(querySnapshot!.documents)
                            }
                        }
                    }
                }
            }
        }
        // [END register User]
    }
}
