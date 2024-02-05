//
//  EarthquakeDetails.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 16/05/2023.
//



import Foundation

struct EarthquakeDetails: Codable {
    let type: String
    let properties: EarthquakeProperties
    let geometry: Geometry
    let id: String
}

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

// bruger ikke alle af disse.
struct EarthquakeProperties: Codable {
    var mag: Double?
    var place: String = ""
    var time: Int?
    var updated: Int?
    var url: String = ""
    var felt: Int?
    var status: String = ""
    var tsunami: Int?
    var sig: Int?
    var net: String = ""
    var code: String = ""
    var ids: String = ""
    var sources: String = ""
    var types: String = ""
    var nst: Int?
    var dmin: Double?
    var rms: Double?
    var magType: String = ""
    var type: String = ""
    var title: String = ""
}
