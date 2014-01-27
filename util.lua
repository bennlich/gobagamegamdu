function table.empty( tbl )
  return not next(tbl)
end

function table.concatArrays( ... )
  local t = {}
  for n = 1,select("#",...) do
      local arg = select(n,...)
      if type(arg)=="table" then
          for _,v in ipairs(arg) do
              t[#t+1] = v
          end
      else
          t[#t+1] = arg
      end
  end
  return t
end

nextTable={}
function table.next(data)
  local ret = {}
  nextTable[data], ret = next(data, nextTable[data])
  return ret
end