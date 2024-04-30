//
//  SideBarView.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI

struct SideBarView: View {
    @Binding var showingObjectList: Bool
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.2
    var sideBarHeight = UIScreen.main.bounds.size.height
//    @State private var selectedObject: Int?
    @State private var selectedWall: Int?
    @State var wallList = true
    @State var objectList = true
    @Binding var showedObjects: [Model]
    @Binding var selectedObject: Model
    @Binding var isMetallic: Bool
    @Binding var isExport: Bool
    @Binding var usdzURL: URL
    @Binding var objectColor: Color
    
    @State private var isToggled = false
    
    var body: some View {
        HStack {
            ZStack(alignment: .top) {
                MenuChevron
                List {
                    Section(isExpanded: $wallList,
                            content: {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(showedObjects, id: \.self) { showedObject in
                                    Button {
                                        selectedObject = showedObject
                                        objectColor = showedObject.color
                                        isMetallic = showedObject.isMetallic
                                        usdzURL = Bundle.main.url(forResource: showedObject.modelName, withExtension: "usdz")!
                                    } label: {
                                        Image(uiImage: UIImage(named: showedObject.modelName)!)
                                            .resizable()
                                            .frame(height: 100)
                                            .aspectRatio(1/1, contentMode: .fit)
                                            .background(selectedObject == showedObject ? Color.blue : Color.white)
                                            .cornerRadius(12)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                    }, header: {
                        Image(systemName: "square.split.bottomrightquarter")
                        Text("List of Objects")
                    })
                    
                    
                    Section(isExpanded: $objectList, content: {
                        VStack{
                            if(selectedObject.modelName != ""){
                                ColorPicker("Color", selection: $objectColor)
                                    .padding()
                                    .onChange(of: objectColor) { oldValue, newValue in
                                        for index in 0..<showedObjects.count {
                                            if(showedObjects[index] == selectedObject){
                                                showedObjects[index].color = newValue
                                            }
                                        }
                                    }
                                Toggle(isOn: $isMetallic) {
                                    Text("Metallic")
                                }
                                .onChange(of: isMetallic) { oldValue, newValue in
                                    for index in 0..<showedObjects.count {
                                        if(showedObjects[index] == selectedObject){
                                            showedObjects[index].isMetallic = newValue
                                        }
                                    }
                                }
                                .padding()
                                
                                Button(action: {
                                    isExport = true
                                }) {
                                    Text("Export AR Look")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                }
                                .cornerRadius(10)
                            }else{
                                Text("Select the object")
                            }
                        }
                        
                    }, header: {
                        Image(systemName: "pencil")
                        Text("Customize Object")
                    })
                    
                }
                .background(.regularMaterial)
                .scrollContentBackground(.hidden)
                .listStyle(.sidebar)
            }
            .frame(width: sideBarWidth)
            .offset(x: showingObjectList ? 0 : -sideBarWidth)
            .animation(.default, value: showingObjectList)
            Spacer()
        }
        .padding(.top, 1)
        .font(.subheadline)
        .animation(.easeInOut(duration: 5), value: showingObjectList)
    }
    
    
    var MenuChevron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 70, height: 100)
                .offset(x: showingObjectList ? -18 : -15)
                .onTapGesture {
                    showingObjectList.toggle()
                }
                .foregroundStyle(.regularMaterial)
            
            Image(systemName: "chevron.right")
                .bold()
                .rotationEffect(
                    showingObjectList ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: 2)
                .foregroundColor(.gray)
                .font(.title3)
        }
        .offset(x: sideBarWidth / 1.8, y: 20)
        
    }
    
    func deleteListItem(at offsets: IndexSet) {
        //        roomSceneViewModel.listChildNodes.remove(atOffsets: offsets)
        // Perform any additional cleanup or data updates as needed
    }
}

//#Preview {
//    SideBarView()
//}
