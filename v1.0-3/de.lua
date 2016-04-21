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

------------------------------
function num0(t)
  local tmp = {mu= 0, n= 0, m2= 0, w=1, 
	       up= -1e32,   lo= 1e32}
  map(t, function (z) num1(z,tmp) end)
  return tmp
end

function num1(z,t)
  if z < t.lo then t.lo = z end
  if z > t.up then t.up = z end
  t.n  = t.n + 1
  local delta = z - t.mu
  t.mu = t.mu + delta / t.n
  t.m2 = t.m2 + delta * (z - t.mu)
  return t
end

function norm(z, t)
  return (z - t.lo) / (t.up - t.lo + 1e-32)
end

function sym0(t)
  local tmp = {counts={}, most=0, mode=nil, n=0, w=1}
  map(t, function (z) sym1(z,tmp) end)
  return tmp
end

function sym1(z,t)
  t.n  = t.n + 1
  local old,new
  old = t.counts[z]
  new = old and old + 1 or 1
  t.counts[z] = new
  if new > t.most then
    t.most, t.mode = new,z
  end
  return t
end

------------------------------

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
    --- XXX norm
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

function neighbors(row,t,clus,up,lr)
  t.items[#t.items+1] = row
  if not t.easts and not t.wests then
    return t
  end
  local x,_ = project(row, t.c, t.west, t.east, clus.sp)
  local tiny = c*t.small
  if x > (c+tiny) or x < (-1*tiny) then
    x.strange = x.strange + 1
    spaces1(row,clus)
  end
  if x.strange > clus.sp.tooStrange then
    t = cluster(items,clus,t.lvl)
    up[lt] = t
    return neighbors(row,t,clus,up,lr)
  end
  if t.wests and x <= t.cut then
    return neighbors(row,t.wests,sp,t,"wests")
  end
  if t.easts and x > t.cut then
    return neighbors(row,t.easts,sp,t,"easts")
  end
  return t
end


function cluster1(sp)
  return {enough=0.5,min=20,sp=nil,tooStrange=20,tiny=0.05}
end

function cluster(pop, clus,lvl)
  local lvl    = lvl and lvl or 1
  local tiny   = #pop ^ clus.enough
  local tiny  >= clus.min and tiny or clus.min
  ---------------------------------
  function recurse(items, lvl)
    local t= {items=items, lvl=lvl, strange=0}
    if #items >= tiny
    then
      east, west, wests, easts = split(items,t)
      if not clus.better(west,east,clus) then
	t.l = recurse(easts, lvl+1)
      end
      if not clus.better(east,west,clus) then
	t.r = recurse(wests, lvl+1)
      end
    end
    return t
  end
  ---------------------------------
  function splits1(d)
    local mid = math.floor(#d/2)
    local cut,wests,easts
    for j,item in ipairs(d) do
      if j == mid then cut = d[1] end
      if   j <= mid
      then wests[ #wests + 1 ] = d[2]
      else easts[ #easts + 1 ] = d[2]
      end
    end
    return cut,wests,east
  end
  -------------------------------
  function project(one,c,west,east,sp)
    local a = dist(one,west,sp)
    local b = dist(one,east,sp)
    local x = (a*a + c*c - b*b) / (2*c + 0.000001)
    x = x^2 <= a^2 and x or a
    local y = (a^2 - x^2)^0.5
    return x,y
  end
  -------------------------------
  function split(items,t)
    local z    = any(items)
    local east = furthest(z,   items)
    local west = furthest(east,items)
    local c    = dist(west, east, sp)
    local d    = {}
    for _,one in ipairs(items) do
      x,y = project(one,c,west,east,sp)
      if not one.pos then one.pos = {x=x,y=y} end
      d[#d+1] = {x,one}
    end
    table.sort(d)
    local cut, wests, easts = splits1(d,mid)
    t.east=east, t.west=west, t.c=c, t.cut= cut
    return west,east,wests,easts
  end
  return recurse(items, lvl)
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
