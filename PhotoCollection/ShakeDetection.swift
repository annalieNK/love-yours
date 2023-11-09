//
//  ShakeDectection.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/14/23.
//

import SwiftUI
import Combine

class ShakeDetection: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        NotificationCenter.default.publisher(for: .deviceDidShakeNotification)
            .sink { _ in
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
