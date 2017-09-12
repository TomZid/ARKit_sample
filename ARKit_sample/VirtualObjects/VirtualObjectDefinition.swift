//
//  VirtualObjectDefinition.swift
//  ARKit_sample
//
//  Created by Tom.Zid on 12/09/2017.
//  Copyright © 2017 TZ. All rights reserved.
//

import UIKit

struct VirtualObjectDefinition: Codable, Equatable {
    let modelName: String
    let displayName: String
    let particleScaleInfo: [String: Float]
    
    // TODO: lazy
    lazy var thumbImage: UIImage = UIImage(named: self.modelName)!
    
    // TODO: = [:]
    init(modelName: String, displayName: String, particleScaleInfo:[String: Float] = [:]) {
        self.modelName = modelName
        self.displayName = displayName
        self.particleScaleInfo = particleScaleInfo
    }
    
    // TODO: static
    static func ==(lhs: VirtualObjectDefinition, rhs: VirtualObjectDefinition) -> Bool {
        return lhs.modelName == rhs.modelName
            && lhs.displayName == rhs.displayName
            && lhs.particleScaleInfo == rhs.particleScaleInfo
    }
}
