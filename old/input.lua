local keymap = {
	a = 1,
	s = 2,
	d = 3,
	f = 4,
	h = 5,
	j = 6,
	k = 7,
	l = 8
}

function love.keypressed( key )
	if keymap[key] then
		planets[keymap[key]].active = not planets[keymap[key]].active
	end
end