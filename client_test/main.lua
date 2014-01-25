require("libs.hump.class")
require("libs.LUBE")

function receiveData(data)
  print(data)
end

function love.load(  )
  client = lube.tcpClient()
  success, error = client:connect('localhost', 8080)
  print (success, error)
  client.callbacks.recv = receiveData
end

function love.update( dt )
    client:update(dt)
end