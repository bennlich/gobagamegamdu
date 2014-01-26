scripts = {}

function scripts.doghit(scene, player, dog)
  dog.pos.x = dog.pos.x + 2
  print("onCollide")
end

function scripts.indog(scene, player, dog)
  dog.pos.x = dog.pos.x + 2
  print("onColliding")
end

function scripts.release(scene, player, dog)
  dog.pos.x = dog.pos.x + 2
  print("onRelease")
end

function scripts.turnred(scene, player, tower)
  oldcolor = player.color
  player.color = {255, 0, 0}
end

function scripts.unturnred(scene, player, tower)
  player.color = oldcolor
  
end