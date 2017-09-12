/**
 * 隐藏statusBar
 * 1. info.plist -> View controller-based status bar appearance (NO)
 * 2.target -> general -> √hide status bar && √ requires full screen
*/

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arscnView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        arscnView.scene = scene
        
        arscnView.showsStatistics = true
        arscnView.delegate = self
        
        let scene_Box = SCNScene()
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        boxNode.name = "boxNode"
        boxNode.position = SCNVector3(0, 0, -0.5)
        
        //material
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "material")
        box.materials = [material]
        
        scene_Box.rootNode.addChildNode(boxNode)
        arscnView.scene = scene_Box
        
        addGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        arscnView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arscnView.session.pause()
    }
 
    func addGestures() {
        let panGeusture = UIPanGestureRecognizer(target: self, action: #selector(panFunc))
        arscnView.addGestureRecognizer(panGeusture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchFunc))
        arscnView.addGestureRecognizer(pinchGesture)
    }
    
    @objc func panFunc(recognizer: UIPanGestureRecognizer) {
        //得到节点的坐标
        guard let node = self.arscnView.scene.rootNode.childNode(withName: "boxNode", recursively: true) else {
            return
        }
        let nodePosition = node.position
        
        //获取相机的坐标
        guard let cameraTransform = self.arscnView.session.currentFrame?.camera.transform else {
            return
        }
        let translation = cameraTransform.columns.3
        
        //获得滑动距离
        let point = recognizer.translation(in: self.view)
        let pointX = Float(point.x / self.view.bounds.size.width) * 0.1
        let pointY = Float(point.y / self.view.bounds.size.height) * 0.1

        let newNodePositionX = pointX + nodePosition.x
        let newNodePositionY = -pointY + nodePosition.y
        let newNodePositionZ = (translation.z - 0.1 < pointY + nodePosition.z) ? (translation.z - 0.1) : (pointY + nodePosition.z)  // 模型z坐标距离摄像头0.1
        
        node.position = SCNVector3(newNodePositionX, newNodePositionY, newNodePositionZ)
        
        let angles = Float((node.eulerAngles.x>6) ? (Float.pi/32) : (node.eulerAngles.x+Float.pi/32))
        node.eulerAngles = SCNVector3(angles, angles,0)
        recognizer.setTranslation(CGPoint.zero, in:self.view)
    }
    
    
    var nodeBeganScale:Float!
    
    @objc func pinchFunc(recognizer:UIPinchGestureRecognizer) {
        // 获取节点在空间中位置
        guard let node = self.arscnView.scene.rootNode.childNode(withName: "boxNode", recursively: true) else {
            return
        }
        
        if (recognizer.state == UIGestureRecognizerState.ended) {
            recognizer.scale = 1
        } else {
            
            // 手势开始时保存node的scale
            if recognizer.state == UIGestureRecognizerState.began {
                self.nodeBeganScale = node.scale.x
            }
            
            // 缩放
            let nodeScale = Float(recognizer.view!.transform.scaledBy(x: recognizer.scale, y: recognizer.scale).a) * self.nodeBeganScale
            node.scale = SCNVector3(nodeScale, nodeScale, nodeScale)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceRect = button.bounds
        }
        // MARK: remaining
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        var titleString: String!
        switch camera.trackingState {
        case .normal:
            titleString = "Tracking normal"
            break
        case .notAvailable:
            titleString = "TRACKING UNAVAILABLE"
            break
        case .limited(let reason):
            switch reason {
            case .initializing:
                titleString = "Initializing AR Session"
                break
            case .excessiveMotion:
                titleString = "TRACKING LIMITED\nToo much camera movement"
                break
            case .insufficientFeatures:
                titleString = "TRACKING LIMITED\nNot enough surface detail"
                break
            }
        }
        statusLabel.text = titleString
    }
    
}

extension ViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
