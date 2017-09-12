//
//  VirtualObjectManager.swift
//  ARKit_sample
//
//  Created by Tom.Zid on 12/09/2017.
//  Copyright © 2017 TZ. All rights reserved.
//

import UIKit

class VirtualObjectManager: NSObject {
    static let availableObjects: [VirtualObjectDefinition] = {
//        VirtualObjects.json                             VirtualObjects
        guard let jsonURL = Bundle.main.url(forResource: "VirtualObjects", withExtension: "json") else {
            fatalError("Missing 'VirtualObjects.json' in bundle")
        }
        
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            return try JSONDecoder().decode([VirtualObjectDefinition].self, from: jsonData)
        } catch {
            fatalError("Unable to decode VirtualObjects JSON: \(error)")
        }
    }()
    
}
