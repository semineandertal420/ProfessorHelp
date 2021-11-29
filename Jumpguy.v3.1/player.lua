Player = {}

function Player:load()
    self.x = 30
    self.y = 20
    self.width = 16
    self.heigth = 16
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 200
    self.acceleration = 1400
    self.friction = 1300
    self.gravity = 1500
    self.maxYSpeed = 500
    self.jumpForce = -450
    self.playerHP = 10

    self.playerDirection = 0

    self.hasRolled = false
    self.lastRoll = 0
    self.rollCD = 3
    self.rollForce = 500
    self.rollDuration = 1

    self.wasGrounded = false
    self.grounded = false

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.heigth)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function Player:move(dt)
    if love.keyboard.isDown("d") then
        self.playerDirection = 0
        if self.xVel < self.maxSpeed then
            if self.xVel + self.acceleration * dt < self.maxSpeed then
                self.xVel = self.xVel + (self.acceleration * dt)
            else
                self.xVel = self.maxSpeed
            end
        end 

    elseif love.keyboard.isDown("a") then
        self.playerDirection = 1
        if self.xVel > -self.maxSpeed then
            if self.xVel - self.acceleration * dt > -self.maxSpeed then
                self.xVel = self.xVel - (self.acceleration * dt)
            else
                self.xVel = -self.maxSpeed
            end
        end 

    else
        self:applyFriction(dt)
    end

end

function Player:applyFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0
        end

    end

end


function Player:applyGravity(dt)
    if self.grounded == false then
        self.yVel = self.yVel + (self.gravity * dt)
        if self.yVel >= self.maxYSpeed then
            self.yVel = self.maxYSpeed
        end
    end
end

function Player:syncPhysics()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
    self.x, self.y = self.physics.body:getPosition()

end

function Player:beginContact(a, b, collision)
    if self.grounded == true then return end

    local nx, ny = collision:getNormal()
    for i,instance in ipairs(ActivePlatforms) do  
        if ( a == self.physics.fixture and b == instance.physics.fixture and ny > 0 ) or (b == self.physics.fixture and a == instance.physics.fixture and ny < 0 ) then
            
                self:land()
            
        elseif (a == self.physics.fixture and b == instance.physics.fixture and ny < 0) or (b == self.physics.fixture and a == instance.physics.fixture and ny > 0 ) then
            
                self.yVel = 0
            
        end
    end
  
    
end



function Player:endContact(a, b, collision)
    if self.grounded == false then return end

    local nx, ny = collision:getNormal()
    for i,instance in ipairs(ActivePlatforms) do 
    if a == self.physics.fixture and b == instance.physics.fixture then
        if ny < 0 then
            self.grounded = false
           
        end
    end
    if b == self.physics.fixture and a == instance.physics.fixture then
        if ny > 0 then          
            self.grounded = false
        end
    end
end
end

function Player:land()
    self.yVel = 0
    self.grounded = true
    
end

function Player:jump(key)
    if (key == "w") and self.grounded == true then
        self.yVel = self.jumpForce
        self.grounded = false
        
        Player:damage()
    end

end
--[[ -------------------------------------- THIS IS ME TRYING TO FIX --------------------------------------------------------
function Player:runSpeed()
    local duration = 1
    local begin = 0
    if self.hasRolled == true then
        io.write(tostring(self.hasRolled))
        if ((os.time() - begin) > duration) and self.xVel > self.maxSpeed then
            self.xVel = self.maxSpeed
            self.hasRolled = false
        end
        if ((os.time() - begin) > duration) and self.xVel < -self.maxSpeed then
            self.xVel = -self.maxSpeed
            self.hasRolled = false
            io.write(tostring(self.hasRolled))
        end
        begin = os.time()
    end
end
]]

function Player:roll(key)
    local lastTime = 0
    if (key == "c") and self.grounded == true then
        if ((os.time() - self.lastRoll) > self.rollCD) then
            if self.playerDirection == 0 then
                self.hasRolled = true
                self.xVel = self.rollForce
            elseif self.playerDirection == 1 then
                self.hasRolled = true
                self.xVel = -self.rollForce
                lastTime = os.time()     
            end
            self.lastRoll = os.time()
        end
    else
        self.hasRolled = false
    end
end

function Player:damage()
    self.playerHP = self.playerHP - 1
end

function Player:kills()
    self.yVel = self.jumpForce
    self.playerHP = self.playerHP +1
end


function Player:dead()
    if self.playerHP < 0 or love.keyboard.isDown("r") or self.physics.body:getPosition() >= love.graphics.getHeight() then
        love.event.quit("restart")
    end
end




function Player:update(dt)
    Player:move(dt)
    Player:applyGravity(dt)
    Player:syncPhysics()
    Player:dead()
    --Player:runSpeed()
    
end

function Player:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("fill", self.x - self.width /2, self.y - self.heigth/2, self.width, self.heigth)
    love.graphics.print(self.playerHP, self.x - 4, self.y - 32)





    love.graphics.print(tostring(self.hasRolled),10,20)
    love.graphics.print(tostring(self.xVel), 50, 110)

end