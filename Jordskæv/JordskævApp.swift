//
//  JordskævApp.swift
//  Jordskæv
//
//  Created by Mikkel Hauge on 15/05/2023.
//

import SwiftUI

@main
struct JordskævApp: App {
    @StateObject var stateController = StateController()

    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(stateController)
        }
    }
}
