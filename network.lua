require("enet")
input = require("input")
local network = {}

function network.sendMessage(msg)
  if network.peer then
    print("Message sent:", msg)
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
  print('hey', data)
  if data == 'moveLeft' then
    player:moveLeft()
  elseif data == 'moveRight' then
    player:moveRight()
  elseif data == 'moveDown' then
    player:moveDown()
  elseif data == 'moveUp' then
    player:moveUp()
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