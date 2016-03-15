require "bins"
require "xy"



function powerranges0()
  return { threshold = 0.5 }
end

function powerrranges(t0,i)
  i = i or powerranges0()
  local rows = binned(t0)
  local syms={}
  for j,row in pairs(rows) do
    for k,sym in pairs(row.x) do
      ent2(syms,k,sym,row.y[1])
    end
  end
  for x1,x2 in pairs(syms) do
    for y1,sym in pairs(x2) do
      print(x1,y1, ent(sym)) end end
end

function getcol(meta)
  return function (row)
            return row[meta.xy][meta.pos]
	 end
end

function bin(meta,x)
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

function binned(t0)
  for _,meta in pairs(t0.meta) do
    if meta.num then
      meta.bins = bins(map(t0.rows, getcol(meta)))
    end end
  t1={}
  for _,row in ipairs(t0.rows) do
    local tmp = {x={}, y = {}, row=row}
    for _,meta in pairs(t0.meta) do
      xy,p = meta.xy, meta.pos
      tmp[xy][p] = bin(meta,row[xy][p])
    end
    t1[#t1+1] = tmp
  end
  return t1
end

if arg[1] == "--power" then
  local t= xy()
  print(t.also.y)
  for i,row in ipairs(binned(t)) do
    print(i,row)
  end
  powerrranges(t)
end