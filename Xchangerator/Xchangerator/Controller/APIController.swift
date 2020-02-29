//
//  APIController.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-02-06.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class APIController {
    
    func makeRequest(_ completion: @escaping(CountryList) -> ()) {
        let session = URLSession.shared
        guard let url = URL(string: "https://xchangerator.com/api/latest") else {return}
        let task = session.dataTask(with: url, completionHandler:  {data, response, error in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return}
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            let countries = try! decoder.decode(CountryList.self, from: dataResponse)
            completion(countries)
        })
        task.resume()
    }
    
}
