import Foundation
import UIKit

class CelestialBody {
	var color: UIColor {
		return UIColor.white
	}
	var diameter: Float {
		return 1.0
	}
	var dead = false {
		didSet {
			if let deadHandler = deadHandler {
				deadHandler(dead)
			}
		}
	}
	var deadHandler: ((Bool) -> Void)?
}

class Sun: CelestialBody {
	override var color: UIColor {
		return UIColor.yellow
	}
	override var diameter: Float {
		return 2.0
	}
}

class Orbiter: CelestialBody {
	var orbitalDistance: Float = randomFloatBetween(min: 3.0, max: 6.0)
	var orbitingSpeed: Float = randomFloatBetween(min: 0.01, max: 0.1)
}

class SpaceDust: Orbiter {
	override var diameter: Float {
		return randomFloatBetween(min: 0.05, max: 0.15)
	}
}

class RandomizedPlanet: Orbiter {
	private let _color: UIColor
	private let _diameter: Float
	
	override var color: UIColor {
		return _color
	}
	override var diameter: Float {
		return _diameter
	}
	
	override init() {
		_color = randomColor()
		_diameter = randomFloatBetween(min: 0.5, max: 1.5)
		super.init()
	}
}
