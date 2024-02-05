//
//  LikedOnlyView.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 15/05/2023.
//

import SwiftUI

@MainActor
struct LikedOnlyView: View {
    @EnvironmentObject var stateController: StateController
    
    var body: some View {
        NavigationView {
            List(stateController.likedEarthquakes) { quakes in
                HStack {
                    VStack(alignment: .leading, content: {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("\(quakes.properties.magnitude)")
                            .foregroundColor(quakes.properties.getMagnitudeColor)
                            .shadow(color: .black, radius: 0.5)
                    })
                    VStack(alignment: .leading) {
                        Text("\(quakes.properties.place)")
                            .foregroundColor(.white)
                        Text("\(quakes.properties.time)")
                            .foregroundColor(.gray)

                    }
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.gradient)
                        .shadow(color: .black, radius: 6, x: 2, y: 2)
                )
            }
        }
    }

}


struct LikedOnlyView_Previews: PreviewProvider {
    static var previews: some View {
        LikedOnlyView()
    }
}
