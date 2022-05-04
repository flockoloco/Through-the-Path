require "vector2"
require "collision"

function CreateProjectile(x,y,r,dir) -- r = radius, dir = direction

  return{position = vector2.new(x,y),
         velocity = vector2.mult(dir,450),
         radius = 10
        }
end

function UpdateProjectiles(dt, projectiles, world, player)

  for i = 1, #projectiles, 1 do
    
    for ii = 1, #world, 1 do
      
      if projectiles[i] then
      
      local collisiondirection = GetBoxCollisionDirection(projectiles[i].position.x, projectiles[i].position.y, projectiles[i].radius * 2, projectiles[i].radius        * 2, world[ii].position.x, world[ii].position.y, world[ii].size.x, world[ii].size.y)

        if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
        table.remove(projectiles, i)
        end
      end
    end
      
    if projectiles[i] then
      
      local collisiondirection = GetBoxCollisionDirection(projectiles[i].position.x, projectiles[i].position.y, projectiles[i].radius * 2, projectiles[i].radius        *2, player.position.x, player.position.y, player.size.x, player.size.y)
    
      if collisiondirection.x ~= 0 or collisiondirection.y ~= 0 then
        table.remove(projectiles, i)
        player.health = player.health - 20
      end
    end
    
    if projectiles[i] then
      projectiles[i].position = vector2.add(projectiles[i].position, vector2.mult(projectiles[i].velocity, dt)) -- projectile movement
    end
  end
end

function DrawProjectile(projectiles)

  love.graphics.setColor(1,1,1)

  for i = 1, #projectiles, 1 do
    love.graphics.circle("fill", projectiles[i].position.x, projectiles[i].position.y, projectiles[i].radius,40)
  end
end
