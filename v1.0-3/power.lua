require "bins"
require "xy"

function powerranges0()
  return { threshold = 0.5 }
end

function powerrranges(t0,i)
  i = i or powerranges0()
  local rows = binned(t0)
  local syms={}
  for _,row in pairs(rows) do
    for z,meta in pairs(t0.also.x.ALL) do
      local col = meta.pos
      local here, there = row.x[col], row.y[1]
      sym    = ent2(syms,col,here,there)
      sym.OF = meta
    end
  end
  for column,seenSymbols in pairs(syms) do
    print("\n",column, "...")
    for range,sym in pairs(seenSymbols) do
      print("\t",range,sym.OF.str,sym.counts, ent(sym)) end end
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
  --print(t.also.x)
  -- print(t.also.y)
  --for i,row in ipairs(binned(t)) do
     --print(i,row)
  --end
  powerrranges(t)
end
