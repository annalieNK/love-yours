//
//  Item.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import Foundation
import UIKit
import SwiftUI

class Item: ObservableObject, Codable, Identifiable {
    let id: UUID
    var imageData: Data
    var description: String
    var date: Date?
    var locationName: String
    var tag: String
    var isSelected = false
    var imageName: String
    var imageURL: URL
    
    init(imageData: Data, description: String, date: Date, locationName: String, tag: String, isSelected: Bool, imageName: String, imageURL: URL) {
        self.id = UUID()
        self.imageData = imageData
        self.description = description
        self.date = date
        self.locationName = locationName
        self.tag = tag
        self.isSelected = isSelected
        self.imageName = imageName
        self.imageURL = imageURL
    }
    
    func convertDataToImage() -> Image {
        let uiImageData = imageData
        if let uiImage = UIImage(data: uiImageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle")
        }
    }
    
    static let example = Item(
        imageData: UIImage(named: "Annalie_image")?.jpegData(compressionQuality: 1) ?? Data(),
        description: "Annalie_name",
        date: Date.now,
        locationName: "Home",
        tag: "personal",
        isSelected: false,
        imageName: "test",
        imageURL: URL(string: "https://hws.dev/img/cupcakes@3x.jpg")!
    )
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id //&& lhs.id == rhs.id
    }
}

extension Item: Comparable {
    static func < (lhs: Item, rhs: Item) -> Bool {
        lhs.description < rhs.description
    }
}

extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
}
