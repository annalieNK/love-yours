//
//  GridItemView.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import SwiftUI

struct GridItemView: View {
    let item: Item
    @State private var image: Image? = nil
        
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
//            Rectangle()
//                .foregroundColor(.white)
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 110, height: 110)
//                .clipped()
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .shadow(radius: 2)
//                .opacity(item.isSelected ? 0.3 : 1)
//
//            Image(systemName: "cloud")
//                .frame(width: 110, height: 110)
//                .font(.system(size: 65))
//                .foregroundColor(.white)
//                .background(Color(hue: 0.12, saturation: 1, brightness: 1, opacity: 0.5)) //.backgroundGradient
            
//            if image != nil {
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 110, height: 110)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 2)
                    //.opacity(item.isSelected ? 0.3 : 1)
//            } else {
//                Image(systemName: "cloud")
//                    .resizable()
//                   .aspectRatio(contentMode: .fill)
//                   .frame(width: 110, height: 110)
//            }
            
            if let date = item.date {
                Text(formatDate(date))
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(3)
                    .foregroundColor(.white)
            }
            
            //Text("\(item.id)")
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        image = item.convertDataToImage()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM  dd"
        return formatter.string(from: date)
    }
}

struct GridItemView_Previews: PreviewProvider {
    static var previews: some View {
        GridItemView(item: Item.example)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
