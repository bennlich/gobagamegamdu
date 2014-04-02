require("enet")
input = require("input")
pretty = require("pl.pretty")
local network = {}

function network.sendMessage(msg)
  if type(msg) == 'table' then msg = pretty.write(msg) end
  if network.peer then
    network.peer:send(msg) 
  end
end

function network.update( dt )
  if love.keyboard.wasJustPressed('c') then network.initAsClient() end
  if love.keyboard.wasJustPressed('s') then network.initAsServer() end

  if network.host then
    local event = nil
    repeat
      local event = network.host:service()
      if event then 
        if event.type == "connect" then
          network.peer = event.peer
        elseif event.type == "receive" then
          network.messageReceived(event.data)
        end
      end
    until event == nil
  end
end

function network.messageReceived( data )
  --TODO SHOULD PASS IN SCENE HERE
  data = pretty.read(data) or data
  if type(data) == 'table' then
    activeScene.objects[data.name].pos = vector(data.pos.x, data.pos.y)
  end
end

function network.shutDown(  )
  if network.type == "server" then
  elseif network.type == "client" then
    network.peer:disconnect()
    network.host:flush()
  end
  network.host = nil
end

function network.initAsClient()
  print("starting up a client")
  network.shutDown()
  network.type = "client"
  network.host = enet.host_create()
  network.peer = network.host:connect("localhost:8080")
end

function network.initAsServer()
  print("starting up a server")
  network.shutDown()
  network.type = "server"
  network.host = enet.host_create("localhost:8080")
end

return network