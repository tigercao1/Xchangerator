//
//  SwiftUIView.swift
//  Xchangerator
//
//  Created by 张一唯 on 2020-01-27.
//  Copyright © 2020 YYES. All rights reserved.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FavoriteView: View {
    let db = Firestore.firestore()

    private func addAdaLovelace() {
        // [START add_ada_lovelace]
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // [END add_ada_lovelace]
    }
    private func addAlanTuring() {
        var ref: DocumentReference? = nil

        // [START add_alan_turing]
        // Add a second document with a generated ID.
        ref = db.collection("users").addDocument(data: [
            "first": "Alan",
            "middle": "Mathison",
            "last": "Turing",
            "born": 1912
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // [END add_alan_turing]
    }
    private func getCollection() {
        // [START get_collection]
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        // [END get_collection]
    }
    private func listenForUsers() {
         // [START listen_for_users]
         // Listen to a query on a collection.
         //
         // We will get a first snapshot with the initial results and a new
         // snapshot each time there is a change in the results.
         db.collection("users")
             .whereField("born", isLessThan: 1900)
             .addSnapshotListener { querySnapshot, error in
                 guard let snapshot = querySnapshot else {
                     print("Error retreiving snapshots \(error!)")
                     return
                 }
                 print("Current users born before 1900: \(snapshot.documents.map { $0.data() })")
             }
         // [END listen_for_users]
     }
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button(action: self.addAdaLovelace) {
            Text("AddAdaLovelace")
            }
            Button(action: self.addAlanTuring) {
            Text("AddAlanTuring")
            }
            Button(action:self.getCollection) {
            Text("getCollection")
            }
            Button(action: self.listenForUsers) {
            Text("listenForUsers")
            }
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
