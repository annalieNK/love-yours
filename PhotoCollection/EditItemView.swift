//
//  EditItemView.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ViewModel
    
    @ObservedObject var item: Item
    
    @State private var image: Image?
    
    @State private var editedDate: Date
    @State private var editedLocationName: String
    @State private var editedDescription: String
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section (header: Text("Edit Date")) {
                    DatePicker("", selection: $editedDate, displayedComponents: [.date])
                }
                
                Section (header: Text("Edit Location"))  {
                    TextEditor(text: self.$editedLocationName)
                        .fontWeight(.light)
                        .fontDesign(.rounded)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                }
                
                Section (header: Text("Edit Description"))  {
                    TextEditor(text: self.$editedDescription)
                        .fontWeight(.light)
                        .fontDesign(.rounded)
                        .onTapGesture {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                }
            }
            .gesture(
                TapGesture()
                    .onEnded {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            )
            .navigationBarItems(trailing: Button("Save") {
                viewModel.updateItem(item: item, withName: editedDate, locationName: editedLocationName, description: editedDescription)
                dismiss()
            })
            .alert("Delete photo", isPresented: $showingDeleteAlert) {
                Button(action: {
                    viewModel.removeItem(item)
                }) {
                    Text("Delete")
                }
                Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure to delete this photo from your collection?")
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Label("Delete this photo", systemImage: "trash")
                    }
                    Spacer()
                }
            }
        }
    }
    
    init(item: Item) {
        self.item = item
        
        _editedDate = State(initialValue: item.date ?? Date.now)
        _editedLocationName = State(initialValue: item.locationName)
        _editedDescription = State(initialValue: item.description)
    }
}


struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
    }
}
