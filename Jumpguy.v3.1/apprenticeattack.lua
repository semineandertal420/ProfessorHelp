
ApprenticeAttack = {}
ApprenticeAttack.__index = ApprenticeAttack
ActiveApprenticeAttack = {}

function ApprenticeAttack.new(x,y)
    local instance = setmetatable({}, ApprenticeAttack)
    instance.x = x
    instance.y = y
    instance.width = 5
    instance.heigth = 2
   


    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.heigth)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    table.insert(ActiveApprenticeAttack, instance)

    
    
end 

function ApprenticeAttack:updateAll(dt)
    for i,instance in ipairs(ActiveApprenticeAttack) do 
        instance:update(dt) 

    end
end

--[[ function ApprenticeAttack:DetectPlayer() -- when it detects the player it creates a attack
    for i,instance in ipairs(AliveApprentice) do 
        if (Player.x < instance.x and Player.x > instance.x-145 ) and (Player.y < instance.y+10 and Player.y> instance.y -25) then
        io.write("inside attack area\n")
        ApprenticeAttack.new(instance.x,instance.y)
        io.write(tostring(instance.x))
        io.write(tostring(instance.y))
        
         
        end

    end
end ]]

function ApprenticeAttack.beginContact(a,b, collision)  -- after the creation of the bullet 
    for i,instance in ipairs(ActiveApprenticeAttack) do 
    if (a == instance.physics.fixture and b == Player.physics.fixture ) or (a == Player.physics.fixture and b == instance.physics.fixture ) then
        table.remove(ActiveApprenticeAttack, i)
        instance.physics.body:destroy()
        Player:damage()
    end

end


function ApprenticeAttack:update(dt)  -- updates the detection of the player and it moves the bullets
    ApprenticeAttack:destroy()
    ApprenticeAttack:move(dt)
     
end

function ApprenticeAttack:destroy() -- when it touches the player or leaves screen it gets destroyed
    for i,instance in ipairs(ActiveApprenticeAttack) do 
        if instance.x < 0 then
        table.remove(ActiveApprenticeAttack, i)
        instance.physics.body:destroy()
        end
        

    end 

end

function ApprenticeAttack:move(dt) --~the active atacks move to the left 
    for i,instance in ipairs(ActiveApprenticeAttack) do 
        instance.X = instance.x - 10 *dt
         
        end

    end
end

function ApprenticeAttack:drawAll() -- the active actacks apper
    for i,instance in ipairs(ActiveApprenticeAttack) do 
        instance:draw()

    end
end

function ApprenticeAttack:draw() -- as the player enter the 
    love.graphics.setColor(0.941, 0.4, 1)
    love.graphics.rectangle("fill", self.x, self.y ,self.width, self.heigth)
     io.write(tostring(#ActiveApprenticeAttack)) 
end