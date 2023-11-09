//
//  Shake-Modifier.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/14/23.
//

import SwiftUI

extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        return self.modifier(ShakeGestureModifier(action: action))
    }
}

struct ShakeGestureModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

extension Notification.Name {
    static let deviceDidShakeNotification = Notification.Name("DeviceDidShakeNotification")
}
