tablex = require("pl.tablex")

colors = {
  black = { 37, 30, 32 },
  white = { 255,255,255 },
  border = { 198,200,202 },
  gray = { 102,101,102 },
  pink = { 232, 99,162 },
  magenta = { 154, 88,158 },
  darkBlue = { 46, 61,141 },
  turquoise = { 0,161,170 },
  blue = { 0,118,183 },
  green = { 52,181,130 },
  yellowGreen = { 173,193,114 },
  orange = { 210,145, 67 },
  red = { 191, 58, 56 }
}

function colors.loadColor( c )
  local ret = {}
  if type(c) == 'string' then
    ret = tablex.copy(colors[c])
  elseif type(c) == 'table' and type(c[1])=='string' then
    ret = tablex.copy(colors[c[1]])
    ret[4] = c[2]
  else
    ret = c
  end
  return ret
end