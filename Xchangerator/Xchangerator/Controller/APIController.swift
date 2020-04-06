//
//  APIController.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-02-06.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class APIController {
    
    func makeCountriesRequest()-> Result<Array<Countries>?, NetworkError>  {
        guard let url = URL(string: Constant.xAPIGetLatest) else {return .failure(.url)}
        var requestRet: Result<Array<Countries>?, NetworkError>!
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { result in
            switch result {
                 case let .success((data, _)):
                    do {
                        let decoder = JSONDecoder()
                        let countryList = try decoder.decode(CountryList.self, from: data)
                        let countries = Countries(countryList: countryList)
                        let fullCountries = Countries(countryList: countryList, ifFull: true)
                        requestRet = .success([countries, fullCountries])
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
//Swift 5: How to do Async/Await with Result and GCD
//https://medium.com/@michaellong/how-to-chain-api-calls-using-swift-5s-new-result-type-and-gcd-56025b51033c

/*
 Our load function puts our call on a concurrent background thread using DispatchQueue.global(qos: .utility).async, and then calls our makeAPICall.
 It then switches back to the main thread to handle the result, which is either the data we wanted (success) or an error of type NetworkError (failure).
 */
//
//Here our load function makes several consecutive API calls in the background, each time passing the result of one call to the next. We then handle the final result back on the main thread, or in the case of one of our calls failing, we handle the resulting error.
//func load() {
//      DispatchQueue.global(qos: .utility).async {
//         let result = self.makeAPICall()
//              .flatMap { self.anotherAPICall($0) }
//              .flatMap { self.andAnotherAPICall($0) }
//
//          DispatchQueue.main.async {
//              switch result {
//              case let .success(data):
//                  print(data)
//              case let .failure(error):
//                  print(error)
//              }
//          }
//      }
//  }

//Building Simple Async API Request With Swift 5 Result Type
//https://medium.com/@alfianlosari/building-simple-async-api-request-with-swift-5-result-type-alfian-losari-e92f4e9ab412





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


func ApiCall() -> Array<Countries> {
    let apiController = APIController()
// Here it's running in the forground, later maybe change it to the background with another thread. For know-how, see comments in APIController
    let result = apiController.makeCountriesRequest()
    switch result {
    case let .success(data):
        guard let arrayOfCountries = data else {
            Logger.error("Countries cast failed")
            return [Countries(), Countries()]
        }
        return arrayOfCountries
    case let .failure(error):
        Logger.error(error)
        return [Countries(), Countries()]
    }
}
