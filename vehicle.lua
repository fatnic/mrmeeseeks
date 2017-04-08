Vehicle = {}
Vehicle.__index = Vehicle

function map(n, start1, stop1, start2, stop2)
    return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2;
end

function Vehicle.new(x, y)
    local self = setmetatable({}, Vehicle)
    self.pos      = vec(math.random( love.graphics:getWidth()), math.random(love.graphics:getHeight()))
    self.home     = vec(math.random( love.graphics:getWidth()), math.random(love.graphics:getHeight()))
    self.target   = vec(x, y)
    self.vel      = vec()
    self.acc      = vec()
    self.rad      = math.random(6,20)
    self.alpha    = math.random(50, 200)
    self.maxspeed = math.random(4, 10)
    self.maxforce = math.random(5, 10) / 10
    return self
end

function Vehicle:update(dt)
    self.pos = self.pos + self.vel
    self.vel = self.vel + self.acc
    self.acc = vec()
end

function Vehicle:behaviour(mx, my)
    local arrive = self:arrive(self.target)
    self:applyForce(arrive)

    local mouse = vec(mx, my)
    if self.pos:dist(mouse) < 100 then
        local flee = self:flee(mouse)
        self:applyForce(flee * 1.5)
    end
end

function Vehicle:applyForce(f)
    self.acc = self.acc + f
end

function Vehicle:draw()
    love.graphics.setColor(135, 206, 235, self.alpha)
    love.graphics.circle('fill', self.pos.x, self.pos.y, self.rad)
end

-- behaviours

function Vehicle:arrive(target)
    local desired = target - self.pos
    local distance = target:dist(self.pos)
    local speed = self.maxspeed
    if distance < 50 then speed = map(distance, 0, 100, 0, self.maxspeed) end
    desired = desired:normalized() * speed
    local steer = desired - self.vel
    return steer:trimmed(self.maxforce)
end

function Vehicle:seek(target)
    local desired = target - self.pos
    desired = desired:normalized() * self.maxspeed
    local steer = desired - self.vel
    return steer:trimmed(self.maxforce)
end

function Vehicle:flee(target)
    local desired = target - self.pos
    desired = desired:normalized() * self.maxspeed
    desired = desired * -1
    local steer = desired - self.vel
    return steer:trimmed(self.maxforce)
end

return Vehicle
