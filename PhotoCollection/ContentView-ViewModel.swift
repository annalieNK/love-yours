//
//  ContentView-ViewModel.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import Foundation
import UIKit
import UserNotifications

@MainActor
class ViewModel: ObservableObject {
    
    @Published var items: [Item] = []
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedLocations")
    
//    var personalItems: [Item] {
//        items.filter { $0.tag == "Personal"}
//    }
//
//    var businessItems: [Item] {
//        items.filter { $0.tag == "Business"}
//    }
    
//    // sort resorts by type //(name is default based on order of adding)
//    enum FilterTag {
//        case `default`, personal, business
//    }
//
//    @Published var filterTag = FilterTag.default
//
//    // apply the sort to filteredResorts
//    var filteredItems: [Item] {
//        switch filterTag {
//        case .default:
//            return items
//        case .personal:
//            return items.filter { $0.tag == "Personal"}
//        case .business:
//            return items.filter { $0.tag == "Business"}
//        }
//    }
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            items = []
        }
    }
    
    func saveItem() {
        let imageName = UUID().uuidString
        let imageURL = FileManager.documentsDirectory.appendingPathComponent(imageName)
        
        do {
            let data = try JSONEncoder().encode(self.items)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Item saved")
            //let data = try JSONEncoder().encode(self.items)
            //try data.write(to: imageURL, options: [.atomic, .completeFileProtection])
            //let input = try Data(contentsOf: imageURL)
            //print(input)
        } catch {
            print("Unable to save data")
        }
    }
    
    func addNewItem(inputUIImage: UIImage?, description: String, locationName: String, tag: String, isSelected: Bool, imageName: String, imageURL: URL) {
        guard let imageData = inputUIImage?.jpegData(compressionQuality: 0.8) else { return }
        let newItem = Item(imageData: imageData, description: description, date: Date.now, locationName: locationName, tag: tag, isSelected: isSelected, imageName: imageName, imageURL: imageURL)
        self.items.append(newItem)
        saveItem()
    }
    
    func updateItem(item: Item, withName date: Date, locationName: String, description: String) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].date = date
            items[index].locationName = locationName
            items[index].description = description
            saveItem()
        }
    }
    
    func removeItem(_ item: Item) { //(item: Item)
        //if let index = items.firstIndex(of: item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: index)
            saveItem()
        }
        
//        if FileManager.default.fileExists(atPath: item.imageURL.path) {
//            do {
//                try FileManager.default.removeItem(atPath: item.imageURL.path)
//            } catch {
//                print("Error deleting item: \(error)")
//            }
//        }
    }
    
    func deleteSelectedPhotos() {
        let selectedItems = items.filter { $0.isSelected }
        
        for item in selectedItems {
            removeItem(item)
        }
    }
    
    func toggleSelection(for item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isSelected.toggle()
        }
    }
    
    func deselectAllPhotos() {
        for index in items.indices {
            items[index].isSelected = false
        }
    }
    
    func addNotification() {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            //content.title = "Love. This. Moment."
            content.subtitle = "Collect those happy moments"
            content.body = "Are those memories still fresh to write them down?"
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
    
    //    func showSelection() {
    //        let selectedItems = items.filter { $0.isSelected }
    //
    //        for item in selectedItems {
    //            GridItemView(item: item)
    //                .opacity(item.isSelected ? 0.3 : 1)
    //        }
    //    }
    
    
    
//    func removeItems(_ items: Set<Item>) {
//        for item in items {
//            if let itemURL = getItemURL(for: item) {
//                do {
//                    try FileManager.default.removeItem(at: itemURL)
//                } catch {
//                    print("Failed to remove item: \(error.localizedDescription)")
//                }
//            }
//        }
//
//        // Remove the items from the array
//        self.items.removeAll { items.contains($0) }
//    }
//
//    func getItemURL(for item: Item) -> URL? {
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return nil
//        }
//
//        let filename = "\(item.id).txt"
//        return documentsDirectory.appendingPathComponent(filename)
//    }
    
//    func deleteItem(for item: Item) {
//        items.removeAll { $0.id == item.id }
//
//        do {
//            try FileManager.default.removeItem(at: savePath)
//            // Perform any additional actions after successful deletion
//
//        } catch {
//            print("Error deleting document: \(error.localizedDescription)")
//            // Handle the error gracefully
//        }
//    }
}
