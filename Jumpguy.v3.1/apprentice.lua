Apprentice = {}
Apprentice.__index = Apprentice
AliveApprentice = {}

function Apprentice.new(x,y)
    local instance = setmetatable({}, Apprentice)
    instance.x = x
    instance.y = y
    instance.width = 16
    instance.heigth = 30
   
  
    instance.ApprenticeHP = 1

    instance.toBeRemoved = false



    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.heigth)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setUserData("Enemy")   
    --[[ instance.physics.fixture:setSensor(true) ]]
    table.insert(AliveApprentice, instance)


end 


function Apprentice:update(dt)
   --[[ Apprentice:DetectPlayer()  ]]
    --[[ Apprentice:checkRemove() ]]  
   
end

function Apprentice:updateAll(dt)
    for i,instance in ipairs(AliveApprentice) do 
        instance:update()
        -- [[alaways on  ]]
    
    end
end

function Apprentice:drawAll()
    for i,instance in ipairs(AliveApprentice) do 
        instance:draw()
        
    end
end


function Apprentice.beginContact(a, b, collision)
local nx, ny = collision:getNormal()
ny = math.abs(ny)
nx = math.abs(nx)
for i,instance in ipairs(AliveApprentice) do 
    if (a == instance.physics.fixture and b == Player.physics.fixture ) or (a == Player.physics.fixture and b == instance.physics.fixture ) then
        if ny > nx then
            io.write("Apprentice dead 1")
            table.remove(AliveApprentice, i)
            instance.physics.body:destroy()
            Player:kills()
        end
        if nx > ny then
            io.write("Player hurt\n")
            Player:damage()
        end
    end

end


end

function Apprentice.endContact(a, b, collision)
 
end


function Apprentice:draw()
    love.graphics.setColor(1,0,0)
    love.graphics.print("R_Enemy", self.x - 30, self.y - 32)  --label the enemy 
    --[[ love.graphics.rectangle("fill", self.x - self.width /2, self.y - self.heigth/2, self.width, self.heigth) ]]  -- draw the rePd rectangle ~
   --[[  love.graphics.rectangle("line", self.x-145, self.y -25 , 150 , 50) ]]
    love.graphics.polygon("fill", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))  
end

--[[  function Apprentice:DetectPlayer()
    for i,instance in ipairs(AliveApprentice) do 
        if (Player.x < instance.x and Player.x > instance.x-145 ) and (Player.y < instance.y+10 and Player.y> instance.y -25) then
        io.write("inside attack area\n")
        ApprenticeAttack.new(instance.x,instance.y)

        
        --[[ io.write(tostring(instance.x))
        io.write(tostring(instance.y)) 
        
         
        end

    end
end  ]]  