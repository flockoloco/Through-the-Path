require "vector2" 
require "world"
require "projectile" 
require "collision"

local PATROL, ATTACK = 1, 2

function CreateEnemy(x, y, t)
  
local vdir, mdir, height , width
  
  if t == 1 then      -- Boar
    
    size = vector2.new(60,40)
    vdir = vector2.new(1,0)
    mdir = vector2.new(-100, 0)
    damage = 10
    health = 100
    
  elseif t == 2 then     -- Armadillo
    
    size = vector2.new(45,45)
    vdir = vector2.new(1,0)
    mdir = vector2.new(-100,0)
    damage = 15
    health = 80
    
  elseif t == 3 then     -- Bird
      
    size = vector2.new(45,30)
    vdir = vector2.new (1,0) 
    mdir = vector2.new (-100,0)
    damage = 20
    health = 80
    
  end
      
  return{ position = vector2.new(x,y),
          velocity = mdir,
          size = size, 
          etype = t,
          mass = 1,
          movedirection = vdir,
          movechangetime = 2,
          movetimer = 0,
          chasing = false,
          viewangle = 20,
          damage = damage,
          health = health,
          shootrate = 1,
          shoottimer = 0,
          projectiles = {},
          maxviewdistance = 400,
          state = PATROL,
          maxvelocity = 100
          }
end

local BirdEnemyAnimation = {}
local BirdEnemyAnimationTimer = 0
local BirdEnemyAnimationFrame = 1
local BoarEnemyAnimation = {}
local BoarEnemyAnimationTimer = 0
local BoarEnemyAnimationFrame = 1
local TatuEnemyAnimation = {}
local TatuEnemyAnimationTimer = 0
local TatuEnemyAnimationFrame = 1

function LoadEnemy()
  
      for i = 1 , 6, 1 do

    BirdEnemyAnimation[i] = love.graphics.newImage("Bird/" .. i .. ".png")

end

    for i =  1, 8, 1 do
      BoarEnemyAnimation[i] = love.graphics.newImage("Boar/" .. i .. ".png")
  end
  
      for i =  1, 8, 1 do
      TatuEnemyAnimation[i] = love.graphics.newImage("Armadillo/" .. i .. ".png")
  end
end

function UpdateEnemies(dt,enemies,world, player)
  
  for i = 1, #enemies, 1 do
  local playerdirection = vector2.sub(player.position, enemies[i].position)
  local playerdistance = vector2.magnitude(playerdirection)
    local acceleration = vector2.new(0,0)
    local futurevelocity = vector2.add(enemies[i].velocity, vector2.mult(acceleration, dt))
    local futureposition = vector2.new(0,0)
    futurevelocity = vector2.limit(futurevelocity, enemies[i].maxvelocity)
    futureposition = vector2.add(enemies[i].position, vector2.mult(futurevelocity, dt))
    acceleration = CheckEnemyCollision(enemies,world, futureposition, acceleration)
    enemies[i].velocity = vector2.add(enemies[i].velocity, vector2.mult(acceleration, dt))
    enemies[i].velocity = vector2.limit(enemies[i].velocity, enemies[i].maxvelocity)
    enemies[i].position = vector2.add(enemies[i].position, vector2.mult(enemies[i].velocity,dt))
    enemies[i].velocity.y = 0


      if enemies[i].health < 1 then
        table.remove(enemies, i)
        break 
      end

    if enemies[i].etype == 1 then 
    
      local moveforce = vector2.mult(enemies[i].movedirection, 200)
      acceleration = vector2.applyForce(moveforce, enemies[i].mass, acceleration)
      enemies[i].velocity = vector2.add(enemies[i].velocity, vector2.mult(acceleration, dt))
      enemies[i].velocity = vector2.limit(enemies[i].velocity, 200)
      enemies[i].position = vector2.add(enemies[i].position, vector2.mult(enemies[i].velocity, dt))     -- Boar Movement 
      
                if enemies[i].velocity.x <= -1 then 
            BoarEnemyAnimationTimer = BoarEnemyAnimationTimer + dt
          if BoarEnemyAnimationTimer > 0.1 then
            BoarEnemyAnimationFrame = BoarEnemyAnimationFrame + 1 
            BoarEnemyAnimationTimer = 0
          if BoarEnemyAnimationFrame > 4 then
            BoarEnemyAnimationFrame = 1
      end
    end
  end
          if enemies[i].velocity.x >= 1 then
            BoarEnemyAnimationTimer = BoarEnemyAnimationTimer + dt
          if BoarEnemyAnimationTimer > 0.1 then
            BoarEnemyAnimationFrame = BoarEnemyAnimationFrame + 1 
            BoarEnemyAnimationTimer = 0
          if BoarEnemyAnimationFrame < 5 or BoarEnemyAnimationFrame > 8 then
            BoarEnemyAnimationFrame = 5
    end
  end
end
      
      --timer time
      
      enemies[i].movetimer = enemies[i].movetimer + dt
      
      if enemies[i].movetimer >= enemies[i].movechangetime then
        enemies[i].movetimer = 0 
        enemies[i].movedirection = vector2.mult(enemies[i].movedirection, -1)
      end
        
      elseif enemies[i].etype == 2 then
        
      local moveforce = vector2.mult(enemies[i].movedirection, 300)
        acceleration = vector2.applyForce(moveforce, enemies[i].mass, acceleration)
        enemies[i].velocity = vector2.add(enemies[i].velocity, vector2.mult(acceleration,dt))
        enemies[i].velocity = vector2.limit(enemies[i].velocity, 300)
        enemies[i].position = vector2.add(enemies[i].position, vector2.mult(enemies[i].velocity, dt))     -- Armadillo Movement

          if enemies[i].velocity.x >= 1 then 
            TatuEnemyAnimationTimer = TatuEnemyAnimationTimer + dt
          if TatuEnemyAnimationTimer > 0.09 then
            TatuEnemyAnimationFrame = TatuEnemyAnimationFrame + 1 
            TatuEnemyAnimationTimer = 0
          if TatuEnemyAnimationFrame > 4 then
            TatuEnemyAnimationFrame = 1
      end
    end
  end
          if enemies[i].velocity.x <= -1 then
            TatuEnemyAnimationTimer = TatuEnemyAnimationTimer + dt
          if TatuEnemyAnimationTimer > 0.09 then
            TatuEnemyAnimationFrame = TatuEnemyAnimationFrame + 1 
            TatuEnemyAnimationTimer = 0
          if TatuEnemyAnimationFrame < 5 or TatuEnemyAnimationFrame > 8 then
            TatuEnemyAnimationFrame = 5

    end
  end
end
        
      --timer time 
        
        enemies[i].movetimer = enemies[i].movetimer + dt
        if enemies[i].movetimer >= enemies[i].movechangetime then
          enemies[i].movetimer = 0 
          enemies[i].movedirection = vector2.mult(enemies[i].movedirection, -1)
        end
          
        elseif enemies[i].etype == 3 then
        local moveforce = vector2.mult(enemies[i].movedirection, 400)
          acceleration = vector2.applyForce(moveforce, enemies[i].mass, acceleration)
          enemies[i].velocity = vector2.add(enemies[i].velocity, vector2.mult(acceleration,dt))
          enemies[i].velocity = vector2.limit(enemies[i].velocity, 400)
          enemies[i].position = vector2.add(enemies[i].position, vector2.mult(enemies[i].velocity, dt))-- Bird Movement
          
          if enemies[i].velocity.x >= 1 then 
            BirdEnemyAnimationTimer = BirdEnemyAnimationTimer + dt
          if BirdEnemyAnimationTimer > 0.5 then
            BirdEnemyAnimationFrame = BirdEnemyAnimationFrame + 1 
            BirdEnemyAnimationTimer = 0
          if BirdEnemyAnimationFrame > 3 then
            BirdEnemyAnimationFrame = 1
      end
    end
  end
          if enemies[i].velocity.x <= -1 then
            BirdEnemyAnimationTimer = BirdEnemyAnimationTimer + dt
          if BirdEnemyAnimationTimer > 0.5 then
            BirdEnemyAnimationFrame = BirdEnemyAnimationFrame + 1 
            BirdEnemyAnimationTimer = 0
          if BirdEnemyAnimationFrame < 4 or BirdEnemyAnimationFrame > 6 then
            BirdEnemyAnimationFrame = 4

    end
  end
end

        --timer time
        enemies[i].movetimer = enemies[i].movetimer + dt
        if enemies[i].movetimer >= enemies[i].movechangetime then
          enemies[i].movetimer = 0 
          enemies[i].movedirection = vector2.mult(enemies[i].movedirection, -1)
        end
        
        if playerdistance < enemies[i].maxviewdistance and player.health > 0 then
          enemies[i].state = ATTACK
          enemies[i].velocity = vector2.new(0,0)
        end
      end
      if enemies[i].state == ATTACK then
        enemies[i].shoottimer = enemies[i].shoottimer + dt
        if enemies[i].shoottimer > enemies[i].shootrate then
          playerdirection = vector2.normalize(playerdirection)
          table.insert(enemies[i].projectiles, CreateProjectile(enemies[i].position.x + (enemies[i].size.x / 2), enemies[i].position.y + (enemies[i].size.y / 2           ), 100, playerdirection))  -- to make the bullet in the middle of the enemie
          enemies[i].shoottimer = 0
        end
      end
      
      if playerdistance > enemies[i].maxviewdistance or player.health <= 0 then
        enemies[i].state = PATROL
      end

   UpdateProjectiles(dt, enemies[i].projectiles, world, player)
  end
end


function CheckEnemyCollision(enemies,world,futureposition,acceleration)
  for i = 1, #enemies, 1 do
   for ii = 1, #world, 1 do 
        local collisiondirection = GetBoxCollisionDirection(futureposition.x, futureposition.y, enemies[i].size.x, enemies[i].size.y, world[ii].position.x, world[ii].position.y, world[ii].size.x, world[ii].size.y)
        
        if  (collisiondirection.x ~= 0 or collisiondirection.y ~= 0)  then
        
            enemies[i].velocity.y = 0 
            acceleration.y = 0 
            enemies[i].velocity.x = 0
            acceleration.x = 0 
        end

    end

    return acceleration

  end
end

function DrawEnemies(enemies)


  for i = 1, #enemies, 1 do
    if enemies[i].etype == 1 then 
      love.graphics.setColor(1,1,1)
      love.graphics.draw(BoarEnemyAnimation[BoarEnemyAnimationFrame], enemies[i].position.x, enemies[i].position.y , 0, 3, 3)
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill", enemies[i].position.x ,enemies[i].position.y - 30, enemies[i].health, 5)
   end
    if enemies[i].etype == 3 then 
      love.graphics.setColor(1,1,1)
      love.graphics.draw(BirdEnemyAnimation[BirdEnemyAnimationFrame], enemies[i].position.x, enemies[i].position.y , 0, 3, 3)
      DrawProjectile(enemies[i].projectiles)
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill", enemies[i].position.x ,enemies[i].position.y - 30, enemies[i].health, 5)
    end
    if enemies[i].etype == 2 then 
      love.graphics.setColor(1,1,1)
      love.graphics.draw(TatuEnemyAnimation[TatuEnemyAnimationFrame], enemies[i].position.x, enemies[i].position.y , 0, 2, 2)
      love.graphics.setColor(1, 0, 0)
      love.graphics.rectangle("fill", enemies[i].position.x ,enemies[i].position.y - 30, enemies[i].health, 5)
   end
    end
  end 
