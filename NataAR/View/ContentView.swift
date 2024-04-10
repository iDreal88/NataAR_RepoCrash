//
//  ContentView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var todos: FetchedResults<Todo>
    
    @State private var isPlacementEnabled = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    @State private var shouldRemoveAllModels = false
    @State private var isModalVisible = false
    
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
                Button(role: .destructive) {
                    shouldRemoveAllModels = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Remove All")
                        
                        Spacer()
                        
                        NavigationLink(destination: ObjectView()) {
                            Text("Open Object Capture")
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            isModalVisible.toggle()
                        }) {
                            Image(systemName: "minus")
                            Text("Remove Items")
                        }
                        .sheet(isPresented: $isModalVisible) {
                            ModalViewRemove(isModalVisible: $isModalVisible)
                        }
                    }
                }
            }
            .padding()
            
            ZStack(alignment: .bottom) {
                ARViewRepresentable(
                    modelConfirmedForPlacement: $modelConfirmedForPlacement,
                    shouldRemoveAllModels: $shouldRemoveAllModels
                )
                
                if isPlacementEnabled {
                    PlacementButtonView(
                        isPlacementEnabled: $isPlacementEnabled,
                        selectedModel: $selectedModel,
                        modelConfirmedForPlacement: $modelConfirmedForPlacement
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
