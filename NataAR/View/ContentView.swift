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
    @State private var isMetalic = false
    @State private var isColorRed = false
    @State private var isColorOrange = false
    @State private var isColorCyan = false
    
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
                        .padding(.trailing,10)
                        
                        Button(action: {
                            isMetalic.toggle()
                        }, label: {
                            Text("Toggle Metalic")
                        })
                        .padding()
                        
                        Button(action: {
                            isColorRed.toggle()
                            isColorOrange = false
                            isColorCyan = false
                        }, label: {
                            Text("Red")
                        })
                        .padding()
                        
                        Button(action: {
                            isColorOrange.toggle()
                            isColorRed = false
                            isColorCyan = false
                        }, label: {
                            Text("Orange")
                        })
                        .padding()
                        
                        Button(action: {
                            isColorCyan.toggle()
                            isColorRed = false
                            isColorOrange = false
                        }, label: {
                            Text("Cyan")
                        })
                        .padding()
                        
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
                    shouldRemoveAllModels: $shouldRemoveAllModels,
                    isMetalic: $isMetalic,
                    isColorRed : $isColorRed,
                    isColorOrange: $isColorOrange,
                    isColorCyan : $isColorCyan
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
