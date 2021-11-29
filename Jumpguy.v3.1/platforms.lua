platforms = {}
platforms.__index = platforms
ActivePlatforms = {}


function platforms.new(x,y,width,height)
    local instance = setmetatable({}, platforms)
    instance.x = x
    instance.y = y
    instance.width = width
    instance.height = height
   
  
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    table.insert(ActivePlatforms, instance)
    
end


function platforms:drawAll()
    for i,instance in ipairs(ActivePlatforms) do 
        instance:draw()
        
    end
end

function platforms:draw()
    
    love.graphics.setColor(1,1,1)
    
    love.graphics.polygon("fill", self.physics.body:getWorldPoints(self.physics.shape:getPoints()))  
    
end