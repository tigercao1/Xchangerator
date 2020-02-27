//
//  Exceptions.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-02-06.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

enum EntityExceptions: Error {
    case EntityNotFoundException(String)
}

enum HTTPRequestExceptions: Error {
    case DataRetrievalException(String)
    case JSONParsingException(String)
}
