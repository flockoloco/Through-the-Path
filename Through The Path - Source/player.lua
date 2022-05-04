require "vector2"
require "enemies"
require "collision"

local player = {position = vector2.new (0,900), 
                velocity = vector2.new (0, 0),
                size = vector2.new (30, 60),
                maxvelocity = vector2.new(150, 400),
                mass = 1,
                onGround = false,
                frictioncoefficient = 600,
                maxairfric = 600, 
                lifes = 3,
                health = 100,
                maxhealth = 100,
                direction = vector2.new(1,0),
                maxinvicd = 2,
                invicd = 0,
                attacktimer = 0,
                maxattacktimer = 2.5,
                maxattacktimer2 = 5,
                attack = 20,
                attack2 = 40,
                Stop = true,
--                falling = false,
                animationJumpo = false
             }
              
isDead = false
local gravity = vector2.new(0, 980)

local playerAnimation = {}
local playerAnimationTimer = 0  
local playerAnimationFrame = 1


  if player.velocity.y == 1 then
    player.Falling = true 
  end
function CheckIsDead()

  return player.isDead

end 

function LoadPlayer()
  
      for i = 1 ,33,1 do

    playerAnimation[i] = love.graphics.newImage("Animation/" .. i .. ".png")

end
end

function UpdatePlayer (dt, world, enemies) 


  if player.Stop == true and player.animationJumpo == false then
    playerAnimationTimer = playerAnimationTimer + dt
    if playerAnimationTimer > 0.1 then
    playerAnimationFrame = playerAnimationFrame + 1 
    playerAnimationTimer = 0
      if playerAnimationFrame > 4 then
        playerAnimationFrame = 1
    end
  end
end




  --attack timer 
  if (player.attacktimer > 0) then                            
    player.attacktimer = player.attacktimer - dt
  end

  if (player.invicd > 0) then 
    player.invicd = player.invicd - dt
  end

   -- If lifes = 0 end the game
    
  if player.position.y > love.graphics.getHeight() then 
    player.position.x = 200
    player.position.y = 300
    player.lifes = player.lifes - 1 
    player.health = player.maxhealth
    isDead = true;
 end
    
  if player.position.x <= 0 then
    player.position.x = 380
  end
    
  if player.health > 100 then 
    player.health = 100 
  end 
  
  local acceleration = vector2.new (0,0)
    acceleration = vector2.applyForce (gravity, player.mass, acceleration)
    
  -- fixes the small movement when stopped
    
  if vector2.magnitude (player.velocity) > 5 then 
    local friction = vector2.mult (vector2.normalize (vector2.mult(player.velocity, -1)), player.frictioncoefficient)
      acceleration = vector2.applyForce (friction, player.mass, acceleration)
    else
      player.velocity = vector2.new(0,0)
  end
    
   -- Movement 
    
  local movementdirection = vector2.new(0,-1)
    
  if love.keyboard.isDown ("d") then
    player.Stop = false
    local move = vector2.new(800, 0)
      acceleration = vector2.applyForce(move, player.mass, acceleration)
      movementdirection.x = 1
      player.direction.x = 1 
    if player.animationJumpo == false then 
      playerAnimationTimer = playerAnimationTimer + dt
    if playerAnimationTimer > 0.1 then
      playerAnimationFrame = playerAnimationFrame + 1
      playerAnimationTimer = 0
    if playerAnimationFrame < 9 or playerAnimationFrame > 12 then
      playerAnimationFrame = 9
      end
    end
  end
end

  if love.keyboard.isDown ("a") then
    local move = vector2.new(-800, 0)
      acceleration = vector2.applyForce(move, player.mass, acceleration)
      movementdirection.x = -1
      player.direction.x = -1 
      player.Stop = false
      if player.animationJumpo == false then 
      playerAnimationTimer = playerAnimationTimer + dt
    if playerAnimationTimer > 0.1 then
      playerAnimationFrame = playerAnimationFrame + 1
      playerAnimationTimer = 0
    if playerAnimationFrame < 19 or playerAnimationFrame > 22 then
      playerAnimationFrame = 19
      end
    end
  end
  end

  if love.keyboard.isDown ("w") and player.onGround and player.velocity.y == 0 then
    player.Stop = false
    player.velocity.y = -10000
    player.onGround = false
    movementdirection.y = 1
    player.direction.x = player.direction.x
    player.animationJumpo = true
    if player.direction.x == 1 then
    playerAnimationFrame = 6
    end
    if player.direction.x == -1 then
    playerAnimationFrame = 32
    end
  
  elseif player.velocity.y > 0 then 
      player.velocity.y = player.velocity.y * 1.1 
      
end
  
  if player.direction.x == 1 then
  if player.animationJumpo == true then 
    playerAnimationTimer = playerAnimationTimer + dt
      if playerAnimationTimer > 0.15 then
    playerAnimationFrame = playerAnimationFrame + 1 
    playerAnimationTimer = 0
    if playerAnimationFrame > 7 or playerAnimationFrame < 5 then
      if playerAnimationFrame> 7 then
        player.animationJumpo = false
        player.Stop = true
        end
        playerAnimationFrame = 1
    end
  end
end
elseif player.direction.x == -1 then
  if player.animationJumpo == true then 
    playerAnimationTimer = playerAnimationTimer + dt
      if playerAnimationTimer > 0.15 then
    playerAnimationFrame = playerAnimationFrame + 1 
    playerAnimationTimer = 0
    if playerAnimationFrame < 31 or playerAnimationFrame > 33 then
      if playerAnimationFrame > 31 then
        player.animationJumpo = false
        --player.Stop = true
        end
      playerAnimationFrame = 31
    end
  end
end
playerAnimationFrame = playerAnimationFrame
end  
  
  print(playerAnimationFrame)





  --Basic Attack
  
  if love.keyboard.isDown("j") and (player.attacktimer <= 0) then
  player.attacktimer = player.maxattacktimer
  player.Stop = false
  for i = 1, #enemies, 1 do
      if player.direction.x == 1 then 
        
        local collisiondirection = GetBoxCollisionDirection(player.position.x + (player.direction.x * 5), player.position.y + (player.direction.y * 5),            player.size.x + (30 * player.direction.x) , player.size.y, enemies[i].position.x, enemies[i].position.y, enemies[i].size.x, enemies[i].size.y)

          if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
            enemies[i].velocity.x = player.direction.x * 1000000000000
            enemies[i].health = enemies[i].health - player.attack
          end
          
      elseif player.direction.x == -1 then 
        local collisiondirection = GetBoxCollisionDirection(player.position.x -55  , player.position.y + (player.direction.y * 5), player.size.x + 55 ,             player.size.y, enemies[i].position.x, enemies[i].position.y, enemies[i].size.x, enemies[i].size.y)

          if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
              enemies[i].velocity.x = player.direction.x * 1000000000000
              enemies[i].health = enemies[i].health - player.attack
          end
      end
    end
      if player.animationJumpo == false then 
      playerAnimationTimer = playerAnimationTimer + dt
    if playerAnimationTimer > 0.01 then
      playerAnimationFrame = playerAnimationFrame + 1
      playerAnimationTimer = 0
    if playerAnimationFrame < 13 or playerAnimationFrame > 14 then
      playerAnimationFrame = 13
      end
    end
  end
  player.Stop = true
  end
     -- second attack
  if love.keyboard.isDown("k") and (player.attacktimer <= 0) then
   player.attacktimer = player.maxattacktimer2
   player.Stop = false
   for i = 1, #enemies, 1 do
      if player.direction.x == 1 then
        local collisiondirection = GetBoxCollisionDirection(player.position.x + (player.direction.x * 5), player.position.y + (player.direction.y * 5),              player.size.x + (30 * player.direction.x) , player.size.y, enemies[i].position.x, enemies[i].position.y, enemies[i].size.x, enemies[i].size.y)
      
        if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
            enemies[i].velocity.x = player.direction.x * 1000000000000
            enemies[i].health = enemies[i].health - player.attack2
        end
        elseif player.direction.x == -1 then
          local collisiondirection = GetBoxCollisionDirection(player.position.x -55  , player.position.y + (player.direction.y * 5), player.size.x + 55 ,               player.size.y, enemies[i].position.x, enemies[i].position.y, enemies[i].size.x, enemies[i].size.y)
          if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
            enemies[i].velocity.x = player.direction.x * 1000000000000
            enemies[i].health = enemies[i].health - player.attack2
          end
        end
    end
    if player.direction.x == 1 then
    if player.animationJumpo == false then 
      playerAnimationTimer = playerAnimationTimer + dt
    if playerAnimationTimer > 0.01 then
      playerAnimationFrame = playerAnimationFrame + 1
      playerAnimationTimer = 0
    if playerAnimationFrame < 15 or playerAnimationFrame > 18 then
      playerAnimationFrame = 15
      end
      end
      end
    elseif player.direction.x == -1 then 
        if player.animationJumpo == false then 
      playerAnimationTimer = playerAnimationTimer + dt
    if playerAnimationTimer > 0.01 then
      playerAnimationFrame = playerAnimationFrame + 1
      playerAnimationTimer = 0
    if playerAnimationFrame < 25 or playerAnimationFrame > 28 then
      playerAnimationFrame = 25
    end
    end
    end
    end
  player.Stop = true
end
   
  -- health cheat
  if love.keyboard.isDown("h") then 
    player.health = 100
   end
  -- Velocity Cheat
  if love.keyboard.isDown("right") then 
  player.maxvelocity.x = 1000000000000
  else
  player.maxvelocity.x = 150
  end 
  --attack cheat
  if love.keyboard.isDown("l") then 
  player.attack = 10000
  player.attack2 = 10000
  else 
  player.attack = 20
  player.attack2 = 40
  end
  
  --calculate the future velocity

  local futurevelocity = vector2.add(player.velocity, vector2.mult(acceleration, dt))
  
  if futurevelocity.x > 0 then --limiting the movement speed
    futurevelocity.x = math.min(futurevelocity.x, player.maxvelocity.x);
    futurevelocity.x = math.max(futurevelocity.x, -player.maxvelocity.x);
  end
  
  if futurevelocity.y > 0 then --limiting the jump velocity
    futurevelocity.y = math.min(futurevelocity.y, player.maxvelocity.y);
    futurevelocity.y = math.max(futurevelocity.y, -player.maxvelocity.y);
  end
  
  local futureposition = vector2.add(player.position, vector2.mult(futurevelocity, dt))
    acceleration = CheckCollision(world, enemies, futureposition, movementdirection, acceleration)
    player.velocity = vector2.add(player.velocity, vector2.mult(acceleration, dt))
  if player.velocity.x > 0 then --limiting the movement speed
    player.velocity.x = math.min(player.velocity.x, player.maxvelocity.x);
  else
    player.velocity.x = math.max(player.velocity.x, -player.maxvelocity.x);
  end

  if player.velocity.y > 0 then --limiting the jump velocity
    player.velocity.y = math.min(player.velocity.y, player.maxvelocity.y); 
  else
    player.velocity.y = math.max(player.velocity.y, -player.maxvelocity.y);
  end
    player.position = vector2.add(player.position, vector2.mult(vector2.mult(player.velocity, 2), dt))
end

function CheckCollision(world, enemies, futureposition, movementdirection, acceleration)
    
  for i = 1, #world, 1 do
    
    --find what which direction the collision is on
    local collisiondir = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.size.x, player.size.y, world[i].position.x, world[i].position.y,       world[i].size.x, world[i].size.y)
    
    -- if collisiondir.x and .y isnt 0 then
    if not (collisiondir.x == 0 and collisiondir.y == 0 ) then
    
      --if collisiondirection y is the same as movementdirection y, then collision is on the top
      if collisiondir.y == movementdirection.y then
        player.velocity.y = 0
        acceleration.y = 0
        player.onGround = true
    
      --down collision
      elseif collisiondir.y == 1 then
        player.velocity.y = 0
        acceleration.y = 0
    
      --side collision
      elseif movementdirection.x ~= collisiondir.x then
        player.velocity.x = 0
        acceleration.x = 0
      end
    end
  end

  for i = 1, #enemies, 1 do

  --find what which direction the collision is on

  local collisiondirect = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.size.x, player.size.y, enemies[i].position.x, enemies[i].           position.y, enemies[i].size.x, enemies[i].size.y)

  -- if collisiondir.x and .y isnt 0 then
    if not (collisiondirect.x == 0 and collisiondirect.y == 0 ) then
   
      --if collisiondirection y is the same as movementdirection y, then collision is on the top
      if collisiondirect.y == movementdirection.y and (player.invicd <= 0) then
        player.velocity.y = 0
        acceleration.y = 0
        player.onGround = true
        player.health = player.health - enemies[i].damage
        player.invicd = player.maxinvicd
        
      if player.direction.x == 1 then
        if playerAnimationTimer > 0.01 then
          playerAnimationFrame = playerAnimationFrame + 1
          playerAnimationTimer = 0
          playerAnimationFrame = 29
        end
      elseif player.direction.x == -1 then 
        if playerAnimationTimer > 0.01 then
          playerAnimationFrame = playerAnimationFrame + 1
          playerAnimationTimer = 0
          playerAnimationFrame = 30
        end
      end
        
      --down collision
      elseif collisiondirect.y == 1 and (player.invicd <= 0) then
        player.velocity.y = 0
        acceleration.y = 0
        player.health = player.health - enemies[i].damage
        player.invicd = player.maxinvicd
        
    if player.direction.x == 1 then
      if playerAnimationTimer > 0.01 then
        playerAnimationFrame = playerAnimationFrame + 1
        playerAnimationTimer = 0
        playerAnimationFrame = 29
      end
    elseif player.direction.x == -1 then 
      if playerAnimationTimer > 0.01 then
        playerAnimationFrame = playerAnimationFrame + 1
        playerAnimationTimer = 0
        playerAnimationFrame = 30
      end
    end
        
      --side collision
      elseif movementdirection.x ~= collisiondirect.x and (player.invicd <= 0) then
        player.velocity.x = 0
        acceleration.x = 0
        player.health = player.health - enemies[i].damage
        player.invicd = player.maxinvicd

  if player.direction.x == 1 then
    if playerAnimationTimer > 0.01 then
      playerAnimationFrame = playerAnimationFrame + 1
      playerAnimationTimer = 0
      playerAnimationFrame = 29
    end
  elseif player.direction.x == -1 then 
    if playerAnimationTimer > 0.01 then
      playerAnimationFrame = playerAnimationFrame + 1
      playerAnimationTimer = 0
      playerAnimationFrame = 30
    end
  end
      
      end 
      
    end
          if player.health <= 0 then
        isDead = true;
        player.position.x = 200
        player.position.y = 300
        player.lifes = player.lifes - 1
        player.health = player.maxhealth
      end
  end
  return acceleration
end
  
  --Get player position
function GetPlayerPosition()
  return player.position
end
-- GetPlayer
function GetPlayer()
  return player
end

function DrawPlayer ()

  --Player's life bar
  
  love.graphics.setColor(1, 0, 0)
  love.graphics.rectangle("fill", 10, 10, player.health * 2, 30)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", 10 , 10, 200, 30)
  
  --Player
  love.graphics.setColor(1,1,1)
  love.graphics.draw(playerAnimation[playerAnimationFrame], 380, player.position.y, 0, 1.6, 1.6)


--  love.graphics.rectangle("fill", 380, player.position.y, player.size.x, player.size.y)
--  love.graphics.setColor(1, 1, 0)
--  love.graphics.rectangle("fill", 380, player.position.y, player.size.x, player.size.y)
  
  --Player's lifes
  
  love.graphics.setColor(0, 0, 0) 
  love.graphics.print(player.lifes , 10, 95) 
  
  --player's Sword
--  if love.keyboard.isDown("j") or love.keyboard.isDown("k") then
--    if player.direction.x == 1 then 
--    playerAnimationFrame = 1
--    end
--    if player.direction.x == -1 then 
--    playerAnimationFrame = 19
--    end 
--  end 
  
  -- Cooldown 
  love.graphics.setColor(1, 1, 0)
  love.graphics.rectangle("fill", 10, 55, 75 - player.attacktimer *15, 30)
  love.graphics.setColor(0,0,0)
  love.graphics.rectangle("line", 10 ,55, player.maxattacktimer2*15, 30)

  
  end