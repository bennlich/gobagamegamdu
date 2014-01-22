
function drawShip( ship )
  local vertices = {
    -15, -10,
    0, -10,
    15, -4,
    15, 4,
    0, 10,
    -15, 10 
  }
  local shipColor = {216,216,216}
  local outerGlowColor = {159, 3, 3}
  local innerGlowColor = {245, 166, 35}
  -- ship = {pos = {x = 40, y = 50}}
  love.graphics.setLineStyle('smooth')
  love.graphics.push()
  love.graphics.translate(ship.pos.x, ship.pos.y)
  love.graphics.rotate(-ship.angle)


  love.graphics.setColor(outerGlowColor)
  love.graphics.circle('fill', -15, 0, 10, 30)
  love.graphics.setColor(innerGlowColor)
  love.graphics.circle('fill', -15, 0, 7, 30)
  love.graphics.setColor(shipColor)
  love.graphics.polygon('line', vertices)
  love.graphics.polygon('fill', vertices)

  love.graphics.pop()

end