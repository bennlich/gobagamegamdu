scripts = {}

function scripts.stopPlayer( scene, player, obstacle )
  if player.pos.y < obstacle.pos.y then 
    player.pos.y = obstacle.pos.y-obstacle.thickness/2-player.thickness/2
    print(player.pos.y, obstacle.pos.y)
  elseif player.pos.y > obstacle.pos.y then
    player.pos.y = obstacle.pos.y+obstacle.thickness/2+player.thickness/2
  end
end

function scripts.enterBlimp( scene, player, obstacle )
  switchScene("blimp")
end