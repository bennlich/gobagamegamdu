pretty = require("pl.pretty")
tablex = require("pl.tablex")
require("util")

Dialog = Class{
	init = function(self, filename, scene, callback)
		io.input("resources/"..filename..".dialog")
		self.scene = scene
  	self.data = pretty.read(io.read("*all"))
  	self:nextChar()
    self.callback = callback
    	-- if not self.activeChar then
    	-- 	print("no character named " .. self.data[1].name .. " in scene")
    	-- end
	end
}

function Dialog:next()
	local nextMessage = table.next(self.nextDialog.content)
	if nextMessage then
		self.activeChar.label:setContent(nextMessage)
		return nextMessage
	else
		if self:nextChar() then self:next()
    else
      self:resetOldLabel()
      if self.callback then self.callback() end
    end
	end
end

function Dialog:resetOldLabel()
  if self.activeChar then
    self.activeChar.label.zOrder = self.oldZOrder
    self.activeChar.label.content = self.oldContent
  end
end

function Dialog:nextChar()
  -- Reset old label
  self:resetOldLabel()

	self.nextDialog = table.next(self.data)
  if not self.nextDialog then
    return false
  else
  	self.activeChar = self.scene.objects[self.nextDialog.name]

    -- Cache current label
    self.oldZOrder = self.activeChar.label.zOrder
    self.oldContent = self.activeChar.label.content
    self.activeChar.label.zOrder = 0
    return self.activeChar
  end
end