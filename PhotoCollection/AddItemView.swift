//
//  AddItemView.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    //@ObservedObject var viewModel = ViewModel()
    @EnvironmentObject var viewModel: ViewModel
    
    var item: Item
    
    @State private var image: Image? = nil
    @State private var inputUIImage: UIImage?
    @State private var savingUIImage: UIImage?
    
    @State private var showingImagePicker = false
    @State private var showingSaveError = false
    
    @State private var date = Date()
    @State private var locationName = ""
    @State private var tag = ""
    @State private var description = ""
    @State private var isSelected = false
    
    @State private var imageName = ""
    @State private var imageURL = URL(string: "https://hws.dev/img/cupcakes@3x.jpg")
    
    @State private var type = "personal"
    let types = ["business", "personal"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ZStack {
                        Rectangle()
                            .fill(.secondary)
                            .frame(width: 300, height: 300)
                            .foregroundColor(.white)
                        Text("Tap to select a picture")
                            .foregroundColor(.black)
                            .font(.headline)
                        
                        image? //? image? : Image(systemName: "cloud")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                    .onTapGesture {
                        showingImagePicker = true
                    }
                }
                
                Section (header: Text("Add date")) {
                    DatePicker("", selection: $date, displayedComponents: [.date])
                }
                
                Section (header: Text("Add location")) {
                    TextField("", text: $locationName)
                        .fontWeight(.light)
                        .fontDesign(.rounded)
                }
                
//                Section (header: Text("Tag")) {
//                    Picker("", selection: $type) {
//                        ForEach(types, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                }
                
                Section (header: Text("Add description")) {
                    //TextField("Add desctiption", text: $description)
                    TextEditor(text: $description)
                        .fontWeight(.regular)
                        .fontDesign(.rounded)
                }
            }
            // Dismiss the keyboard when tapped outside the TextEditor
            .gesture(
                TapGesture()
                    .onEnded {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
            .onChange(of: inputUIImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputUIImage)
            }
            .alert("Oops!", isPresented: $showingSaveError) {
                Button("OK") { }
            } message: {
                Text("Sorry, there was an error saving your image – please check that you have allowed permission for this app to save photos.")
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        viewModel.addNewItem(inputUIImage: savingUIImage, description: description, date: date, locationName: locationName, tag: tag, isSelected: isSelected, imageName: imageName, imageURL: imageURL!)
                        dismiss()
                    }
                    //.disabled(inputUIImage == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func loadImage() {
        guard let inputUIImage = inputUIImage else { return }
        
//        if inputUIImage == inputUIImage {
//            image = Image(uiImage: inputUIImage)
//            savingUIImage = inputUIImage
//        } else {
//            image = Image(systemName: "cloud")
//            savingUIImage = UIImage(systemName: "cloud")
//        }
        image = Image(uiImage: inputUIImage)
        
//        if image != nil {
            savingUIImage = inputUIImage //?? UIImage(systemName: "cloud")
//        } else {
//            savingUIImage = UIImage(systemName: "cloud")
//        }
    }
    
    init(item: Item) {
        self.item = item
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView(item: Item.example)
    }
}
