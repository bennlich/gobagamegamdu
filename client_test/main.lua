require("libs.hump.class")
require("libs.LUBE")

function receiveData(data)
  print(data)
end

function love.load(  )
  client = lube.tcpClient()
  client.handshake = "moosepants"
  client.callbacks.recv = receiveData
  success, error = client:connect('192.168.1.108', 8080)
  print (success, error)
end

function love.update( dt )
    client:update(dt)
end


function love.keypressed( key )
  success, error = client:send("Hello!")
  print(success, error)
end