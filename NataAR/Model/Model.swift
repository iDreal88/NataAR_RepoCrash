//
//  Model.swift
//  NataAR
//
//  Created by Oey Darryl Valencio Wijaya on 29/03/24.
//

import SwiftUI
import RealityKit
import Combine

class Model {

    // MARK: - Properties

    static let modelNames = [
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

    var modelName: String
    var image: UIImage?
    var modelEntity: ModelEntity?
    var isMetallic: Bool
    var color: Color

    private var cancellable: AnyCancellable? = nil

    // MARK: - Lifecycle

    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)
        self.isMetallic = false
        self.color = Color.white
         

        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink { loadCompletion in
                if case .failure(let error) = loadCompletion {
                    print("Unable to load modelEntity for: \(modelName)")
                    print("Error: \(error)")
                }
            } receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.name = modelName
                print("Successfully loaded modelEntity for: \(modelName)")
            }
    }
}

// MARK: - Hashable

extension Model: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(modelName)
    }
}

// MARK: - Equatable

extension Model: Equatable {
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.modelName == rhs.modelName
    }
}
