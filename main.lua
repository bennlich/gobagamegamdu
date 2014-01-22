inspect = require('libs.inspect')
vector = require('libs.hump.vector')

Planet = require('Planet')
require('input')

width, height = love.graphics.getDimensions()

ship = {
	pos = vector(width/2, height/2),
	vel = vector(0, 0),
	acceleration = 1,
	angle = 0,
	speed = 100
}

planets = {}
for i=1,8 do
	planets[i] = Planet(
		vector(math.random(0, width), math.random(0, height)),
		{ active = false }
	)
end

function updateShip(dt)
	
	local delta = vector(0,0)
	table.foreach(planets, function(k, planet)
		if planet.active then
			local towardPlanet = planet.pos - ship.pos
			towardPlanet:normalize_inplace()

			local dist2 = ship.pos:dist2(planet.pos)
		    
		    delta = delta + (1000000 * towardPlanet / dist2)
		end
	end)

	-- if (delta:len() > 0.05) then
	-- 	delta:normalize_inplace()
	-- 	ship.vel = delta * ship.speed
	-- 	ship.pos = ship.pos + ship.vel * dt
	-- end
	-- end
	
	ship.vel = ship.vel + delta * ship.acceleration * dt
	ship.angle = ship.vel:angleTo(vector(1,0))

	ship.pos = ship.pos + ship.vel * dt

	-- print(inspect(ship))
    -- if ship.velocity:len() > ship.max_velocity then
    --     ship.velocity = ship.velocity:normalized() * ship.max_velocity
    -- end

end

function love.load()
end

function love.update(dt)
	-- mouse_x = love.mouse.getX()
	-- mouse_y = love.mouse.getY()
	updateShip(dt)
end

function love.draw()
	local keymap = { 'a', 's', 'd', 'f', 'h', 'j', 'k', 'l' }
	love.graphics.reset()
	love.graphics.rectangle('fill', ship.pos.x-5, ship.pos.y-5, 10, 10)
	table.foreach(planets, function(k, planet)
		love.graphics.circle('line', planet.pos.x, planet.pos.y, 10, 100)
		love.graphics.print(keymap[k], planet.pos.x-5, planet.pos.y-5)
	end)
end