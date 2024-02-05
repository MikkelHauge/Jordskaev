//
//  ContentView.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 15/05/2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var stateController: StateController    
    @State private var showLikedOnlyView: Bool = false
    
    private let tabItems: [(EarthquakeSpan, String, String)] = [
        (.Hour, "Hour", "clock"),
        (.Day, "Day", "sun.max"),
        (.Week, "Week", "calendar"),
        (.Month, "Month", "calendar.badge.clock"),
    ]
    
    var body: some View {
        NavigationView {
            TabView {
                ForEach(tabItems, id: \.0) { (span, title, icon) in
                    ListView()
                        .tabItem {
                            Label(title, systemImage: icon)
                        }
                        .onAppear {
                            stateController.currentEQSpan = span
                            stateController.fetchQuakes(for: span)
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showLikedOnlyView = true
                    }) {
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.title)
                            Text("Favorites")
                        }
                        .foregroundColor(.red)
                    }
                    .sheet(isPresented: $showLikedOnlyView) {
                        LikedOnlyView().environmentObject(stateController)
                    }
                }
            }
        }
        .environmentObject(stateController)
    }
}
class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
    // class definition goes here
}