require("libs.hump.class")
require("libs.LUBE")

function receiveData(data)
  print(data)
end

function love.load(  )
  client = lube.tcpClient()
  client.callbacks.recv = receiveData
  success, error = client:connect('localhost', 8080)
  print (success, error)
end

function love.update( dt )
    client:update(dt)
end

function love.keypressed( key )
  success, error = client:send({message = key})
  print("Sending message. Success = " .. tostring(success) .. ", Error = " .. error)
end