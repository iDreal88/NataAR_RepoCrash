//
//  ARViewRepresentable.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewRepresentable: UIViewRepresentable {

    // MARK: - Properties

    @Binding var modelConfirmedForPlacement: Model?
    @Binding var shouldRemoveAllModels: Bool
    @Binding var isLightingDark: Bool

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> ARView {
        CustomARView(frame: .zero)
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if shouldRemoveAllModels {
            uiView.scene.anchors.forEach { anchor in
                anchor.children.forEach { entity in
                    if Model.modelNames.contains(entity.name) {
                        entity.removeFromParent()
                    }
                }
            }
            DispatchQueue.main.async {
                shouldRemoveAllModels = false
            }
        } else if let model = modelConfirmedForPlacement,
                  let modelEntity = model.modelEntity {
            print("Adding model to scene: \(model.modelName)")
            
            let anchorEntity = AnchorEntity(plane: .any)
            anchorEntity.addChild(modelEntity)
            uiView.scene.addAnchor(anchorEntity)
            
            DispatchQueue.main.async {
                modelConfirmedForPlacement = nil
            }
            
            modelEntity.generateCollisionShapes(recursive: true)
            uiView.installGestures([.translation,.rotation,.scale], for: modelEntity)
            
            
            var newMaterial = SimpleMaterial()
            newMaterial.color.tint = UIColor.cyan
            
            
            for index in 0..<modelEntity.model!.materials.count {
                modelEntity.model!.materials[index] = newMaterial
            }
//            var material = PhysicallyBasedMaterial()
            
            
//                material.baseColor = PhysicallyBasedMaterial.BaseColor(tint:.orange)
//                material.roughness = PhysicallyBasedMaterial.Roughness(floatLiteral: 0.0)
//                material.metallic = PhysicallyBasedMaterial.Metallic(floatLiteral: 1.0)
//            material.blending = .transparent(opacity: .init(floatLiteral: 0.5))
//            material.specular = .init(floatLiteral: 0.8)
            
            
//            let sheenColor = PhysicallyBasedMaterial.Color(red: 0.0, green: 0.8, blue: 0.8, alpha: 0.0)
//            material.sheen = .init(tint: sheenColor)
            
            
            
//            modelEntity.model?.materials = [newMaterial]
            
//            for child in modelEntity.children {
//                            
//                var newMaterial = SimpleMaterial()
//                newMaterial.color.tint = UIColor.cyan
//                
//                child.model?.materials = [newMaterial]
//            }
            
        }
        
        
        // Adjust lighting based on the current mode
        if isLightingDark {
            
        } else {
            // Apply light lighting environment
            print("darkess")
        }
    }
    
}
