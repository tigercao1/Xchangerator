//
//  FUIAuthBaseViewControllerWrapper.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-10.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseUI
import SwiftUI
import SwiftyJSON


// Bridge SwiftUI and UIkit
//https://stackoverflow.com/questions/58353243/firebaseui-and-swiftui-loging
struct FUIAuthBaseViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var stateStore: ReduxRootStateStore
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func makeCoordinator() -> FUIAuthBaseViewControllerWrapper.Coordinator {
        Coordinator(self)
    }

//    typealias UIViewControllerType = UIViewController
    

    func makeUIViewController(context: Context) -> UIViewController {
        let authUI = FUIAuth.defaultAuthUI()
        
     // You need to adopt a FUIAuthDelegate protocol to receive callback
        let providers: [FUIAuthProvider] = [
//            FUIEmailAuth(),  //Todo: freeze or disable email input, after login successfully
            FUIGoogleAuth()
        ]
        authUI?.providers = providers
        authUI?.delegate = context.coordinator
        authUI?.shouldHideCancelButton = true
        //Todo: Terms of Services
//        let xFirebaseTermsOfService = URL(string: "https://firebase.google.com/terms/")!
//        authUI?.tosurl = xFirebaseTermsOfService
//        let xFirebasePrivacyPolicy = URL(string: "https://policies.google.com/privacy")!
//        authUI?.privacyPolicyURL = xFirebasePrivacyPolicy

        let authViewController = authUI?.authViewController()
        
//        authUI.delegate = authViewController as? FUIAuthDelegate
        return authViewController!
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }

   //coordinator
    class Coordinator : NSObject, FUIAuthDelegate {
        var parent : FUIAuthBaseViewControllerWrapper

        init(_ customLoginViewController : FUIAuthBaseViewControllerWrapper) {
            self.parent = customLoginViewController
        }

        // MARK: FUIAuthDelegate
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?)
        {
//            parent.dismiss(authDataResult, error)
            guard error == nil else {
                Logger.error("Err: Failed to sign in with user. User:\(String(describing: authDataResult));Error:\(String(describing: error)) " )
                return
            }

            guard let retObj = authDataResult else {
                Logger.warning("User data corruption: \(String(describing: authDataResult)) " )
                return
            }
/*  Properties of  authDataResult.user  https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Classes/FIRUser#providerdata
             anonymous:BOOL
             emailVerified:BOOL
             refreshToken:NSString
             providerData:NSArray https://firebase.google.com/docs/reference/ios/firebaseauth/api/reference/Protocols/FIRUserInfo.html
             FIRUserMetadata:metadata
             */
            let fcmTokenString = UserRepoManager().getCurDeviceToken(forUserID:"current")
            
            let countriesStarter = ApiCall()
            
            //Set Device token and notification Docs in DB
            Logger.debug("UserRepofcmToken get: \(String(describing: fcmTokenString))")
            DatabaseManager.shared.registerUser(fcmToken: fcmTokenString,fbAuthRet:retObj, alerts:self.parent.stateStore.alerts ) { docSnapShots in
                //let alerts: Array<MyAlert>
                for i in 0..<2 {
//                        init(baseCurrency: Country, targetCurrency: Country, conditionOperator: String, rate: Double, disabled:Bool) {
                    do {
                        let data = docSnapShots[i].data()
                        let str = data["condition"] as? String ?? "CAD-USD-LT"
                        let tar = data["target"] as! Double
                        let disabled = data["disabled"] as! Bool
                        let strArr = str.split(separator: "-")
                        let c1 = try countriesStarter.findByUnit(String(strArr[0]))
                        let c2 = try countriesStarter.findByUnit(String(strArr[1]))
                        
                        let newAlert = MyAlert(baseCurrency: c1, targetCurrency: c2,  conditionOperator:String(strArr.last ?? "LT"),rate:tar,disabled:disabled)
                        self.parent.stateStore.alerts.setById(i, newAlert)

                    } catch {
                        Logger.error(error)
                    }


                }
            }
            self.parent.stateStore.curRoute = .content
            
            if let user = Auth.auth().currentUser  {
                let userProfile = User_Profile(email:user.email ?? "New_\(user.uid)@Xchangerator.com" ,photoURL:user.photoURL!,deviceTokens:[], name:user.displayName ?? "New User")
                let userDoc = User_DBDoc(profile:userProfile)
                
                // todo: refetch state store settings from DB
                self.parent.stateStore.initStore_DocAndCountries(userDoc: userDoc, countries: countriesStarter)
            }
        }

        func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?)
        {
            Logger.debug("Finish \(operation)")
        }
//        // Todo: customize the login page
//        func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
//          return CustomAuthPickerViewController(authUI: authUI)
//        }
//        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//        }
//
        func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
            
            let loginViewController = FUIAuthPickerViewController(authUI: authUI)
            
  
            let logoFrame = self.parent.stateStore.isLandscape ? CGRect(x: screenWidth*0.1, y: screenHeight*0.12, width: screenWidth*0.8, height: screenHeight*0.2): CGRect(x: screenWidth*0.1, y: screenHeight*0.2, width: screenWidth*0.8, height: screenHeight*0.3)
            let logoImageView = UIImageView(frame: logoFrame)
            
//                                Image(colorScheme == .light ? "default-monochrome-black":"default-monochrome").padding(.top, screenHeight*0.3).padding(.horizontal, 10).offset(y:-screenWidth/3)//
            logoImageView.image = UIImage(named: self.parent.colorScheme == .light ? "default-monochrome-black":"default-monochrome")
            logoImageView.contentMode = .scaleAspectFit

            
           
            //fix this once Firebase UI releases the dark mode support for sign-in
            
    //        loginViewController.view.subviews.backgroundColor = .white
    //        loginViewController.view.subviews[0].subviews[0].backgroundColor = .white
            
            loginViewController.view.addSubview(logoImageView)
            loginViewController.view.bringSubviewToFront(logoImageView)
            return loginViewController
        }
        
    }
}

