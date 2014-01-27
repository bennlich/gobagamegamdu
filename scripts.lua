scripts = {}

function scripts.stopPlayer( scene, player, obstacle )
  if player.pos.y < obstacle.pos.y then 
    player.pos.y = obstacle.pos.y-obstacle.depth/2-player.depth/2
  elseif player.pos.y > obstacle.pos.y then
    player.pos.y = obstacle.pos.y+obstacle.depth/2+player.depth/2
  end
end

function scripts.enterBlimp( scene, player, obstacle )
  switchScene("blimp")
end

function scripts.changeLabel( scene, player, fisherman )
  fisherman.label:setContent("dicks")
end

function scripts.debugOn( scene, player, obstacle )
  oldColor = player.color
  player.color = {255, 0, 0}
end
function scripts.debugOff( scene, player, obstacle )
  player.color = oldColor
end