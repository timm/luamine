function r(n)      return math.random(n) end
function rseed(n)  return math.randomseed(n and n or nil) end
function any(t)    return t[ r(#t) ] end
function from(a,b) return
  function () return a + (b-a)*r() end
end

function xy0()
  return {id=id, x={}, y={}}
end

function xs(xy) return xy.x end
function ys(xy) return xy.y end

function space0(f)
  return {lo  = {},
	  hi  = {},
	  get = f and f or xs}
end

function space1(new, sp)
  for i,val in ipairs(sp.get(new)) do
    local lo,hi = sp.lo[i],sp.hi[i]
    sp.lo[i] = val < lo and val or lo
    sp.ho[i] = val > hi and val or hi
end end

function dist(a,b,clus)
  local tmp,a,b = 0,clus.get(a), clus.get(b)
  for i=1,#a do
    local a1,b1 = norm(a,1,clus.sp), norm(b,1,clus.sp)
    tmp = tmp + (a1-b1)^2
  end
  return tmp^0.5 / #a^0.5
end

function furthest(row1, items, clus)
  local most=10**32,row1
  for _,row2 in ipairs(items) do
    local tmp = dist(row1,row2,clus)
    if tmp > most then
      most,out = tmp, row2
    end
  end
  return out
end

function norm(a,i,sp)
  return (a[i] - sp.lo[i]) / (sp.hi[i] - sp.lo[i])
end

function bindom(a,b, clus)
  local a, b = a.y, b.y
  local betters = 0
  for i=1,#a.y do
    local a1,b1 = norm(a,i,clus.sp), norm(b,i,clus.sp)
    if a1 < b1 then betters = betters+1 end
    if a1 > b1 then return false end
  end
  return betters > 0
end

function cluster1(sp)
  return {enough=0.5,min=20,sp=nil}
end

function cluster(pop, better, clus)
  local better = better and better and bindom
  local tiny   = #pop ^ clus.enough
  local tiny  >= clus.min and tiny or clus.min
  ---------------------------------
  function recurse(items)
    local t= {items=items}
    if #items >= tiny
    then
      west,east,c,wests, easts = split(items,t)
      t.east=east, t.west=west, t.c=c
      if not better(west,east,clus) then
	t.easts = recurse(easts)
      end
      if not better(east,west,clus) then
	t.wests = recurse(wests)
      end
    end
    return t
  end
  ---------------------------------
  function splits1(d)
    local mid = math.floor(#d/2)
    local wests,easts
    for j,item in ipairs(lst) do
      if   j <= min
      then wests[ #wests + 1 ] = item[2]
      else easts[ #easts + 1 ] = item[2]
    end end
    return wests,east
  end
  -------------------------------
  function split(items,t)
    local z    = any(items)
    local east = furthest(z,   items)
    local west = furthest(east,items)
    local c    = dist(west, east, sp)
    local d    = {}
    for _,one in ipairs(items) do
      a = dist(one,west,sp)
      b = dist(one,east,sp)
      x = (a*a + c*c - b*b) / (2*c + 0.000001)
      x = x^2 <= a^2 and x or a
      y = (a^2 - x^2)^0.5
      if not one.xx then
	one.xx = x
	one.yy = y
      end
      d[#d+1] = {x,one}
    end
    table.sort(d)
    local wests, easts = splits1(d,mid)
    return west,east,c,wests,easts
  end
  return recurse(items)
end

function ok(...) return true end

function model1()
  local function f1(x) return x[1]**2 end
  local function f2(x) return (x[2] + x[3])**2 end
  return {
    ok = ok,
    y  = {f1,f2},
    x  = {from(1,2), from(3,10), from(0,10)}
  }
end

function decs(m, spaces)
  local xy = {x={},y={}}
  for i,f in ipairs(fs) do xy.x[i] = f() end
  space1(xy.x, spaces.x)
  return xy
end

function objs(xy,m,spaces)
  if #xy.y == 0 then
    for i,f in ipairs(m.y) do xy.y[j] = f(xy.x) end
    space1(xy.y, spaces.y)
  end
  return xy
end
