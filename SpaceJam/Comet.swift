import Foundation
import SpriteKit

class Comet: CelestialBody {
	static let startingDiameter: Float = 0.4
	var _diameter: Float {
		didSet {
			if let handler = didSetDiameterHandler {
				handler(_diameter, Comet.startingDiameter)
			}
		}
	}
	var didSetDiameterHandler: ((Float, Float) -> Void)?
	override var diameter: Float {
		return _diameter
	}
	var mass: Float {
		return diameter
	}
	
	func consume(_ body: CelestialBody) {
		_diameter += body.diameter * 0.5
	}
	
	init(withDiameter diameter: Float?) {
		_diameter = diameter != nil ?  diameter! : Comet.startingDiameter
		super.init()
	}
	convenience override init() {
		self.init(withDiameter:0.4)
	}
}

class CometNodeTouchListener: SKSpriteNode {
	weak var cometNode: CometNode?
	
	init(withCometNode comet: CometNode) {
		self.cometNode = comet
		super.init(texture: nil,
				   color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0),
				   size: CGSize(width: self.cometNode!.size.width*3.0, height: self.cometNode!.size.height*3.0))
		self.isUserInteractionEnabled = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let comet = cometNode {
			comet.touchesBegan(touches, with: event)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let comet = cometNode {
			comet.touchesMoved(touches, with: event)
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let comet = cometNode {
			comet.touchesEnded(touches, with: event)
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let comet = cometNode {
			comet.touchesCancelled(touches, with: event)
		}
	}
}

class CometNode: CelestialBodyNode {
	var comet: Comet { return body as! Comet }
	var launched = false
	let sun: CelestialBodyNode
	var velocity: CGPoint = .zero
	var startingVelocity: CGPoint?
	
	init(withComet comet: Comet, scaleFactor: CGFloat, sun: CelestialBodyNode) {
		self.sun = sun
		super.init(withBody: comet, scaleFactor: scaleFactor)
		self.isUserInteractionEnabled = false
		addChild(CometNodeTouchListener(withCometNode: self))
		
		self.physicsBody?.categoryBitMask = PhysicsID.comet
		self.physicsBody?.contactTestBitMask = PhysicsID.orbiter | PhysicsID.sun
	}
	
	func update(_ deltaTime: TimeInterval) {
		self.position = self.position + velocity * CGFloat(deltaTime);
		
		if launched {
			let toSun = sun.position - self.position
			let distance = toSun.length()
			let sunGravity = toSun.normalized() * (150000.0 / pow(distance, 1.75))
			velocity = velocity + sunGravity
			
			// apply some artificial force for fun
			if self.position.y > sun.position.y {
				assert(startingVelocity != nil)
				let artificialForce = CGPoint(x: startingVelocity!.x > 0.0 ? -5.0 : 5.0,
											  y: -12.0)
				velocity = velocity + artificialForce
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("touch began")
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			velocity = (CGPoint.zero - touch.location(in: self)) * 3.0
			startingVelocity = velocity
			launched = true
		}
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		
	}
}
