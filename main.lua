vec = require 'vector'
vehicle = require 'vehicle'

function love.load()
    vehicles = {}
    local cx = love.graphics:getWidth() / 2
    local cy = love.graphics:getHeight() / 2
    local radius = 300
    local segment_count = 200
    local segment = (math.pi * 2) / segment_count
    for i=1, segment_count do
       local x = cx + math.cos(segment * i) * radius 
       local y = cy + math.sin(segment * i) * radius 
       table.insert(vehicles, Vehicle.new(x, y))
    end
end

function love.update(dt)
    love.window.setTitle('fps: ' .. love.timer.getFPS())
    for _, vehicle in pairs(vehicles) do
        vehicle:behaviour(love.mouse:getX(), love.mouse:getY())
        vehicle:update(dt)
    end
end

function love.draw()
    for _, vehicle in pairs(vehicles) do
        vehicle:draw()
    end
end

function love.keypressed(key, scancode, isrepeat)
    
    if key == 'h' then
        for _, v in pairs(vehicles) do v.target = v.home end
    end

    if key == 'r' then
        for i=1, #vehicles do
           vehicles[i].target = vec(math.random(love.graphics:getWidth()), math.random(love.graphics:getHeight()))
        end
    end

    if key == 'c' then
        local cx = love.graphics:getWidth() / 2
        local cy = love.graphics:getHeight() / 2
        local radius = math.random(50, 400)
        local segment_count = #vehicles
        local segment = (math.pi * 2) / segment_count
        for i=1, segment_count do
           local x = cx + math.cos(segment * i) * radius 
           local y = cy + math.sin(segment * i) * radius 
           vehicles[i].target = vec(x, y)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        for _, v in pairs(vehicles) do v.target = vec(x, y) end
    end
end
