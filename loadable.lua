Class = require("libs.hump.class")

Loadable = Class{
  init = function(self, opts)
    for k,v in pairs(self.defaults) do
      -- Tries to load the number-versioned of parameters,
      -- then the unnumbered version, and then the defaults
      self[k] = (opts[world_vers] and opts[world_vers][k]) 
        or opts[k] 
        or self.defaults[k]
    end
    -- Lets you pass in either a vector or a pair of numbers
    self.pos = (vector.isvector(self.pos) and self.pos) 
      or vector(unpack(self.pos))
  end,
  defaults = {
    --Implemented by subclass
  }
}