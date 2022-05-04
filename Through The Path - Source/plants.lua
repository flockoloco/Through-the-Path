
require "vector2" 

local planta = love.graphics.newImage("Plant.png")

function CreatePlant (x,y)
  
  return { position = vector2.new(x,y),
          radius = 10,
          hp = 10 
          }
  end 
  
function UpdatePlant(plants,player) 
  for i = 1 , #plants, 1 do   
    if plants[i] and player.health ~= 100 then 
      
      if player.position.x > plants[i].position.x -(plants[i].radius*2) and player.position.x < plants[i].position.x + (plants[i].radius*2) and                     player.position.y + player.size.y > plants[i].position.y - (plants[i].radius*2) and player.position.y + player.size.y > plants[i].position.y
                      +(plants[i].radius*2) then 
        
        player.health = player.health + plants[i].hp
        table.remove(plants,i)
      end
    end
  end 
end
 
function DrawPlants(plants) 
  love.graphics.setColor(0.039, 0.760, 0.129) 
      
  for i = 1 , #plants, 1 do 
    love.graphics.setColor(1,1,1)
    love.graphics.draw(planta ,plants[i].position.x , plants[i].position.y, 0, 1.5,1.5)
  end 
end