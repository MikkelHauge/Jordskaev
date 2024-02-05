//
//  EarthquakeDetailView.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 15/05/2023.
//



import SwiftUI
import MapKit

struct EarthquakeDetailView: View {
    
    @EnvironmentObject private var stateController: StateController
    @State private var _region: MKCoordinateRegion
    @State private var _earthquake: Earthquake.Feature
    @State private var favoriteToggle: Bool
    @State private var showMoreDetails = false
    @State private var earthquakeDetails: EarthquakeDetails?
    
    
    init(_earthquake: Earthquake.Feature) {
        self._earthquake = _earthquake
        let coordinates = _earthquake.geometry.coordinates
        let center = CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        _region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        favoriteToggle = _earthquake.properties.favorite
    }

    
    var body: some View {
        ScrollView {
            HStack{
                VStack{
                    Spacer()
                    Text("\(_earthquake.properties.place)")
                        .font(.title2)
                        .foregroundColor(_earthquake.properties.getMagnitudeColor)
                        Map(coordinateRegion: $_region, annotationItems: stateController.earthquakes) { earthquake in
                            MapMarker(coordinate: earthquake.geometry.Mapcoordinates, tint: earthquake.properties.getMagnitudeColor)
                        }
                        .frame(width: 350, height: 400)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.black)
                                
                        )
                    .padding()
                    Spacer()
                }
               
            }
            Button(action: {
                favoriteToggle.toggle()
                print(favoriteToggle.description)
                stateController.toggleLike(_earthquake)
                _earthquake.properties.favorite.toggle()
            }) {
                VStack{
                    Image(systemName: _earthquake.properties.favorite ? "heart.fill" : "heart")
                        .foregroundColor(_earthquake.properties.favorite ? .red : .black)
                    Text("Favorite")
                        .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading){
                if showMoreDetails {
                    if let details = earthquakeDetails {
                        VStack(alignment: .leading, content: {
                            Text("Area:")
                            Text("\(details.properties.place)")
                            
                            Text("Date and Time:")
                            Text("\(_earthquake.properties.formattedDateTime)")
                            
                            Text("Mag Type:")
                            Text("\(details.properties.magType)")
                            
                            Text("Magnitude:")
                            Text("\(_earthquake.properties.magnitude)")
                            
                            Text("Was felt by:")
                            Text("\(details.properties.felt ?? 0) people")
                        })
                        VStack(alignment: .leading, content: {
                            Text("rms:")
                            Text("\(details.properties.rms ?? 0)")
                            Text("Coordinates:")
                            Text("Latitude: \(details.geometry.coordinates[1])")
                            Text("Longitude: \(details.geometry.coordinates[0])")
                            Text("dmin:")
                            Text("\(details.properties.dmin ?? 0)")
                    
                        })
                    }
                }
                
                Button(action: {
                    Task {
                        do {
                            let details = try await stateController.fetchQuakeDetails(Url: _earthquake.properties.detail)
                            earthquakeDetails = details
                            showMoreDetails.toggle()
                            
                        } catch {
                            print(error)
                        }
                    }
                }) {
                    Text(showMoreDetails ? "Hide Details" : "Show Details")
                }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom, 20)
            }
        }
    }
}

    
   

struct ContentView: View {
    var optionalText: String?

    var body: some View {
        VStack {
            Text("Checking optional value")

            guard let text = optionalText else {
                Text("No value available")
                    .font(.title)
                    .foregroundColor(.red)
                return
            }

            Text(text)
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}

struct ContentView: View {
    var optionalText: String?

    var body: some View {
        VStack {
            if let text = optionalText {
                Text(text)
                    .font(.title)
                    .foregroundColor(.blue)
            } else {
                Text("No value available")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
    }
}
