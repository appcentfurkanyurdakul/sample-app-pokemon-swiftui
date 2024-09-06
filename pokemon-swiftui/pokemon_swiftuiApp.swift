//
//  pokemon_swiftuiApp.swift
//  pokemon-swiftui
//
//  Created by Furkan Yurdakul on 27.06.2024.
//

import SwiftUI

@main
struct pokemon_swiftuiApp: App {
    
    @State var navigationPath = NavigationPath()
    
    init() {
        ConnectionManager.shared.startInternetTracking()
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navigationPath) {
                HomeContentView(path: $navigationPath).safeAreaPadding()
            }
            .frame(
                maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                maxHeight: .infinity
            )
            .background(.white)
        }
    }
}
