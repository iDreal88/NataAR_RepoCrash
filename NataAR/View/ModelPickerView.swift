//
//  ModelPickerView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct ModelPickerView: View {
    
    // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var todos: FetchedResults<Todo>
    
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: Model?
    
    var models: [Model]
    
    // MARK: Body
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(todos, id: \.self) { todo in
                    Button {
                        selectedModel = Model(modelName: todo.name!)
                        isPlacementEnabled = true
                    } label: {
                        Image(uiImage: UIImage(named: todo.name!)!)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background( Color.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}
