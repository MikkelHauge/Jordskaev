import Foundation
import CoreLocation
import SwiftUI
import MapKit

struct Earthquake: Codable {
    var features: [Feature]
    
    struct Feature: Codable, Identifiable {
        var properties: Properties
        let geometry: Geometry
        var id: String
        
        struct Properties: Codable {
            let mag: Double
            let place: String
            let time: Int
            let detail: String
            
            enum CodingKeys: String, CodingKey {
                case mag
                case place
                case time
                case detail
            }
            
            var favorite: Bool = false // "Hmm... interessant" ❤️
            
            // returnerer pæn dansk dato og tidsformat :)
            // extension i bunden
            var formattedDateTime: String {
                let date = Date(timeIntervalSince1970: TimeInterval(time) / 1000)
                return DateFormatter.danishDateTimeFormatter.string(from: date)
            }
            
            // returnerer bare et lidt pænere "magnitude" tal med 2 decimaler.
            var magnitude: String {
                return String(format: "%.2f", mag)
            }
            
            
            var getMagnitudeColor: Color {
                switch mag {
                case -100..<1.5:
                    return Color(.green) // green
                case 1.5..<3:
                    return Color(.yellow) // yellow
                case 3..<5:
                    return Color(.orange) // orange
                case 5..<100:
                    return Color(.red) // red
                default:
                    return Color(.green) // green
                }
            }
        }
        
        
        struct Geometry: Codable {
            let type: String
            let coordinates: [Double]
            var Mapcoordinates: CLLocationCoordinate2D {
                       CLLocationCoordinate2D(
                        latitude: coordinates[1],
                        longitude: coordinates[0])
                   }
        }
    }
}


extension DateFormatter {
    static let danishDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "da_DK")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
