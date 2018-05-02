import Foundation
import SpriteKit

class Dialog: SKSpriteNode {
	init(withString string: String, size: CGSize) {
		super.init(texture: nil, color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.9), size: size)
		
		self.isUserInteractionEnabled = true
		let text = SKLabelNode(text: string)
		text.fontColor = UIColor.white
		text.fontSize = 100
		addChild(text)
		
		self.zPosition = 1000
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.25), SKAction.removeFromParent()]))
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

	}
}
