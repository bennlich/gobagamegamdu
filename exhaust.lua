function loadExhaust(  )
  exhaust_image = love.graphics.newImage('exhaust.png')
  exhaustSystem = love.graphics.newParticleSystem(exhaust_image, 100)
  exhaustSystem:setDirection(math.pi)
  exhaustSystem:setEmissionRate(20)
  exhaustSystem:setEmitterLifetime(-1)
  exhaustSystem:setParticleLifetime(0.25, 0.5)
  exhaustSystem:setSpeed(10, 50)
  exhaustSystem:setSpread(1)
  exhaustSystem:setColors(
    {159, 3, 3, 128},
    {245, 166, 35, 128} 
  )
  exhaustSystem:start()
  return exhaustSystem
end

function updateExhaust(ship, dt)
  exhaustSystem:setPosition(ship.pos.x, ship.pos.y)
  exhaustSystem:update(dt)
end

function drawExhaust(  )
  love.graphics.draw(exhaustSystem, 0, 0)
end