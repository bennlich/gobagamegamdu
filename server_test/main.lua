require("libs.hump.class")
require("libs.LUBE")

server = lube.tcpServer()

function onData(data, clientid)
	print(data .. 'from' .. clientid)
end

function onConnect(clientid)
	print('connected to' .. clientid)
end

function onDisconnect(clientid)
	print('disconnected from' .. clientid)
end

server.callbacks.connect = onConnect
server.callbacks.disconnect = onDisconnect
server.callbacks.recv = onData

server:listen(8080)
