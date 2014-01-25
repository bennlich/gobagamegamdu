require("libs.hump.class")
require("libs.LUBE")

function love.load()
	server = lube.tcpServer()

	server.handshake = "moosepants"

	server.callbacks.connect = function(clientid)
		print('connected to' .. tostring(clientid))
	end

	server.callbacks.disconnect = function(clientid)
		print('disconnected from' .. tostring(clientid))
	end
	
	server.callbacks.recv = function(data, clientid)
		print(data .. 'from' .. tostring(clientid))
	end

	server:listen(8080)
end

function love.update(dt)
	server:update(dt)
end

-- function onData(data, clientid)
-- 	print(data .. 'from' .. clientid)
-- end

-- function onConnect(clientid)
-- 	print('connected to' .. clientid)
-- end

-- function onDisconnect(clientid)
-- 	print('disconnected from' .. clientid)
-- end
