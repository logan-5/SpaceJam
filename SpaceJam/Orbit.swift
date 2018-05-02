import Foundation

func randomOrbiter() -> Orbiter {
	if randomFloat() <= planetProbability {
		return RandomizedPlanet()
	} else {
		return SpaceDust()
	}
}

class Orbit {
	let sun: Sun
	let orbiters: [Orbiter]
	
	init(/* TODO supply special suns and stuff */) {
		sun = Sun()
		
		let numberOfOrbiters = Int(randomUnsignedIntBetween(min: 30, max: 50))
		let orbiters = [Orbiter](count: numberOfOrbiters, elementCreator: randomOrbiter)
		self.orbiters = orbiters.sorted(by: { $0.orbitalDistance < $1.orbitalDistance })
	}
}
