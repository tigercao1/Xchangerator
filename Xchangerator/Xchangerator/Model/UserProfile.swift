//
//  DataStruct.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
public struct User_Profile: Codable {

    let email: String
    let photoURL: URL?
    let deviceTokens: Array<String>
    let name:String

    enum CodingKeys: String, CodingKey {
        case email
        case photoURL
        case deviceTokens  //deviceTokens
        case name
    }
    
    //Default image"https://pbs.twimg.com/profile_images/1218947796671324162/oWGgRsyn_400x400.jpg"
    
    init(){
        email = ""
        photoURL = URL(string:Constant.xAvatarLogo)
        deviceTokens = []
        name = ""
    }
    init(email:String ,photoURL:URL?,deviceTokens:Array<String>, name:String){
        self.email = email
        self.photoURL =  photoURL
        self.deviceTokens = deviceTokens
        self.name = name
    }

}
public struct User_DBDoc: Codable {

    let profile: User_Profile

    enum CodingKeys: String, CodingKey {
        case profile
    }
    
    init(){
        profile = User_Profile()
    }
    init (profile:User_Profile) {
        self.profile = profile
    }
}
