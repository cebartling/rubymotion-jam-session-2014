class WhiteRussian < SKSpriteNode

  def init
    super
    self.initWithImageNamed('white-russian.png')
    self.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(size)
    self.physicsBody.categoryBitMask = SkyLineScene::WORLD
    self.physicsBody.dynamic = false
    self.position = CGPointMake(300, random_y + 200)
    self.runAction(action_sequence)
    self
  end

  def random_y
    @y ||= Random.new.rand 0.0..(150.0)
  end

  def action_sequence
    distance = 320
    throw = SKAction.moveByX(-distance, y: 0, duration: 0.02 * distance)
    remove = SKAction.removeFromParent
    SKAction.sequence([throw, remove])
  end
end

