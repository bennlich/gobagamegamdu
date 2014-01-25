triWidth, triHeight = 10, 10
boxWidth, boxHeight = 200, 100

function dialogbox.draw(  )
  love.graphics.setLineWidth(5)
  love.graphics.setLineStyle("smooth")
  love.graphics.translate(100,100)

  local vertices = {
    0, 0,
    0, boxHeight,
    boxWidth/2-triWidth/2, boxHeight,
    boxWidth/2, boxHeight + triHeight,
    boxWidth/2+triWidth/2, boxHeight,
    boxWidth, boxHeight,
    boxWidth, 0
  }
  love.graphics.polygon("line",vertices)
end

function dialogbox.keypressed()
  if (key == 'left') then triWidth = triWidth + 1 end
  if (key == 'right') then triWidth = triWidth - 1 end
  if (key == 'up') then triHeight = triHeight + 1 end
  if (key == 'down') then triHeight = triHeight - 1 end
  
  if (key == 'a') then boxWidth = boxWidth + 5 end
  if (key == 'd') then boxWidth = boxWidth - 5 end
  if (key == 'w') then boxHeight = boxHeight + 5 end
  if (key == 's') then boxHeight = boxHeight - 5 end
end
