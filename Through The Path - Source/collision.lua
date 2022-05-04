require "vector2"

function GetBoxCollisionDirection (x1, y1, w1, h1, x2, y2, w2, h2)
  --math.abs returns only positive values
    
  local xdist = math.abs((x1 + (w1/2)) - (x2 + (w2/2)))
  local ydist = math.abs((y1 + (h1/2)) - (y2 + (h2/2)))
  local combinedwidth = (w1/2) + (w2/2)
  local combinedheight = (h1/2) + (h2/2)
    
  --if xdist is bigger then combinedwidth then no collision is happening
      
    if xdist > combinedwidth then
      
      return vector2.new (0,0)
    end
      
  --if ydist is bigger then combinedheight then no collision is happening
      
    if ydist > combinedheight then
      
      return vector2.new (0,0)
    end
      
  --calculate the direction of the collision
      
  local overlapx = math.abs (xdist - combinedwidth)
  local overlapy = math.abs (ydist - combinedheight)
  local direction = vector2.normalize(vector2.sub(vector2.new(x1,y1), vector2.new(x2,y2)))
  local collisiondirection
      
    if overlapx > overlapy then
      
      collisiondirection = vector2.normalize(vector2.new(0, direction.y * overlapy))
      
    elseif overlapx < overlapy then
      
      collisiondirection = vector2.normalize(vector2.new(direction.x * overlapx,0 ))
      
    else
    
      collisiondirection = vector2.normalize(vector2.new(direction.x * overlapx, direction.y * overlapy))
      
    end
    
    return collisiondirection

end