//
//  EnterView.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import SwiftUI

struct EnterView: View {
    
    @State private var isContentViewActive = false
    @State private var isAddItem = false
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white.opacity(0.0))
                        //.frame(width: .infinity, height: .infinity)//.)
                    Text("Tap to add a moment to your collection \nor swipe left to view your collected moments")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                        .padding(.horizontal, 10)
                }
                
                Spacer()
                
                Button {
                    isAddItem = true
                } label: {
                    Image(systemName: "heart.fill")
                }
                .font(.system(size: 80))
                .foregroundColor(Color(hue: 0.95, saturation: 1, brightness: 1, opacity: 0.5))
                
                Spacer()
                Spacer()
            }
            .background(.backgroundGradient)
            .gesture(swipeGesture)
            .navigationBarItems(trailing: NavigationLink("", destination: ContentView(), isActive: $isContentViewActive))
            .sheet(isPresented: $isAddItem) {
                AddItemView(item: Item.example)
            }
            //.ignoresSafeArea()
        }
    }
    
    var swipeGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width < -100 {
                    isContentViewActive = true
                }
            }
    }
}

struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
