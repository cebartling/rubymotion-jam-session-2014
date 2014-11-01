class SkyLineScene < SKScene
  WORLD = 0x1 << 1

  def didMoveToView(view)
    super

    physicsWorld.gravity = CGVectorMake(0.0, -5.0)
    physicsWorld.contactDelegate = self

    add_skyline
    add_ground
    add_dude
    # add_pause_label
    # begin_spawning_pipes
  end

  # def add_pause_label
  #   label = SKLabelNode.labelNodeWithFontNamed("Chalkduster")
  #   label.text = "Pause"
  #   label.position = CGPointMake(80, 500)
  #   label.name = "pause"
  #   addChild label
  # end

  def add_skyline
    texture = SKTexture.textureWithImageNamed("skyline.png")

    2.times do |i|
      x_position = mid_x + (i * mid_x * 2)
      skyline = SKSpriteNode.spriteNodeWithTexture(texture)
      skyline.position = CGPointMake(x_position, mid_y)
      skyline.name = "skyline"
      skyline.zPosition = -20
      skyline.scale = 1.12
      # skyline.runAction scroll_action(mid_x, 0.1)

      addChild skyline
    end
  end

  # Alternative method to using actions.
  #
  def move_background
    self.enumerateChildNodesWithName "skyline", usingBlock: -> (node, stop) {
      velocity = CGPointMake(-20, 0)
      movement_amount = CGPointMake(velocity.x * @delta, velocity.y * @delta)
      node.position = CGPointMake(node.position.x + movement_amount.x, node.position.y + movement_amount.y)

      if node.position.x <= -node.size.width / 2
        node.position = CGPointMake((node.position.x + node.size.width) * 2, node.position.y)
      end
    }
  end

  def add_ground
    texture = SKTexture.textureWithImageNamed("ground.png")
    x = CGRectGetMidX(self.frame) + 7

    2.times do |i|
      ground = SKSpriteNode.spriteNodeWithTexture texture
      ground.position = CGPointMake(x + (i * x * 2), 56)
      ground.runAction scroll_action(x, 0.02)

      addChild ground
    end

    addChild PhysicalGround.alloc.init
  end

  def add_dude
    addChild Dude.alloc.init
  end

  def begin_spawning_pipes
    pipes = SKAction.performSelector("add_pipes", onTarget: self)
    delay = SKAction.waitForDuration(4.0)
    sequence = SKAction.sequence([pipes, delay])

    runAction SKAction.repeatActionForever(sequence)
  end

  def add_pipes
    addChild PipePair.alloc.init
  end

  # This action is used for both the ground and sky.
  #
  def scroll_action(x, duration)
    width = (x * 2)
    move = SKAction.moveByX(-width, y: 0, duration: duration * width)
    reset = SKAction.moveByX(width, y: 0, duration: 0)

    SKAction.repeatActionForever(SKAction.sequence([move, reset]))
  end

  def update(current_time)
    @delta = @last_update_time ? current_time - @last_update_time : 0
    @last_update_time = current_time

    check_controller

    move_background
    rotate_dude
  end


  def touchesBegan(touches, withEvent: event)
    touch = touches.anyObject
    location = touch.locationInNode(self)
    node = nodeAtPoint(location)
    # puts node.name

    # if node.name == "pause"
    #   if self.isPaused
    #     self.paused = false
    #   else
    #     self.paused = true
    #   end
    # else
      dude_jump
    # end
  end

  def dude_jump
    dude = childNodeWithName(Dude::NAME)

    dude.physicsBody.velocity = CGVectorMake(0, 0)
    dude.physicsBody.applyImpulse CGVectorMake(0, 8)
  end

  def rotate_dude
    node = childNodeWithName(Dude::NAME)
    dy = node.physicsBody.velocity.dy
    node.zRotation = max_rotate(dy * (dy < 0 ? 0.003 : 0.001))
  end

  def check_controller
    controllers = GCController.controllers

    if controllers.count > 1
      controller = controller.first.extendedGamepad

      if controller.buttonA.isPressed?
        dude_jump
      end
    end
  end

  def max_rotate(value)
    if value > 0.7
      0.7
    elsif value < -0.3
      -0.3
    else
      value
    end
  end

  # Contact delegate method
  #
  # def didBeginContact(contact)
  #   dude = childNodeWithName(Dude::NAME)
  #   dude.position = CGPointMake(80, CGRectGetMidY(self.frame))
  #   dude.zRotation = 0
  #
  #   enumerateChildNodesWithName "pipes", usingBlock:-> (node, stop) { node.removeFromParent }
  # end

  # Alternate Contact Method for multiple contact bodies.
  #
  def didBeginContact(contact)
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
      dude = contact.bodyA
    else
      dude = contact.bodyB
    end

    if dude.categoryBitMask == Bird::BIRD
      dude.node.zRotation = 0
      dude.node.position = CGPointMake(80, CGRectGetMidY(self.frame))

      enumerateChildNodesWithName "pipes", usingBlock: -> (node, stop) { node.removeFromParent }
    end
  end

  # Helper methods.
  #
  def mid_x
    CGRectGetMidX(self.frame)
  end

  def mid_y
    CGRectGetMidY(self.frame)
  end
end
