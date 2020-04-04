//
//  DatabaseManager.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-09.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseUI
import FirebaseFirestore
import FirebaseFirestoreSwift

//Todo: Change from singleton to dependency injection with protocols
//https://swiftwithmajid.com/2019/03/06/dependency-injection-in-swift-with-protocols/

class DatabaseManager {
    static var shared = DatabaseManager()
    private var db = Firestore.firestore()
    
    private func addDocsToNotifications( userRef: DocumentReference) {
        let Doc1 = Notification_Document(condition: "USD-EUR-LT", disabled: false, target: 1.2);
        let Doc2 = Notification_Document(condition: "CNY-CAD-LT", disabled: false, target: 5.0);
        _ = try? userRef.collection("notifications").addDocument(from: Doc1){ err in
            if let err = err {
                Logger.error("Err adding doc1: \(err)")
            } else {
                Logger.debug(" adding doc1 ")
                _ = try? userRef.collection("notifications").addDocument(from: Doc2){ err in
                    if let err = err {
                        Logger.error("Err adding doc2: \(err)")
                        
                    } else {
                        Logger.debug(" adding doc2")
                        
                    }
                }
            }

        }
    }

    func registerUser(fcmToken firebaseMsgDeviceToken:String?,fbAuthRet authDataResult:AuthDataResult) {
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
        let userCollectionRef = self.db.collection("users")
        let userRef = userCollectionRef.document("\(Constant.xDBtokenPrefix)\(uid)")
        userRef.getDocument { (document, error) in
            var userProfile:User_Profile
            if let document = document, document.exists {
                //handle existing user
                let deviceTokens = document.get("profile.deviceTokens") as? Array<String>
//                if (deviceTokens == nil || deviceTokens == "") {deviceTokens=[]}
                var newTokenArr = deviceTokens ?? Array<String>()
            
                if let wrappedFcmToken = firebaseMsgDeviceToken  {
                    if (!newTokenArr.contains(wrappedFcmToken)) {
                        newTokenArr.append(wrappedFcmToken)
                    }
                }
                newTokenArr = newTokenArr.filter{ $0 != "" }
                Logger.debug("Old user:pre tokens count\(String(describing: deviceTokens?.count))); \n new tokens coount\(newTokenArr.count)")
                
                userProfile = User_Profile(email:user.email ?? "Loyal_\(uid)@Xchangerator.com" ,photoURL:user.photoURL!,deviceTokens:newTokenArr, name:user.displayName ?? "Loyal customer")
                
            } else {
                //create all the fields for the new user
                var newTokenArr = Array<String>()
                if let wrappedFcmToken = firebaseMsgDeviceToken  {
                        newTokenArr.append(wrappedFcmToken)
                }
                userProfile = User_Profile(email:user.email ?? "New_\(uid)@Xchangerator.com" ,photoURL:user.photoURL!,deviceTokens:newTokenArr, name:user.displayName ?? "New User")
                //Todo:add subcollection and 2 sub doc
                
            }
            let userDoc = User_DBDoc(profile:userProfile)
            try? userRef.setData( from:userDoc ) { err in
                if let err = err {
                    Logger.error("Error adding document: \(err), and token \(String(describing: firebaseMsgDeviceToken))")
                } else {
                    //Logger.debug("User Doc set with ID: \(String(describing: userRef.documentID)), token:\(String(describing: firebaseMsgDeviceToken))")
                    userRef.collection("notifications").getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                Logger.error("Error getting documents: \(err)")
                            } else {
                                if (querySnapshot!.documents.count <= 2 ) {
                                    self.addDocsToNotifications(userRef: userRef)
                                }
                            }
                        }
                    
                }
            }
        }
        // [END register User]
    }
    
}
