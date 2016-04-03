require "sample"

do
  local function x(row) return row.x end
  local function distxy(x,y,col,t,w)
    if x == t.ignore and y == t.ignore then return 0,0 end
    if x == y                          then return 0,w end
    if not numcol(col)                 then return 1,w end
    if     y == t.ignore then
           x = norm(x, col)
           y = x > 0.5 and 0 or 1
    elseif x == t.ignore then
           y = norm(y, col)
           x = y > 0.5 and 0 or 1
    else   x = norm(x, col)
           y = norm(y, col)
    end
    return (x - y)^2,w
  end 
  --------------------------------------------------
  local function dist1(x,y,cols)
    local w,n  = 0,0
    print(cols)
    for i,col in ipairs(cols) do
      local w = col.w
      if w > 0 then
	local n1,w1 = distxy(x[i],y[i],col,t,col,w)
	n  = n + w1 * n1
	w  = w + w1
    end end
    return n^0.5 / (w+0.00001)^0.5
  end
  --------------------------------------------------
  function dist(row1,row2,t,xy)
    if row1.id > row2.id then
      return dist(row2,row1,t,xy)
    else
      xy = xy and xy or x
      local dists = xy(t.dists)
      local k     = {row1.id, row2.id}
      local d     = dists[k]
      if   d
      then return d
      else d = dist1(xy(row1),xy(row2), xy(t.columns))
	   dists[k] = d
      end
      return d
  end end
  --------------------------------------------------
  function closest(x, rows, t, xy, init, bt)
    bt  = bt   and bt   or lt
    init= init and init or 10^32
    local best, out = init, x
    print(23,x)
    for _,y in pairs(rows) do
      print(44,y)
      local d= dist(x,y,t,xy)
      if bt(d,best) then
	out, best = y,d
    end end
    return best,out
  end
  --------------------------------------------------
  function furthest(x, rows, t, xy)
    return closest(x, rows, t, xy, -10^32, gt)
  end
end

if arg[1] == "--dists" then
  local t
  for _,names,row in xys() do
    t = sample1(row,t,names)
  end
  for _,row1 in pairs(t.rows) do
    print(1,row1)
    local row2= closest(row1,t.rows,t)
    print(1,row1)
    print(2,rows)
  end
end
