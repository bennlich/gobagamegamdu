Class = require('libs.hump.class')

Planet = Class{
	init = function(self, pos, opts)
		self.pos = pos
		self.active = false
		
		table.foreach(opts, function(k,v)
			self[k] = v
		end)
	end,
}

return Planet