class Dude < SKSpriteNode

  NAME = 'dude'

  DUDE = 0x1 << 0

  def init
    self.initWithImageNamed("dude_one.png")
    self.physicsBody = physics_body
    self.position = CGPointMake(80, 400)
    self.scale = 1.1
    self.name = NAME
    self.runAction walk
    self
  end

  def walk
    textures = [
      SKTexture.textureWithImageNamed("dude_one.png"),
      SKTexture.textureWithImageNamed("dude_one.png"),
      SKTexture.textureWithImageNamed("dude_one.png")
    ]
    animation = SKAction.animateWithTextures(textures, timePerFrame: 0.15)
    SKAction.repeatActionForever(animation)
  end

  def physics_body
    body = SKPhysicsBody.bodyWithRectangleOfSize(size)
    body.friction = 0.0
    body.categoryBitMask = DUDE
    body.contactTestBitMask = SkyLineScene::WORLD
    body.usesPreciseCollisionDetection = true
    body
  end
end
