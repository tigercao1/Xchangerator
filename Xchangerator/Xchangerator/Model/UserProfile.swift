//
//  DataStruct.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import MapKit
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
        photoURL =  nil
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

// make your own annotation image For Mapkit
//https://developer.apple.com/documentation/mapkit/mapkit_annotations/annotating_a_map_with_custom_data
struct CustomAnnotationPoint: Hashable {
    
    let id = UUID()
    let title: String
    let subtitle: String
    let coordinates: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        self.title = title
        self.subtitle = subtitle
        
        self.coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        
        self.init(title: title, subtitle: subtitle,
                  lat: coordinate.latitude, long: coordinate.longitude)
    }
    
    var annotationPt: MKPointAnnotation {
        
        let newAnnoPoint = MKPointAnnotation()
        
        newAnnoPoint.title = self.title
        newAnnoPoint.subtitle = self.subtitle
        newAnnoPoint.coordinate = self.coordinates
        
        return newAnnoPoint
        
    }
    
    // MARK: Hashable
    static func == (lhs: CustomAnnotationPoint, rhs: CustomAnnotationPoint) -> Bool {
        return (lhs.coordinates.latitude == rhs.coordinates.latitude) ||
            (lhs.coordinates.longitude == rhs.coordinates.longitude)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
