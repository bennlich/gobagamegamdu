scripts = {}

function scripts.stopPlayer( scene, player, obstacle, penAmt, penDir)
  -- Todo write a script that converts "penDir" into modulations of vector
  if penDir == 'left' then 
    player.pos.x = player.pos.x - penAmt
  elseif penDir == 'right' then 
    player.pos.x = player.pos.x + penAmt
  elseif penDir == 'top' then 
    player.pos.z = player.pos.z + penAmt
  elseif penDir == 'bottom' then 
    player.pos.z = player.pos.z - penAmt
  elseif penDir == 'front' then 
    player.pos.y = player.pos.y - penAmt
  elseif penDir == 'back' then 
    player.pos.y = player.pos.y + penAmt
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

function scripts.curseAtPlayer( scene, player, bicycle )
  local curses = {"@#@$^#?!", "@$#%&*!", "?!?!?!?", "&*#@!"}
  bicycle.label:setContent(curses[math.random(1, #curses)])
end

function scripts.goToBlockCity2( scene, player, bicycle )
  switchScene("blockcity2")
end