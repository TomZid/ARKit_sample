//
//  VirtualObject.swift
//  ARKit_sample
//
//  Created by Tom.Zid on 13/09/2017.
//  Copyright © 2017 TZ. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class VirtualObject: SCNReferenceNode {
    let define: VirtualObjectDefinition
    
    init(definition: VirtualObjectDefinition) {
        self.define = definition
        guard let url = Bundle.main.url(forResource: "Models.scnassets/\(definition.modelName)/\(definition.modelName)", withExtension: "scn") else {
            fatalError("can't find expected virtual object bundle resources")
        }
        
        super.init(url: url)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
