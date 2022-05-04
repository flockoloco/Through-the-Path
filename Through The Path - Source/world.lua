require "vector2"

function CreateObject (x, y, w, h)
  return {position = vector2.new(x, y), size = vector2.new(w, h)}
end
  
function DrawWorld (world)

  for i = 1, #world, 1 do
    love.graphics.setColor (0,0,0)
    love.graphics.rectangle("line", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
  end
end