//
//  StateController.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 15/05/2023.
//

import Foundation
import CoreLocation
import MapKit

@MainActor
class StateController: ObservableObject {
    
    @Published var earthquakes: [Earthquake.Feature] = []
    @Published var likedEarthquakes: [Earthquake.Feature] = []
    @Published var currentEQSpan: EarthquakeSpan = .Hour // Hour = default, fordi det er den tab man starter på, i appen.

    // region map udsnit med "default" til Danmark, sådan nogenlunde.
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 56.334_900,
            longitude: 10.009_020),
            latitudinalMeters: 250200,
            longitudinalMeters: 250200
    )
    
    // henter "details" siden på et enkelt jordskælv (kedelig data.. sorry!)
    func fetchQuakeDetails(Url: String) async throws -> EarthquakeDetails {
        let fetchedDetailsData = await NetworkController.getDataFrom(Url)
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .millisecondsSince1970
        let earthquakeDetails = try decoder.decode(EarthquakeDetails.self, from: fetchedDetailsData)
        return earthquakeDetails
    }
    
    
    
    func fetchQuakes(for span: EarthquakeSpan) {
        print("Fetching earthquakes")
        Task(priority: .high) {
            let fetchedData = await NetworkController.getDataFrom(span.rawValue)
            do {
                let decoder = JSONDecoder()
                let earthquakesFeatures = try decoder.decode(Earthquake.self, from: fetchedData)
                
                let earthquakes = earthquakesFeatures.features
                
                // Sorter efter "magnitude", største først.
                let sortedQuakesFeatures = earthquakes.sorted { $0.properties.mag > $1.properties.mag }
                
                self.earthquakes = sortedQuakesFeatures
                
                // sætter de jordskælv, som OGSÅ findes i "liked", som favorit
                for (index, earthquake) in self.earthquakes.enumerated() {
                    if likedEarthquakes.contains(where: { $0.id == earthquake.id }) {
                        self.earthquakes[index].properties.favorite = true
                    }
                }
            } catch {
                print(error)
                fatalError("Error while decoding data to earthquakes")
            }
        }
         print("Done fetching")
         loadLikedEarthquakes()
    }
    
    
    // indlæs "liked" jordskælv
    func loadLikedEarthquakes() {
        if let data = UserDefaults.standard.data(forKey: "liked") {
            if let likedEarthquakes = try? JSONDecoder().decode([Earthquake.Feature].self, from: data) {
                self.likedEarthquakes = likedEarthquakes
            }
        }
    }

    // gem "liked" jordskælv (I userdefaults)
    func saveLikedEarthquakes() {
        let likedEarthquakes = earthquakes.filter { $0.properties.favorite }
        if let data = try? JSONEncoder().encode(likedEarthquakes) {
            UserDefaults.standard.set(data, forKey: "liked")
        }
    }
    
    // Sæt "Favorit" jordskælv, og gem!
    func toggleLike(_ earthquake: Earthquake.Feature) {
        if let index = earthquakes.firstIndex(where: { $0.id == earthquake.id }) {
            var mutableEarthquake = earthquakes[index]
            mutableEarthquake.properties.favorite.toggle()
            earthquakes[index] = mutableEarthquake
            
            if mutableEarthquake.properties.favorite {
                if !likedEarthquakes.contains(where: { $0.id == mutableEarthquake.id }) {
                    likedEarthquakes.append(mutableEarthquake)
                }
            } else {
                likedEarthquakes.removeAll(where: { $0.id == mutableEarthquake.id })
            }
            saveLikedEarthquakes()
        }
    }
}
