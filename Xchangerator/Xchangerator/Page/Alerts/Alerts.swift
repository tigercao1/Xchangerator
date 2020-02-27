//
//  Alerts.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-02-26.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation
import FirebaseUI
import SwiftUI
import CoreLocation
import MapKit

//get current location
//https://www.raywenderlich.com/5247-core-location-tutorial-for-ios-tracking-visited-locations
struct Alerts: View {

    var body: some View {
        NavigationView{
             VStack{
                MapView(centerCoordinate: .constant(ottawaCoordinate), annotations:
                    [CustomAnnotationPoint(
                        title: "London",
                        subtitle: "Summer Plan",
                        coordinate: MKPointAnnotation.example.coordinate),
                     CustomAnnotationPoint(
                         title: "Home",
                         subtitle: "MyApartment",
                         coordinate: ottawaCoordinate)])
                
             }.navigationBarTitle(Text("Alerts"))//
        }
    }

}
