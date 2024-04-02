//
//  ModalView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct ModalView: View {
    let items: [String]
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) private var todos: FetchedResults<Todo>
    @Binding var isModalVisible: Bool
    
    var body: some View {
        NavigationView {
            List(items, id: \.self) { item in
                
                Button(
                    action: {
                    let newTodo = Todo(context: self.viewContext)
                    newTodo.name = item
                    try? self.viewContext.save()
                },
                    label: {
                    Image(uiImage: UIImage(named: item)!)
                        .resizable()
                        .frame(height: 80)
                        .aspectRatio(1/1, contentMode: .fit)
                        .background( Color.white)
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
            }
            .navigationBarTitle("Add new object")
            .navigationBarItems(trailing: Button("Done") {
                    isModalVisible = false
                }
            )
        }
    }
}

