Pretty = require("pl.pretty")
require("util")

Dialog = Class{
	init = function(self, filename, scene)
		io.input("resources/"..filename)
		self.scene = scene
    	self.data = pretty.read(io.read("*all"))
    	self:nextChar()
    	-- if not self.activeChar then
    	-- 	print("no character named " .. self.data[1].name .. " in scene")
    	-- end
	end
}

function Dialog:next()
	nextMessage = table.next(self.nextDialog.content)
	if (nextMessage) then
		self.activeChar.label:setContent(nextMessage)
		return nextMessage
	else
		self:nextChar()
		self:next()
	end
end

function Dialog:nextChar()
	self.nextDialog = table.next(self.data)
	self.activeChar = self.scene.objects[self.nextDialog.name]
end