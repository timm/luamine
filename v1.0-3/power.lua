require "bins"
require "xy"



function powerranges0()
  return {threshold = 0.5 }
end

function getcol(meta)
  return function (row)
            return row[meta.xy][meta.pos]
	 end
end

function colSymbol(meta,x)
  b = meta.bins
  if b ~= nil then 
    if x < b[1].lo  then return b[1].id end
    if x > b[#b].up then return b[#b].id end
    for _,bin in ipairs(b) do
      if x >= bin.lo and x <= bin.up then
	return bin.id
      end
    end
  end
  return x 
end

function powerranges(t,i)
  i = i or powerranges0()
  for _,meta in pairs(t.meta) do
    if meta.num then
      dot(".")
      meta.bins = bins(map(t.rows, getcol(meta)))
    end end
  for _,row in ipairs(t.rows) do
    local tmp = {x={}, y = {}, row=row}
    for _,meta in pairs(t.meta) do
      xy,p = meta.xy, meta.pos
      tmp[xy][p] = colSymbol(meta,row[xy][p])
    end
    print(tmp)
  end 
end

if arg[1] == "--power" then
  local t = xy()
  powerranges(t)
end