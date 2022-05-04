require "vector2"
require "world"
require "player"
require "collision"
require "enemies"
require "conf"
require "plants"
require "tiledmap"

local level1 = {}
local enemies = {}
local plants = {} 

gamestate = "menu" 
menuimage = love.graphics.newImage("menu.png")
keysimage = love.graphics.newImage("keys.png")
pauseimage = love.graphics.newImage("pause.png")
escbutton = love.graphics.newImage("botao.png") 

function love.load()
  LoadEnemy()
  LoadPlayer()
 
 Song = love.audio.newSource("Music.mp3", "stream")
  
  _G.map = loadTiledMap("map") --Put the file that you exported from Tiled
  -- Fullscreen 
   love.window.setFullscreen(true, "desktop")
   
   --platform
  level1[1] = CreateObject(4225, 962, 1535, 125)
  level1[2] = CreateObject(4224.33, 961.667, 1536, 126.333)
  level1[3] = CreateObject(3712.33, 1025.67, 511.667, 62.3333)
  level1[4] = CreateObject(3264.33, 961.667, 447.333, 126.333)
  level1[5] = CreateObject(2880.33, 898, 383.667, 190)
  level1[6] = CreateObject(0.333333, 962, 2880, 126)
  level1[7] = CreateObject(1600, 898, 319.333, 63.6667)
  level1[8] = CreateObject(1664, 834, 191.667, 64)
  level1[9] = CreateObject(2944.5, 834, 254.5, 64)
  level1[10] = CreateObject(3008.5, 770, 126.5, 64)
  level1[11] = CreateObject(0, 1, 5760, 190)
  level1[12] = CreateObject(4505.33, 290.667, 166, 29.3333)
  level1[13] = CreateObject(4496.67, 547.333, 110.667, 28)
  level1[14] = CreateObject(4241.33, 358.667, 110, 25.3333)
  level1[15] = CreateObject(4445.33, 739.333, 163.333, 28)
  level1[16] = CreateObject(4160, 611.333, 111.333, 27.3333)
  level1[17] = CreateObject(3904, 484.667, 110.667, 26)
  level1[18] = CreateObject(3790, 738.667, 114, 28.6667)
  level1[19] = CreateObject(3663.33, 484.667, 111.333, 27.3333)
  level1[20] = CreateObject(3484, 548, 163.333, 27.3333)
  level1[21] = CreateObject(3328, 612.667, 162, 26)
  level1[22] = CreateObject(3200, 676, 108.667, 27.3333)
  level1[23] = CreateObject(3135.33, 290.667, 162.667, 30)
  level1[24] = CreateObject(2943.33, 546, 164.667, 28.6667)
  level1[25] = CreateObject(2768.67, 610.667, 111.333, 28.6667)
  level1[26] = CreateObject(2639.33, 676, 112.667, 28.6667)
  level1[27] = CreateObject(2460.67, 739.333, 164, 28.6667)
  level1[28] = CreateObject(2240, 674.667, 161.333, 28.6667)
  level1[29] = CreateObject(2624.67, 357.333, 110.667, 25.3333)
  level1[30] = CreateObject(2065.33, 740, 110.667, 28)
  level1[31] = CreateObject(1920.67, 358, 110.667, 24)
  level1[32] = CreateObject(1791.33, 612.667, 164.667, 26.6667)
  level1[33] = CreateObject(1664, 677.333, 108.667, 26)
  level1[34] = CreateObject(1488, 356, 111.333, 26.6667)
  level1[35] = CreateObject(1490, 740.667, 108.667, 26)
  level1[36] = CreateObject(1245.33, 673.333, 162, 30.6667)
  level1[37] = CreateObject(1151.33, 614.667, 107.333, 24)
  level1[38] = CreateObject(1152.67, 420.667, 164.667, 26)
  level1[39] = CreateObject(1087.33, 290.667, 163.333, 27.3333)

  --enemies
    
  enemies[1] = CreateEnemy(2150, 350, 3)
  enemies[2] = CreateEnemy(2250, 900, 1)
  enemies[3] = CreateEnemy(700, 920, 2)
  enemies[4] = CreateEnemy(1900,250,3)
  enemies[5] = CreateEnemy(3800,960,1)
  enemies[6] = CreateEnemy(4500,900, 1)
  enemies[7] = CreateEnemy(5000,900, 1)
  enemies[8] = CreateEnemy(5000,700,3)
 
 --plants 
  
  plants[1] = CreatePlant(2250,920)
  plants[2] = CreatePlant(4400,920)
end 

 
  
function love.update(dt)
  
love.audio.play(Song)
  
  --makes main menu
  if gamestate == "menu" then 
    if love.keyboard.isDown("space","p") then 
    gamestate = "play" 
    elseif love.keyboard.isDown("escape") then
      love.event.quit()
    elseif love.keyboard.isDown("i") then 
    gamestate = "keys"
    end

 -- game
  elseif gamestate == "play" then
  UpdatePlayer(dt, level1, enemies)
  UpdatePlant(plants,GetPlayer())
  UpdateEnemies(dt,enemies,level1,GetPlayer())
 end

 if gamestate == "play" then 
   if love.keyboard.isDown("escape") then 
     gamestate = "pausemenu"
    end
  end  

-- pause menu 
  if gamestate == "pausemenu" then 
    if love.keyboard.isDown("space") then 
      gamestate = "play"
    end
      if love.keyboard.isDown("r") then
      love.event.quit("restart")
      end
        if love.keyboard.isDown("q") then 
          love.event.quit() 
          end
  end

  if gamestate == "keys" then 
    if love.keyboard.isDown("b") then 
    gamestate = "menu"
    end
  end
end

function love.draw()
 
  --draws menu
  if gamestate == "menu" then 
    love.graphics.draw(menuimage)
  end
  
  --draws keys inst
  if gamestate == "keys" then 
    love.graphics.draw(keysimage)
  end
  
  if gamestate =="pausemenu" then 
    love.graphics.draw(pauseimage,0,0,0,4,4)
  end 
  
  -- draws game 
  if gamestate== "play" then 
  

  local playerposition = GetPlayerPosition()
  local player = GetPlayer()
  
  if playerposition.x >= 8500 then
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("YOU WON GG", love.graphics.getWidth()/2 , love.graphics.getHeight()/2 )
    return
  end
  
  if playerposition.x <= 380 then 
    playerposition.x = 380
    end
  
  if playerposition.x >= 5200 then 
    player.position.x = 5200 
    love.event.quit()
    end
  
  if player.lifes <= 0 then
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("YOU LOST GG", love.graphics.getWidth()/2 , love.graphics.getHeight()/2 )
    love.event.quit(restart)
    return
  end
 
  love.graphics.setBackgroundColor(0, 1, 1)

  love.graphics.setColor(0,0,0)
  love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 120) 

  love.graphics.translate(-(playerposition.x - 380), 0)
  
  love.graphics.setColor(1,1,1)
  _G.map:draw() --Draws the Map that you loaded
  
  DrawEnemies(enemies)
    DrawPlants(plants)
  love.graphics.translate((playerposition.x - 380), 0)
  
  DrawPlayer()


  
  love.graphics.setColor(1,1,1)
  love.graphics.draw(escbutton,1375,-355,0,3,3)
  end
end