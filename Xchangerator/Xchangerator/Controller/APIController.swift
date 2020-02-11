//
//  APIController.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-02-06.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class APIController {
    
    func makeRequest(_ completion: @escaping (Dictionary<String, Double>) -> ()) -> Void {
        let session = URLSession.shared
        let url = URL(string: "https://xchangerator.com/api/latest")!
        let task = session.dataTask(with: url, completionHandler: {data, response, error in
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    // try to read out a string array
                    let rates = json["rates"] as! [String: Double]
                    completion(rates)
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            // Do something...
        })
        task.resume()
    }
    
    func returnRates(_ rates: Dictionary<String, Double>) -> Dictionary<String, Double> {
        return rates
    }
    
}
