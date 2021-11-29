require("player")
require("apprentice")
require("platforms")
--[[ require("ApprenticeAttack") ]]

function love.load()
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(beginContact, endContact)

    platforms.new(0,360,1280,20)
    platforms.new(150,300,100,10)
    platforms.new(300,250,100,10)
    platforms.new(450,200,100,10)

    Apprentice.new(311,236)
    Apprentice.new(472,186)

    Player:load()

end


function love.update(dt)
    World:update(dt)

    Player:update(dt)

    Apprentice:updateAll(dt) 

  --[[   ApprenticeAttack:updateAll(dt) ]]
end

function beginContact(a, b, collision)
    if  Apprentice.beginContact(a, b, collision) then return end 
    --[[ if ApprenticeAttack.beginContact(a,b, collision) then return end  ]]
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
   
end

function love.keypressed(key)
    Player:jump(key)
    Player:roll(key)
end


function love.draw()
    love.graphics.push()
    love.graphics.scale(2, 2)

    Player:draw()
    Apprentice:drawAll()
    platforms:drawAll()
  --[[   ApprenticeAttack:drawAll() ]]
    
    

    love.graphics.pop()

end