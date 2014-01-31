Class = require("libs.hump.class")

Loadable = Class{
  init = function(self, opts)
    if not opts then opts={} end
    for k,v in pairs(self.defaults) do
      -- Tries to load the number-versioned of parameters,
      -- then the unnumbered version, and then the defaults
      self[k] = (opts[world_vers] and opts[world_vers][k]) 
        or opts[k] 
        or self.defaults[k]
    end
    -- Lets you pass in either a vector or a pair of numbers
    if self.pos then
      if not vector.isvector(self.pos) then 
        if self.pos.x and self.pos.y then
          self.pos = vector(self.pos.x, self.pos.y)
        elseif unpack(self.pos) then
          self.pos = vector(unpack(self.pos))
        else
          self.pos = vector(-1, -1)
        end
      end
    end
  end,
  defaults = {
    --Implemented by subclass
  }
}