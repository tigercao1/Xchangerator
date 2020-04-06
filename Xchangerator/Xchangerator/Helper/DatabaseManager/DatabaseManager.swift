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
    
    private func addDocsToNotifications( userRef: DocumentReference, alerts:MyAlerts) {
        let Doc1 = Notification_Document(alerts.getModel()[0]);
        let Doc2 = Notification_Document(alerts.getModel()[1]);
        _ = try? userRef.collection("notifications").addDocument(from: Doc1){ err in
            if let err = err {
                Logger.error("Err adding doc1: \(err)")
            } else {
                Logger.debug("adding doc1 ")
                _ = try? userRef.collection("notifications").addDocument(from: Doc2){ err in
                    if let err = err {
                        Logger.error("Err adding doc2: \(err)")
                        
                    } else {
                        Logger.debug("adding doc2")
                        
                    }
                }
            }

        }
    }

    func registerUser(fcmToken firebaseMsgDeviceToken:String?,fbAuthRet authDataResult:AuthDataResult, alerts:MyAlerts, completion: @escaping ([QueryDocumentSnapshot]) ->Void) {
        //Result<Countries?, NetworkError> 
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
            var newTokenArr = Array<String>()

            if let document = document, document.exists {
                //handle existing user
                let deviceTokens = document.get("profile.deviceTokens") as? Array<String>
//                if (deviceTokens == nil || deviceTokens == "") {deviceTokens=[]}
                newTokenArr = deviceTokens ?? Array<String>()
            
                if let wrappedFcmToken = firebaseMsgDeviceToken  {
                    if (!newTokenArr.contains(wrappedFcmToken)) {
                        newTokenArr.append(wrappedFcmToken)
                    }
                }
                newTokenArr = newTokenArr.filter{ $0 != "" }
                Logger.debug("Old user:pre tokens count \(String(describing: deviceTokens?.count)));new tokens coount\(newTokenArr.count)")
                
               
                
            } else {
                //create all the fields for the new user
                if let wrappedFcmToken = firebaseMsgDeviceToken  {
                        newTokenArr.append(wrappedFcmToken)
                }
                
            }
             userProfile = User_Profile(email:user.email ?? "\(uid)@Xchangerator.com" ,photoURL:user.photoURL,deviceTokens:newTokenArr, name:user.displayName ?? "Loyal Customer")
            
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
                                if (querySnapshot!.documents.count < 2 ) {
                                    self.addDocsToNotifications(userRef: userRef,alerts: alerts)
                                } else {
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
