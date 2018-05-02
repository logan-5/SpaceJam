import Foundation
import SpriteKit

class OrbitNode: SKNode {
	let orbit: Orbit
	let sunNode: SunNode
	
	init(withOrbit orbit: Orbit, scaleFactor: CGFloat, distanceFactor: CGFloat) {
		self.orbit = orbit
		self.sunNode = SunNode(withSun: orbit.sun, scaleFactor: scaleFactor)
		super.init()
		
		let orbiters = orbit.orbiters.map{ OrbiterNode(withBody: $0, scaleFactor: scaleFactor) }
//		for orbiter in orbiters {
//			let orbitalDistance = Double(orbiter.orbiter.orbitalDistance) * Double(distanceFactor)
//			let randomRotation = Double(randomFloatBetween(min: 0.0, max: Float.pi * 2.0))
//
//			let size = Double(orbiter.size.width)
//			orbiter.anchorPoint = CGPoint(x: -cos(randomRotation) * orbitalDistance / size, y: -sin(randomRotation) * orbitalDistance / size)
//		}
		let nodes = orbiters.map{ (orbiter: OrbiterNode) -> SKNode in
			let orbitalDistance = Double(orbiter.orbiter.orbitalDistance) * Double(distanceFactor)
			let randomRotation = Double(randomFloatBetween(min: 0.0, max: Float.pi * 2.0))
			
			orbiter.position = CGPoint(x: cos(randomRotation) * orbitalDistance, y: sin(randomRotation) * orbitalDistance)
			let parent = SKNode()
			parent.addChild(orbiter)
			
			let orbitTime = TimeInterval(CGFloat(orbiter.orbiter.orbitalDistance * 2.0) * CGFloat.pi) / TimeInterval(orbiter.orbiter.orbitingSpeed)
			parent.run(SKAction.repeatForever(SKAction.rotate(byAngle: 360.0, duration: orbitTime)))
			
			return parent
		} + [self.sunNode]
		for node in nodes {
			addChild(node)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
