//
//  ContentView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var todos: FetchedResults<Todo>
    //    @StateObject var appModel: AppDataModel = AppDataModel()
    @State private var isExport: Bool = false
    @State private var uzdzURL: URL = Bundle.main.url(forResource: "fender", withExtension: "usdz")!
    
    @State private var isPlacementEnabled = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    @State private var shouldRemoveAllModels = false
    @State private var isModalVisible = false
    @State private var showSaveAlert = false
    
    @State private var isSidebarOpen = false
    
    @State private var showedObjects: [Model] = []
    @State private var selectedObject: Model = Model(modelName: "")
    
    @State private var showingObjectList: Bool = false
    @State private var isMetallic: Bool = false
    
    
    @State private var objectColor: Color = Color.red
    
    
    @State private var isModalRemoveVisible = false
    
    let items = [
        "biplane",
        "drummer",
        "fender",
        "gramophone",
        "retrotv",
        "robot",
        "teapot",
        "wateringcan",
        "wheelbarrow"
    ]
    
    private var models: [Model] = {
        let fileManager = FileManager.default
        guard let path = Bundle.main.resourcePath,
              let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        return files
            .filter { $0.hasSuffix(".usdz") }
            .compactMap { $0.replacingOccurrences(of: ".usdz", with: "") }
            .compactMap { Model(modelName: $0 ) }
    }()
    
    // MARK: Body
    
    var body: some View {
        
        NavigationStack {
            
            ZStack(alignment: .top) {
                HStack{
                    Button(role: .destructive) {
                        shouldRemoveAllModels = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Remove All")
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isModalRemoveVisible.toggle()
                    }) {
                        HStack{
                            Image(systemName: "minus")
                            Text("Remove")
                        }
                        .frame(width: 100)
                        .padding(.all,10)
                        .background(Color.red)
                        .foregroundColor(.white)
                    }
                    .cornerRadius(10)
                    .sheet(isPresented: $isModalRemoveVisible) {
                        ModalViewRemove(isModalVisible: $isModalRemoveVisible)
                    }
                    
                    
                    Button(action: {
                        isModalVisible.toggle()
                    }) {
                        HStack{
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .frame(width: 100)
                        .padding(.all,10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                    }
                    .cornerRadius(10)
                    .sheet(isPresented: $isModalVisible) {
                        ModalView(items: items, isModalVisible: $isModalVisible)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: ObjectView()) {
                        HStack{
                            Image(systemName: "camera.viewfinder")
                            Text("Scan Object")
                        }
                    }
                    .padding(.trailing,10)
                }
            }
            .padding()
            .sheet(isPresented: $isExport, onDismiss: {
                isExport = false
            }) {
                ModelView(modelFile: uzdzURL, endCaptureCallback: {})
            }
            
            
            ZStack(alignment: .bottom) {
                ARViewRepresentable(
                    modelConfirmedForPlacement: $modelConfirmedForPlacement,
                    shouldRemoveAllModels: $shouldRemoveAllModels,
                    isMetallic: $isMetallic,
                    selectedObject: $selectedObject,
                    showedObjects: $showedObjects, objectColor: $objectColor
                    
                )
                
                SideBarView(showingObjectList: $showingObjectList, showedObjects: $showedObjects, selectedObject: $selectedObject, isMetallic: $isMetallic, isExport: $isExport, usdzURL: $uzdzURL, objectColor: $objectColor)
                
                if isPlacementEnabled {
                    PlacementButtonView(
                        isPlacementEnabled: $isPlacementEnabled,
                        selectedModel: $selectedModel,
                        modelConfirmedForPlacement: $modelConfirmedForPlacement,
                        showedObjects: $showedObjects
                    )
                } else {
                    ModelPickerView(
                        isPlacementEnabled: $isPlacementEnabled,
                        selectedModel: $selectedModel,
                        models: models
                    )
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
