//
//  FavoriteConversions.swift
//  Xchangerator
//
//  Created by Yizhang Cao on 2020-03-10.
//  Copyright © 2020 YYES. All rights reserved.
//

import Foundation

class FavoriteConversions: ObservableObject {
    var conversions = [FavoriteConversion]()

    func add(_ favConversion: FavoriteConversion) {
        conversions.append(favConversion)
    }

    func findById(_ id: String) throws -> FavoriteConversion {
        for conversion in conversions {
            if conversion.id == UUID(uuidString: id) {
                return conversion
            }
        }
        throw EntityExceptions.EntityNotFoundException("Conversion with id " + id + " not found!")
    }

    func find(_ conversion: FavoriteConversion) throws -> FavoriteConversion {
        for c in conversions {
            if c == conversion {
                return c
            }
        }
        throw EntityExceptions.EntityNotFoundException("Conversion between " + conversion.baseCurrency.name + " and " + conversion.targetCurrency.name + " not found!")
    }

    func delete(_ conversion: FavoriteConversion) throws -> FavoriteConversion {
        var temp: FavoriteConversion
        do {
            temp = try find(conversion)
            if let index = conversions.firstIndex(of: temp) {
                conversions.remove(at: index)
            }
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("Conversion " + conversion.baseCurrency.name + " and " + conversion.targetCurrency.name + " not deleted")
        }
        print("Conversion " + conversion.baseCurrency.name + " and " + conversion.targetCurrency.name + " deleted")
        return temp
    }

    func deleteById(_ id: String) throws -> FavoriteConversion {
        var temp: FavoriteConversion
        do {
            temp = try findById(id)
            if let index = conversions.firstIndex(of: temp) {
                conversions.remove(at: index)
            }
        } catch is EntityExceptions {
            throw EntityExceptions.EntityNotFoundException("Conversion with id " + id + " not deleted")
        }
        print("Conversion with id " + id + " deleted")
        return temp
    }

    func getModel() -> [FavoriteConversion] {
        return conversions
    }
}
