//
//  NetworkController.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 15/05/2023.
//

import Foundation
class NetworkController {
    
    // henter jordskævl via api'en.
    // returnerer altid "data", men nogle gange er dataen jo bare tom, fordi api'en måske er nede.
    static func getDataFrom(_ url: String) async -> Data {
        guard let urlToFetchFrom = URL(string: url) else { return Data() }
        do {
            let (data, response) = try await URLSession.shared.data(from: urlToFetchFrom)
            let httpurlresponse = response as! HTTPURLResponse
            if httpurlresponse.statusCode == 200 {
                return data
            } else {
                return Data()
            }
        } catch {
            print(error)
            return Data()
        }
    }
}

