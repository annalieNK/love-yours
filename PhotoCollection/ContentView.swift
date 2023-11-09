//
//  ContentView.swift
//  PhotoCollection
//
//  Created by Annalie Kruseman on 8/10/23.
//
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    //@StateObject var viewModel = ViewModel()
    @EnvironmentObject var viewModel: ViewModel
    
    //@State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var gridColumns = [GridItem(.adaptive(minimum: 100))]
    
    @State private var isAddItem = false
    @State private var isEditing = false
    @State private var showingDeleteConfirmation = false
    @State private var showingEditItemView = false
    
    // sort resorts by name or country (name is default based on order of adding)
    enum FilterTag {
        case `default`, personal, business
    }
    
//    @State private var filterTag = FilterTag.default
//    @State private var showingFilterOptions = false
//    @State private var filterCategory: String = "" //nil
//    @State private var searchText: String = ""
    
//    var searchResults: [Item] {
//        searchText.isEmpty ? viewModel.items : viewModel.items.filter { $0.tag == searchText }
//    }
    
    var body: some View {
        NavigationStack {
//            VStack {
                //TextField("Filter by tag", text: $filterCategory)
                
                ScrollView {
                    LazyVGrid(columns: gridColumns) {
                        ForEach(viewModel.items, id:\.self) { item in
                        //ForEach(viewModel.items, id: \.self) { item in
                            //$0.tag == "personal"}, id: \.self) { item in //, id: \.id //viewModel.items //filteredItems
                            //viewModel.items.filter { $0.tag.contains(filterCategory) }
                            if isEditing {
                                NavigationLink(
                                    destination: DetailView(item: item)) {
                                        GridItemView(item: item)
                                            .onTapGesture {
                                                //item.isSelected.toggle()
                                                viewModel.toggleSelection(for: item)
                                            }
                                            .opacity(item.isSelected ? 0.3 : 1) // TODO: does not work when tapped
                                    }
                            } else {
                                NavigationLink(
                                    destination: DetailView(item: item)) {
                                        GridItemView(item: item)
                                        //                                        .confirmationDialog("Delete this item", isPresented: $showingDeleteConfirmation) {
                                        //                                            Button("Delete item") { viewModel.removeItem(item) } //viewModel.deleteItem(for: item)
                                        //                                            Button("Cancel", role: .cancel) { }
                                        //                                        } message: {
                                        //                                            Text("Are you sure to remove this item from your collection? The item will still be stored in your iCloud Photos app.")
                                        //                                        }
                                        //                                        .contextMenu {
                                        //                                            Button {
                                        //                                                showingDeleteConfirmation = true
                                        //                                            } label: {
                                        //                                                Label("Delete", systemImage: "trash")
                                        //                                            }
                                        //                                            Button {
                                        //                                                showingEditItemView = true
                                        //                                            } label: {
                                        //                                                Label("Edit", systemImage: "pencil.line")
                                        //                                            }
                                        //                                        }
                                        //                                        .sheet(isPresented: $showingEditItemView) {
                                        //                                            EditItemView(item: item)
                                        //                                        }
                                    }
                            }
                        }
                    .padding()
                }
            }
            .background(.backgroundGradient, ignoresSafeAreaEdges: horizontalSizeClass == .compact ? [.top] : [.top]) //.all
            .navigationBarTitle("Moments to collect")
            //.searchable(text: $searchText, prompt: "Filter by tag")
            .navigationBarTitleDisplayMode(.inline)
//            .onChange(of: filterCategory) { newValue in
//                viewModel.items = viewModel.items.filter { $0.tag.contains(newValue) }
//            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    print("Active")
                    viewModel.addNotification()
                } else if newPhase == .inactive {
                    print("Inactive")
                } else if newPhase == .background {
                    print("Background")
                }
            }
            .sheet(isPresented: $isAddItem) {
                //                ZStack {
                //                    Color(hue: 0.1, saturation: 0.5, brightness: 1, opacity: 0.2).edgesIgnoringSafeArea(.all)
                AddItemView(item: Item.example)
                //                        .background(Color.blue)
                //                }
            }
            .confirmationDialog("Delete this item", isPresented: $showingDeleteConfirmation) {
                Button("Delete item") { viewModel.deleteSelectedPhotos() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure to remove this photo from your collection? The photo will still be stored in your iCloud Photos app.")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    editButtonToolbar
                        .disabled(isAddItem)
                }
                
                ToolbarItem(placement: .bottomBar) { //navigationBarTrailing
                    addButtonToolbar
                        .disabled(isEditing)
                        .font(.largeTitle)
                        .foregroundColor(Color(hue: 0.95, saturation: 1, brightness: 1, opacity: 0.5))
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) { //bottomBar
                    if isEditing {
                        deleteButtonToolbar
                    }
                }
                
                // add filter toolbar
//                ToolbarItem(placement: .automatic) {
//                    Button {
//                        showingFilterOptions = true
//                    } label: {
//                        Label("Filter", systemImage: "arrow.up.arrow.down")
//                    }
//                }
            }
            // add filter Confirmation Dialog
//            .confirmationDialog("Filter photos", isPresented: $showingFilterOptions) {
//                Button("default") {
//                    //filterCategory = nil
//                    filterTag = .default
//                    showingFilterOptions = false
//                }
//                Button("personal") {
//                    //filterCategory = "personal"
//                    filterTag = .personal
//                    showingFilterOptions = false
//                }
//                Button("business") {
//                    //filterCategory = "business"
//                    filterTag = .business
//                    showingFilterOptions = false
//                }
//            } message: {
//                Text("Select tag to filter photos")
//            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
//    var filteredText: [Item] {
//        if searchText.isEmpty {
//            return viewModel.items
//        } else if searchText == "personal" {
//            return viewModel.items.filter { $0.tag.localizedCaseInsensitiveContains("personal") }
//        } else if searchText == "business" {
//            return viewModel.items.filter { $0.tag.localizedCaseInsensitiveContains("business") }
//        } else {
//            return viewModel.items
//        }
//    }
//
//    // apply the sort to filteredResorts
//    var filteredItems: [Item] {
//        switch filterTag {
//        case .default:
//            return viewModel.items
//        case .personal:
//            return viewModel.items.filter { $0.tag == "personal"}
//        case .business:
//            return viewModel.items.filter { $0.tag == "business"}
//        }
//    }
    
    private var deleteButtonToolbar: some View {
        Button {
            showingDeleteConfirmation = true
        } label: {
            Image(systemName: "trash")
        }
    }
    
    private var editButtonToolbar: some View {
        Button(isEditing ? "Done" : "Select") {
            withAnimation {
                isEditing.toggle()
            }
            viewModel.deselectAllPhotos() //NB: appears with a blink
        }
    }
    
    private var addButtonToolbar: some View {
        Button {
            isAddItem = true
        } label: {
            Image(systemName: "heart.fill") //plus
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewModel())
        //.previewInterfaceOrientation(.landscapeLeft)
    }
}
