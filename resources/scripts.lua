scripts = {}

function scripts.stopObj1( scene, obj1, obj2, penAmt, penDir)
  -- Todo write a script that converts "penDir" into modulations of vector
  if penDir == 'left' then 
    obj1.pos.x = obj1.pos.x - penAmt
  elseif penDir == 'right' then 
    obj1.pos.x = obj1.pos.x + penAmt
  elseif penDir == 'top' then 
    obj1.pos.z = obj1.pos.z + penAmt
  elseif penDir == 'bottom' then 
    obj1.pos.z = obj1.pos.z - penAmt
  elseif penDir == 'front' then 
    obj1.pos.y = obj1.pos.y - penAmt
  elseif penDir == 'back' then 
    obj1.pos.y = obj1.pos.y + penAmt
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