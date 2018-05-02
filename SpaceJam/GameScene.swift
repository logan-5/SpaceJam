import SpriteKit
import GameplayKit

var levelNumber = 1
var planetProbability: Float = 0.0

class GameScene: SKScene, SKPhysicsContactDelegate {
	var orbitNode: OrbitNode?
	var cometNode: CometNode?
	var lastTime: TimeInterval?
	
	let scoreDisplay = SKLabelNode(text: nil)
	
	static func scoreString(_ score: Float) -> String {
		return String(format: "Orbital mass absorbed: %f", score)
	}
	
    override func didMove(to view: SKView) {
		self.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.05, alpha: 1.0)
		
		let halfSize = CGPoint(self.size)/2.0
		let minDim = min(self.size.width, self.size.height)
		let margin  = 0.05 * minDim
		scoreDisplay.position = CGPoint(x: margin - halfSize.x, y: halfSize.y - margin)
		scoreDisplay.horizontalAlignmentMode = .left
		scoreDisplay.verticalAlignmentMode = .top
		scoreDisplay.text = GameScene.scoreString(0.0)
		scoreDisplay.fontSize = 30.0
		scoreDisplay.fontColor = .white
		addChild(scoreDisplay)
		
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		
		newGame()
		
		addChild(Dialog(withString: String(format: "Level %d", levelNumber), size: self.size))
    }
	
	func newGame() {
		if let orbitNode = self.orbitNode {
			orbitNode.removeFromParent()
		}
		let orbitNode = OrbitNode(withOrbit: Orbit(), scaleFactor: 50.0, distanceFactor: 50.0)
		addChild(orbitNode)
		self.orbitNode = orbitNode
		
		if let cometNode = self.cometNode {
			cometNode.removeFromParent()
		}
		self.cometNode = nil
		placeComet()
	}
	
	func placeComet() {
		let diameter: Float? = self.cometNode != nil ? self.cometNode!.comet.diameter : nil
		if let cometNode = self.cometNode {
			cometNode.removeFromParent()
		}
		
		let cometNode = CometNode(withComet: Comet(withDiameter: diameter), scaleFactor: 50.0, sun: orbitNode!.sunNode)
		cometNode.position = CGPoint(x: cometNode.position.x, y: -0.333 * size.height)
		addChild(cometNode)
		self.cometNode = cometNode
		let diameterHandler = { (diameter: Float, startingDiameter: Float) -> Void in
			self.scoreDisplay.text = GameScene.scoreString(diameter - startingDiameter)
		}
		cometNode.comet.didSetDiameterHandler = diameterHandler
		diameterHandler(cometNode.comet.diameter, Comet.startingDiameter)
	}
	
	func winLevel() {
		planetProbability += 0.0333
		levelNumber += 1
		newGame()
		addChild(Dialog(withString: String(format: "Level %d", levelNumber), size: self.size))
	}
	
	func loseLevel() {
		newGame()
		addChild(Dialog(withString: ":(", size: self.size))
	}
	
    override func update(_ currentTime: TimeInterval) {
		let dt = lastTime == nil ? 0.016 : currentTime - lastTime!
		lastTime = currentTime
		
		if let orbit = orbitNode {
//			if !orbit.sunNode.body.dead {
			if !orbit.orbit.orbiters.contains(where: { !$0.dead }) {
				winLevel()
				return
			}
		}
		
		if let cometNode = self.cometNode {
			cometNode.update(dt)
			
			let halfSize = CGSize(width: self.size.width/2.0, height: self.size.height/2.0)
			let screenBounds = CGRect(x: -halfSize.width, y: -halfSize.height, width: self.size.width, height: self.size.height)
			if !screenBounds.contains(cometNode.position) {
				placeComet()
			}
		}
    }
	
	func cometCollidedWithSun(comet: CometNode, sun: SunNode) {
		loseLevel()
	}
	func cometCollidedWithOrbiter(comet: CometNode, orbiter: OrbiterNode) {
		if comet.comet.diameter >= orbiter.orbiter.diameter {
			comet.comet.consume(orbiter.orbiter)
			orbiter.orbiter.dead = true
		} else {
			loseLevel()
		}
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		let cometFirst = contact.bodyA.categoryBitMask & PhysicsID.comet != 0
		let cometBody = cometFirst ? contact.bodyA : contact.bodyB
		let otherBody = cometFirst ? contact.bodyB : contact.bodyA

		if let comet =  cometBody.node as? CometNode {
//			if let celestialBody = otherBody.node as? CelestialBodyNode {
//				if comet.comet.diameter >= celestialBody.body.diameter {
//					comet.comet.consume(celestialBody.body)
//					celestialBody.body.dead = true
//					return
//				}
//			}
			if let sun = otherBody.node as? SunNode {
				cometCollidedWithSun(comet: comet, sun: sun)
			} else if let orbiter = otherBody.node as? OrbiterNode {
				cometCollidedWithOrbiter(comet: comet, orbiter: orbiter)
			}
		}
	}
}
