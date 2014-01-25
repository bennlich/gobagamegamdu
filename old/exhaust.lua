function loadExhaust(  )
  exhaust_image = love.graphics.newImage('exhaust.png')
  exhaustSystem = love.graphics.newParticleSystem(exhaust_image, 100)
  exhaustSystem:setDirection(math.pi)
  exhaustSystem:setEmissionRate(50)
  exhaustSystem:setEmitterLifetime(-1)
  exhaustSystem:setParticleLifetime(0.25, 0.5)
  exhaustSystem:setSpeed(10, 100)
  exhaustSystem:setSpread(2*math.pi/3)
  exhaustSystem:setColors(
    {159, 3, 3, 128},
    {245, 166, 35, 128} 
  )
  exhaustSystem:start()
  return exhaustSystem
end

function updateExhaust(ship, dt)
  exhaustSystem:setPosition(ship.pos.x, ship.pos.y)
  exhaustSystem:setDirection(math.pi-ship.angle)
  exhaustSystem:setRotation(math.pi-ship.angle-0.1, math.pi-ship.angle+0.1)
  exhaustSystem:update(dt)
end

function drawExhaust()
  love.graphics.draw(exhaustSystem, 0, 0)
end