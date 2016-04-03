require "tools"

do
  local function x(row) return row.x end
  local function distxy(x,y,col,t)
    if x == y then return 0 end
    if x == t.ignore and y = t.ignore then return 0 end
    if not numcol(col) then
      return x == y and 0 or 1
    else
      if y == t.ignore then
	x = norm(x, col)
	y = x > 0.5 and 0 or 1
      elseif x == t.ignore then
	y = norm(y, col)
	x = y > 0.5 and 0 or 1
      else
	x = norm(x, col)
	y = norm(y, col)
      end
      return (x - y)^2
    end
  end
  --------------------------------------------------
  local function dist1(row1,row2,t,cols)
    local w,sum = 0,0
    for i,col in ipairs(cols) do
      if col.w > 0 then
	sum = sum + col.w * distxy(row1[i], row2[i],col,t)
	w   = w   + col.w
    end end
    return sum^0.5 / (w+0.00001)^0.5
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
    end
  end
end
