--require( "mobdebug" ).start()
local debugWorldDraw = require("debugWorldDraw")
local camera = require("camera")
--local gui = require( "Gspot" )
local world
local objects
local cam = camera( 1280, 720, { x = 0, y = 0, resizable = true, maintainAspectRatio = true } )
local layerDebug = cam:addLayer('debug', 1)
local layerMain = cam:addLayer('main', 1, {relativeScale = 1})
--love.graphics = require( "autobatch" )
local ground1 = love.graphics.newImage("ground1.png")
local ground2 = love.graphics.newImage("ground2.png")



local spriteSize = 32
local chunkSize = 3
local mapSize = 20
local chunks = {}
local renderDistance = 22
local currentBlock = 0

local objf = {}

local playerSquare = {}
local mouseSquare = {}

local drawMenu = 0
local showDebug = true
local showMenu = false

local menuSize = { w = 5, h = 7 }
local menuItems = {}
local map = {}
            
local Cell = {}
Cell.__index = Cell

local object = {}
object.__index = object
  

local home ={ {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            }
            
local obj ={  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
              {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
            }


function love.load()
  love.window.setMode(1280, 720, {resizable=true, vsync=false, minwidth=400, minheight=300})

  love.physics.setMeter(64) 
  world = love.physics.newWorld(0, 9.81 * 64, true) 

  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  
   
  --table.insert(chunks, CreateChunk(1, 1,19))
  map = CreateChunk(1, 1,19)

  objects = {} 
 

  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 200, 200, "dynamic") 
  objects.ball.shape = love.physics.newCircleShape( 20)
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
  objects.ball.fixture:setRestitution(0.0) 
  objects.ball.body:setLinearDamping( 5 )
  objects.ball.body:setGravityScale ( 0 )
  

  

 

  love.graphics.setBackgroundColor(104, 136, 248) 
end
 
function love.update(dt)
  world:update(dt) 
 
  playerSquare.x, playerSquare.y = math.ceil(objects.ball.body:getX() / spriteSize ), math.ceil(objects.ball.body:getY() / spriteSize)
  mouseSquare.x, mouseSquare.y = cam:toWorldCoordinates( love.mouse.getX(), love.mouse.getY() )
  mouseSquare.x, mouseSquare.y = math.ceil(mouseSquare.x / spriteSize), math.ceil(mouseSquare.y / spriteSize)
 
   for i, v in ipairs(objf) do
    v.fixture:destroy()
    v.body:destroy()
  end
  objf = {}
  
  if love.keyboard.isDown("right") then 
    objects.ball.body:applyForce(400, 0)
  elseif love.keyboard.isDown("left") then
    objects.ball.body:applyForce(-400, 0)
  end
  
  if love.mouse.isDown(1) then
    map[math.abs(( mouseSquare.y - 1 ) % mapSize * mapSize + mapSize - (mapSize - mouseSquare.x) % mapSize)] = Cell.new(currentBlock,mouseSquare.x, mouseSquare.y)
  end
  
  if love.keyboard.isDown("up") then 
    objects.ball.body:applyForce(0, -400)
  elseif love.keyboard.isDown("down") then 
    objects.ball.body:applyForce(0, 400)
  end
  
  
  
  
  cam:update(dt)
end
 
function love.draw()
  cam:push()
    
    
    cam:push('main')

      for i = playerSquare.x - renderDistance, playerSquare.x + renderDistance do
        for j = playerSquare.y - renderDistance, playerSquare.y + renderDistance do
          --map[(j - 1) * mapSize + i]:draw(i * spriteSize, j * spriteSize)
          --map[((mapSize * mapSize) + math.abs(((j - 1) * mapSize + i))) % (mapSize * mapSize)]:draw(i * spriteSize, j * spriteSize)
          map[math.abs(( j - 1 ) % mapSize * mapSize + mapSize - (mapSize - i) % mapSize)]:draw(i * spriteSize, j * spriteSize)
        end
      end

      love.graphics.setColor(255, 255, 0) 
      love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
     
      if drawMenu == 1 then
        local x, y = cam:toWorldCoordinates(0, 0)
        love.graphics.setColor(255,255,255,255)
        love.graphics.rectangle("fill", x,y, 1280, 100) 
        
        love.graphics.draw(ground1, x+10+spriteSize, y+10 + spriteSize, 0,1,1,spriteSize,spriteSize)
        love.graphics.draw(ground2, x+2*10+2*spriteSize, y+10+spriteSize, 0,1,1,spriteSize,spriteSize)
      end
        
    cam:pop('main')
    
    cam:push('debug')
      debugWorldDraw(world,objects.ball.body:getX() - 200, objects.ball.body:getY() - 200 ,objects.ball.body:getX() + 200, objects.ball.body:getY() + 200)
    cam:pop('debug')

    
  cam:pop()
  
  cam:setTranslation(objects.ball.body:getX(), objects.ball.body:getY())
  
  if (showDebug == true) then
    local stats = love.graphics.getStats()
    love.graphics.setColor(0, 0, 0, 255 * .75)
    love.graphics.rectangle("fill", 5, 5, 300, 500, 2)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(love.timer.getFPS() .. "fps", 10, 10)
    love.graphics.print("drawcalls: " .. stats.drawcalls, 10, 30)
    love.graphics.print(playerSquare.x .. " " .. playerSquare.y, 10, 50)
    love.graphics.print("MouseSquare: " .. mouseSquare.x .. " " .. mouseSquare.y, 10, 70)
  end

  
end

function love.mousepressed(x, y, button, istouch)
  if button == 2 then
    if drawMenu == 0 then
      drawMenu = 1
    else
      drawMenu = 0
    end
  end
  
  if (button == 1) then
    if (drawMenu == 1) then
    
      if (inside(love.mouse.getX(), love.mouse.getY(), 10,10, spriteSize, spriteSize) == true) then
        currentBlock = 1
      end
      
      if (inside(love.mouse.getX(), love.mouse.getY(), 52,10, spriteSize, spriteSize) == true) then
        currentBlock = 0
      end
    end
  end
end

function love.keypressed( key, unicode )
  if (key == "`") then
    if (showDebug == false) then
      showDebug = true
    else
      showDebug = false
    end
  end
end


function Cell.new(typ, posx, posy )
  local self = setmetatable({}, Cell)
  local w, h = love.graphics.getDimensions()
  self.x, self.y = posx, posy
  self.typ = typ
  
  return self
end


function Cell:draw(x,y)
  love.graphics.setColor(255, 255, 0) 
  if (self.typ == 1) then
    love.graphics.draw(ground1, x, y, 0, 1, 1, spriteSize, spriteSize)
  elseif (self.typ == 0) then
    love.graphics.draw(ground2, x, y, 0, 1, 1, spriteSize, spriteSize)
  end
    
end

function CreateChunk(startX, startY, dist)
  local chunk = {}
  for i = startY, startY + dist do
    for j = startX, startX + dist do
      table.insert(chunk, Cell.new(home[i][j],j * spriteSize, i * spriteSize))
    end
  end
  return chunk
end


  
function object.new(typ, posx, posy )
  local self = setmetatable({}, object)
  local w, h = love.graphics.getDimensions()
  self.x, self.y = posx, posy
  self.typ = typ
  
  return self
end

function object:draw(x,y)
  love.graphics.setColor(255, 255, 0) 
  if (self.typ == 1) then
    love.graphics.draw(ground1, x, y, 0, 1, 1, spriteSize / 2, spriteSize / 2)
  elseif (self.typ == 0) then
    love.graphics.draw(ground2, x, y, 0, 1, 1, spriteSize / 2, spriteSize / 2)
  end
    
end

function Cell:remove(num)
  love.graphics.setColor(255, 255, 0) 
  if (self.typ == 1) then
    love.graphics.draw(ground1, x, y, 0, 1, 1, spriteSize / 2, spriteSize / 2)
  elseif (self.typ == 0) then
    love.graphics.draw(ground2, x, y, 0, 1, 1, spriteSize / 2, spriteSize / 2)
  end
    
end

function inside(mx, my, x, y, w, h)
    return mx >= x and mx <= (x+w) and my >= y and my <= (y+h)
end


