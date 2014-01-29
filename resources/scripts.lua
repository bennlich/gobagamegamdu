cron = require("libs.cron")
scripts = {}

function scripts.stopObj1( scene, obj1, obj2, penAmt, penDir)
  -- Todo write a script that converts "penDir" into modulations of vector
  if penDir == 'left' then 
    obj1.pos.x = obj1.pos.x - penAmt
  elseif penDir == 'right' then 
    obj1.pos.x = obj1.pos.x + penAmt
  elseif penDir == 'top' then 
    obj1.elevation = obj1.elevation + penAmt
  elseif penDir == 'bottom' then 
    obj1.elevation = obj1.elevation - penAmt
  elseif penDir == 'front' then 
    obj1.pos.y = obj1.pos.y - penAmt
  elseif penDir == 'back' then 
    obj1.pos.y = obj1.pos.y + penAmt
  end
end

function scripts.playerHitFisherpit( scene, player, fisherpit )
  -- if scene.objects["dog"] and fisherpit.inAir then
  if not fisherpit.inAir then
    -- Blimp takes off
    fisherpit.inAir = true
    local blimp = scene.objects["skyblimp"]
    local time, easing = 8, 'inQuad'
    tween(time, blimp, {pos=vector(blimp.pos.x+1000,blimp.pos.y), elevation = 800}, easing)
    tween(time, fisherpit, {pos=vector(blimp.pos.x+1000,blimp.pos.y), elevation = 800}, easing)
  else
    switchScene("blimp")
  end
end

function scripts.curseAtPlayer( scene, player, curser )
  local curses = {"@#@$^#?!", "@$#%&*!", "?!?!?!?", "&*#@!"}
  curser.label:setContent(curses[math.random(1, #curses)])
end

function scripts.goToTower( scene, player, bicycle )
  switchScene("atthetower")
end

function scripts.goToBeachBlimp( scene, player, bicycle )
  switchScene("beachblimp")
end

function scripts.goToBlockCity2( scene, player, bicycle )
  switchScene("blockcity2")
end

function scripts.spawnBirds( scene, player )
  numBirds = 1
  local function spawnOne()
    local name = "bird"..tostring(numBirds)
    local birdY = 20
    local offset = camera:getEdgeOffset(birdY)
    local birdSize = 20
    scene:add(Square{
      name = name, pos = {offset-birdSize/2, birdY}, elevation = 300+math.random(0,90), size=birdSize,
      label = "Bird", color='white', border={thickness=2, color='gray'}, 
      behavior = {'moveRight'}, other = {xVel = 4}
      }
    )
    numBirds = numBirds+1
  end
  local c = cron.after(2.5, function()
    spawnOne()
    local repeatSpawn = cron.every(5, spawnOne)
    scene:addClock(repeatSpawn)
  end)
  scene:addClock(c)
end

function scripts.birdBounce( scene, bird, tower )
  -- Could also bounce off
  if bird.bounced == true then return end
  bird.bounced = true
  local time = 1.5
  tween(time, bird.pos, {x = bird.pos.x-math.random(50, 150), y = bird.pos.y+math.random(0, 100)})
  tween(time, bird, {elevation = 0}, 'outBounce', function( )
    bird.label:setContent("Dead Bird")
  end)
  bird.behavior = {}
end

function scripts.kidBounce( scene, kid, tower )
  local time = 0.5
  local waitTime = 2
  local oldBehavior = kid.behavior
  local oldLabelContent = kid.label.content
  kid.behavior = {}
  tween(time, kid.pos, {x=kid.pos.x-70})
  tween(time/2, kid, {elevation = 30}, 'outQuad', function()
    tween(time/2, kid, {elevation = 0}, 'inQuad', function()
      scripts.curseAtPlayer(scene, player, kid)
      local c = cron.after(waitTime, function()
        kid.behavior = oldBehavior
        kid.label:setContent(oldLabelContent)
      end)
      scene:addClock(c)
    end)
  end)
end

function scripts.kidScram( scene, player )
  print("scram, kids!")
end

function scripts.dialogTest( scene, player, interactionCube )
  if (love.keyboard.wasJustPressed(" ")) then
    print("dialog test")
    print(scene.dialogs['chameleonDialog']:next())
  end
end