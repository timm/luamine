require "bins"
require "xy"

function columns0()
  return { enough  = 0.5,
	   cohen   = 0.3,
	   verbose = true} end

function columns(t,i)
  i = i or columns0()
  ----------------------------------------
  local function countSymbols(rows)
    local syms={}
    for _,row in pairs(rows) do
      for z,meta in pairs(t.also.x.all) do
	local col = meta.pos
	local here, there = row.x[col], row.y[1]
	sym    = ent2(syms,col,here,there)
	sym.of = meta
    end end
    return syms -- e.g. syms[3]["a"] = y[1] valyes seen when column3=="a"
  end
  ---------------------------------------
  local function show(syms)
    for column,seenSymbols in pairs(syms) do
      print("")
      for range,sym in pairs(seenSymbols) do
	print(sym.of.str,range,sym.counts, ent(sym))
    end end end
  ---------------------------------------    
  local function xpectedValues(syms,  n,out)
    for column,seenSymbols in pairs(syms) do
      local e = 0
      for range,sym in pairs(seenSymbols) do
	e = e + sym.n/n*ent(sym)
      end
      out[#out+1 ] = {e,column}
    end
    return out
  end
  ---------------------------------------
  local function good(n, ents)
    print(ents)
    local config = also(bins0(),
			{enough = n^i.enough,
			 cohen  = i.cohen})
    local ranges = bins(firsts(ents),config)
    return first(ranges).up
  end
  ---------------------------------------  
  local rows = binned(t)
  local n    = #rows
  local syms = countSymbols(rows)
  if i.verbose then show(syms,rows) end
  local xs = xpectedValues(syms,n, {})
  local threshold = good(n,  xs)
  local out = {}
  for _,pair in pairs(xs) do
    if first(pair) <= threshold then
      out[#out+1] = second(pair) end
  end
  return out
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
      local nums = map(t0.rows,
		       function (row)
			 return row[meta.xy][meta.pos] end )
      meta.bins = bins(nums)
    end end
  t1={}
  for _,row in ipairs(t0.rows) do
    local tmp = {x={}, y = {}, row=row}
    for _,meta in pairs(t0.meta) do
      xy,p = meta.xy, meta.pos
      tmp[xy][p] = bin(meta,row[xy][p])
    end
    row._cooked = tmp
    tmp._raw = row
    t1[#t1+1] = tmp
  end
  return t1
end

if arg[1] == "--cols" then
  local t= xy()
  binned(t)
  print(t.rows[1]._cooked)
  --print(t.also.x)
  -- print(t.also.y)
  --for i,row in ipairs(binned(t)) do
     --print(i,row)
  --end
  -- print(columns(t))
end
