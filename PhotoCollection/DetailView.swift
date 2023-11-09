//
//  DetailView.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import SwiftUI
import UIKit

struct DetailView: View {
    @Environment(\.dismiss) var dismiss
    //@StateObject private var viewModel = ViewModel()
    @EnvironmentObject var viewModel: ViewModel
    
    @ObservedObject var item: Item
    @State private var image: Image?
    
    @State private var showingEditItemView = false
    @State private var showingSharePhoto = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 350)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 2)
//                    .onTapGesture {
//                        sharePhoto()
//                        //shareImage(view: AnyView(DetailView(item: item)))
//                    }
                    .contextMenu {
                        Button {
                            sharePhoto()
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
            }
            
            if let date = item.date {
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
                    .padding(3)
            }
            
            Text("\(item.locationName)")
                .fontWeight(.light)
                .fontDesign(.rounded)
                .padding(3)
            // Edit details on screen
            //TextField("Location name", text: $item.locationName)
            
            ScrollView {
                Text("\(item.description)")
                    .fontWeight(.light)
                    .fontDesign(.rounded)
                    .padding(3)
            }
            .padding(.trailing)
            
            Spacer()
            
            Button {
                showingEditItemView = true
            } label: {
                Text("Edit")
            }
        }
        .onAppear(perform: loadImage)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hue: 0.1, saturation: 0.5, brightness: 1, opacity: 0.2))
        .sheet(isPresented: $showingEditItemView) {
            EditItemView(item: item)
        }
    }
    
    func loadImage() {
        image = item.convertDataToImage()
    }
    
    // TO DO: Add a new image of the photo that includes the description as a ZStack
    func sharePhoto() {
        if let image = UIImage(data: item.imageData) {
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
        }
    }
    
//    func shareImage(view: AnyView) {
//        if let image = captureImageFromView(view: view) {
//            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//
//            UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
//        }
//    }
//
//    func captureImageFromView(view: AnyView) -> UIImage? {
//        let controller = UIHostingController(rootView: view)
//        controller.view.frame = UIScreen.main.bounds
//
//        let renderer = UIGraphicsImageRenderer(bounds: controller.view.bounds)
//
//        return renderer.image { context in
//            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
//
//    func captureImageFromView(view: AnyView) -> UIImage? {
//        let image = UIImage(data: item.imageData) //UIImage(named: item.imageName) // Load the item's image
//        let controller = UIHostingController(rootView: view)
//        let imageSize = controller.sizeThatFits(in: UIScreen.main.bounds.size)
//
//        controller.view.frame = CGRect(origin: .zero, size: imageSize)
//
//        let renderer = UIGraphicsImageRenderer(size: imageSize)
//        return renderer.image { context in
//            image?.draw(in: CGRect(origin: .zero, size: imageSize))
//            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//        }
//    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(item: Item.example)
    }
}
