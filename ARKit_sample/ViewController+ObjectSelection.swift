//
//  ViewController+ObjectSelection.swift
//  ARKit_sample
//
//  Created by Tom.Zid on 13/09/2017.
//  Copyright © 2017 TZ. All rights reserved.
//

import UIKit
import SceneKit

extension ViewController: VirtualObjectTableViewControllerDelegate {
    
    func virtualObjectTableViewController(_: VirtualObjectTableViewController, didselectObjectAt index: Int) {
        guard let cameraTransform = arscnView.session.currentFrame?.camera.transform else {
            return
        }
        
        let definition = VirtualObjectManager.availableObjects[index]
        let object = VirtualObject(definition: definition)
        let position = focusSquare?.lastPosition ?? float3(0)
        virtualObjectManager.loadVirtualObject(object, toPosition: position, cameraTransform: cameraTransform)
        if object.parent == nil {
            serialQueue.async {
                self.arscnView.scene.rootNode.addChildNode(object)
            }
        }
    }
    
    func virtualObjectTableViewController(_: VirtualObjectTableViewController, didDeselectObjectAtindex: Int) {
        
    }
}
