scripts = {}

function scripts.doghit(scene, player, dog)
  dog.pos.x = dog.pos.x + 2
  print("onCollide")
end

function scripts.indog(scene, player, dog)
  if dog.pos.y > player.pos.y then
    dog.pos.y = player.pos.y + player.collision_depth/2 + dog.collision_depth/2
  else
    dog.pos.y = player.pos.y - player.collision_depth/2 - dog.collision_depth/2
  end
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

function scripts.loadNextScene(  )
  switchScene("scene2")
end

function scripts.welcomeToSc1(  )
  print("welcome to Scene 1")
end

function scripts.welcomeBack(  )
  print("welceome back")
end

function scripts.gotoscene1(  )
  switchScene("scene1")
end