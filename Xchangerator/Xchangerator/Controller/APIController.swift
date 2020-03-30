//
//  APIController.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-02-06.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class APIController {
    
    func makeRequest()-> Result<Countries?, NetworkError>  {
        guard let url = URL(string: "https://xchangerator.com/api/latest") else {return .failure(.url)}
        var requestRet: Result<Countries?, NetworkError>!
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { result in
            switch result {
                 case let .success(data, _):
                    do {
                        let decoder = JSONDecoder()
                        let countryList = try decoder.decode(CountryList.self, from: data)
                        let countries = Countries(countryList: countryList)
                        requestRet = .success(countries)
                    } catch {
                        requestRet  =  .failure(.dataFormat)
                    }
                  case let .failure(error):
                     requestRet  =  .failure(error)
            }
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(wallTimeout: .distantFuture)
        return requestRet
    }
}
//apiController.makeRequest{(data) in countries = Countries(countryList:data)}

//        func load() {
//           DispatchQueue.global(qos: .utility).async {
//             let result = self.makeAPICall()
//             DispatchQueue.main.async {
//                 switch result {
//                   case let .success(data):
//                       print(data)
//                    case let .failure(error):
//                       print(error)
//                    }
//                }
//            }
//        }
//        let task = session.dataTask(with: url, completionHandler:  {data, response, error in
//            guard let dataResponse = data,
//                error == nil else {
//                    Logger.error(error?.localizedDescription ?? "Response Error")
//                    return}
//            //here dataResponse received from a network request
//            let decoder = JSONDecoder()
//            let countries = try! decoder.decode(CountryList.self, from: dataResponse)
//            completion(countries)
//        })
//        task.resume()


//Building Simple Async API Request With Swift 5 Result Type
//https://medium.com/@alfianlosari/building-simple-async-api-request-with-swift-5-result-type-alfian-losari-e92f4e9ab412

//Swift 5: How to do Async/Await with Result and GCD
//https://medium.com/@michaellong/how-to-chain-api-calls-using-swift-5s-new-result-type-and-gcd-56025b51033c

extension URLSession {
    func dataTask(with url: URL, completion: @escaping (Result<(Data,URLResponse), NetworkError>) -> Void) -> URLSessionDataTask {
    return dataTask(with: url) { (data, response, error) in
        if let error = error {
            Logger.error(error)
            completion(.failure(.server))
            return
        }
        guard let response = response, let data = data else {
            completion(.failure(.server))
            return
        }
        completion(.success((data, response)))
    }
}
}
