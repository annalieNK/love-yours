//
//  PhotoCollectionApp.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import SwiftUI

@main
struct PhotoCollectionApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(viewModel)
        }
    }
}
