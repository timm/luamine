require "bins"
require "xy"

function columns0()
  return { enough  = 0.25,
	   cohen   = 0.3,
	   verbose = true} end

function columns(t,i)
  i = i or columns0()
  ----------------------------------------
  local function increment(xsyms,ysym, x,y)
    local xsym = xsyms[x] or sym0() -- init if not known
    xsyms[x] = xsym                -- ensure it in syms
    sym1(y,xsym)
    sym1(y,ysym)
  end
  ----------------------------------------
  local function rank(rows, cols, ranks, es)
    for col = 1, cols do
      local ysym, xsyms = sym0(), {}
      for _,row in pairs(rows) do
	increment(xsyms, ysym, row.x[col], row.y[1])
      end
      local e, ye = 0, ent(ysym)
      for _,xsym in pairs(xsyms) do
	e = e + xsym.n / #rows * ent(xsym)
      end
      local infogain = ye - e
      ranks[ #ranks+1 ] = {e= infogain, col=col}
      es[ #es+1] = infogain
    end 
    return ranks,es
  end
  ---------------------------------------
  local function threshold(es, config)
    local config = also(bins0(), {cohen = i.cohen,
				  small = #rows*i.enought})
    local ranges = bins(es, config)
    return last(ranges).lo
  end
  ---------------------------------------
  local rows  = binned(t)
  local ranks, es = rank(rows, #t.meta.x, {},{})
  if i.verbose then print(ranks) end
  local n = threshold(es)
  return select(ranks, function (rank)
		         return rank.e >= n, rank.col
                       end)
end

function bin(meta,x)
  b = meta.bins
  if b ~= nil then 
    if x < b[1].lo  then return b[1].id end
    if x > b[#b].up then return b[#b].id end
    for _,bin in ipairs(b) do
      if x >= bin.lo and x <= bin.up then
	return bin.id
  end end end
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
