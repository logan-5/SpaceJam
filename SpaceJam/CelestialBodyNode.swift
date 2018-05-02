import Foundation
import SpriteKit

class PhysicsID {
	static let none: UInt32 = 0b000
	static let sun: UInt32 = 0b001
	static let orbiter: UInt32 = 0b010
	static let comet: UInt32 = 0b100
}

class CelestialBodyNode: SKSpriteNode {
	let body: CelestialBody
	
	init(withBody body: CelestialBody, scaleFactor: CGFloat) {
		self.body = body
		let size = CGFloat(body.diameter) * scaleFactor
		super.init(texture: SKTexture(imageNamed: "circle"),
				   color: body.color,
				   size: CGSize(width: size, height: size))
		self.colorBlendFactor = 1.0
		
		let physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
		physicsBody.isDynamic = true
		physicsBody.collisionBitMask = PhysicsID.none
		//		physicsBody.usesPreciseCollisionDetection = true
		self.physicsBody = physicsBody
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class SunNode: CelestialBodyNode {
	var sun: Sun { return body as! Sun }
	init(withSun body: Sun, scaleFactor: CGFloat) {
		super.init(withBody: body, scaleFactor: scaleFactor)
		
		self.physicsBody?.categoryBitMask = PhysicsID.sun
		self.physicsBody?.contactTestBitMask = PhysicsID.comet
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class OrbiterNode: CelestialBodyNode {
	var orbiter: Orbiter { return body as! Orbiter }
	init(withBody body: Orbiter, scaleFactor: CGFloat) {
		super.init(withBody: body, scaleFactor: scaleFactor)
		
		self.physicsBody?.categoryBitMask = PhysicsID.orbiter
		self.physicsBody?.contactTestBitMask = PhysicsID.comet
		
		self.orbiter.deadHandler = { (dead: Bool) in
			self.isHidden = dead
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
