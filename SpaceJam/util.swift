import Foundation
import UIKit

func randomFloat() -> Float {
	return Float(arc4random()) / Float(UINT32_MAX)
}

func randomFloatBetween(min: Float, max: Float) -> Float {
	return randomFloat() * (max - min) + min
}

func randomCGFloat() -> CGFloat { return CGFloat(randomFloat()) }

func randomColor() -> UIColor {
	return UIColor(hue: randomCGFloat(), saturation: randomCGFloat(), brightness: randomCGFloat(), alpha: 1.0)
}

func randomUnsignedIntBetween(min: UInt32, max: UInt32) -> UInt32 {
	return arc4random_uniform(max - min) + min
}

extension Array {
	public init(count: Int, elementCreator: () -> Element) {
		self = (0 ..< count).map { _ in elementCreator() }
	}
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
	return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
	return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

extension CGPoint {
	init(_ size: CGSize) {
		self = CGPoint(x: size.width, y: size.height)
	}
	func length() -> CGFloat {
		return sqrt(x*x + y*y)
	}
	
	func normalized() -> CGPoint {
		return self / length()
	}
}

extension CGSize {
	init(_ point: CGPoint) {
		self = CGSize(width: point.x, height: point.y)
	}
}
