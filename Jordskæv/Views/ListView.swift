//
//  Skælvview.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 15/05/2023.
//
import SwiftUI
import MapKit

struct ListView: View {
    @EnvironmentObject var stateController: StateController
    
    var navTitle: String {
        return "Showing: \(stateController.earthquakes.count) earthquakes the last \(stateController.currentEQSpan)"
    }
    
    var body: some View {
        NavigationView {
            List(stateController.earthquakes) { quake in
                NavigationLink(destination: EarthquakeDetailView(_earthquake: quake).environmentObject(stateController)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(quake.properties.place)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 4, x: 0, y: 2)
                            
                            Text("\(quake.properties.formattedDateTime)")
                                .font(.subheadline)
                                .foregroundColor(.cyan)
                                .shadow(color: .black, radius: 4, x: 0, y: 2)
                            
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            
                            Text("Magnitude:")
                                .font(.caption)
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 4, x: 0, y: 2)
                            
                            Text("\(quake.properties.magnitude)")
                                .font(.title)
                                .foregroundColor(quake.properties.getMagnitudeColor)
                                .fontWeight(.semibold)
                                .shadow(color: .black, radius: 4, x: 0, y: 2)
                            Button {
                                stateController.toggleLike(quake)
                            } label: {
                                Image(systemName: quake.properties.favorite ? "heart.fill" : "heart")
                                    .foregroundColor(quake.properties.favorite ? .red : .black)
                            }
                            
                            
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    
                }
                
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill((quake.properties.favorite ? Color.black : Color.gray).gradient)
                        
                        .shadow(color: .black, radius: 6, x: 2, y: 2)
                )
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .swipeActions {
                    Button {
                        stateController.toggleLike(quake)
                    } label: {
                        Image(systemName: quake.properties.favorite ? "heart.fill" : "heart")
                            .foregroundColor(quake.properties.favorite ? .red : .black)
                    }
                    .tint(quake.properties.favorite ? .gray : .red)
                }
                .listStyle(.plain)
                .navigationTitle("\(navTitle)")
                .navigationBarTitleDisplayMode(.inline)
            }
            
        }
    }
}
