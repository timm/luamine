-- i = self
-- xx0(items), xx0() creates new "xx", initilize with items
-- xx1(i, item) : increatement "i" of type "xx" with item

MISSING = "_"
-------------------------------------------------------
function items(t)
  local i=0
  return function ()
    if t then
      i = i + 1
      if i <= #t then return t[i] end end end
end

function gt(a,b) return a > b end
function lt(a,b) return a < b end
-------------------------------------------------------
function num0(some)
  local i= {mu= 0, n= 0, m2= 0, up= -1e32, lo= 1e32, put=num1}
  for one in items(some) do
    num1(i,one) end
  return i
end

function num1(i, one)
  if one ~= MISSING then 
    i.n  = i.n + 1
    if one < i.lo then i.lo = one end
    if one > i.up then i.up = one end
    local delta = one - t.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (one - i.mu) 
end end

function sd(i)
  return i.n <= 1 and 0 or (i.m2 / (i.n - 1))^0.5
end

function norm(i,one)
  return (one - i.lo) / (i.up - i.lo + 1e-32)
end

function sym0(some)
  local i = {counts={}, most=0, mode=nil, n=0,put=sym1}
  for one in items(some) do
    sym1(i,one) end
  return i
end

function sym1(i, one)
  if one ~= MISSING then
    i.n  = i.n + 1
    local old = t.counts[one]
    local new = old and old + 1 or 1
    t.counts[one] = new
    if new > t.most then
      t.most, t.mode = new,one
end end end

function dist(i,a,b)
  if (a == MISSING and b == MISSING) then
    return nil
  end
  if i.put == sym1 then
    return a==b and 0 or 1
  end
  -- so now we are about numbers
  if a == b then
    return 0
  end
  if     a == MISSING then
         b = norm(i, b)
         a = b > 0.5 and 0 or 1
  elseif b == MISSING then
         a = norm(i, a)
         b = b > 0.5 and 0 or 1
  else   a = norm(i, a)
         b = norm(i, b)
  end
  return (a-b)^2
end 
  
----------------------------------------------------
do
  id = 1
  function row0()
    id = id + 1
    return {id=id, x={}, y={}}
end end
----------------------------------------------------
function sp0()
  return {abouts={}, n=0, dists={}}
end

function sp1(i,row)
  local once=false
  for pos,item in ipairs(row) do
    if item ~= MISSING then
      once=true
      if not i.abouts[pos] then
	local tmp = tonumber(item)
	i.abouts[pos] = tmp and num0() or sym0()
      end
      about.put(i.abouts[pos], item)
  end end
  if once then i.n = i.n + 1 end
end

function dists(i,row1,row2)
  if row1.id > row2.id then
    row1,row2 = row2,row1
  end
  local k = {row1.id, row2.id}
  local d = i.dists[k]
  if not d then
    local all,n = 0, 0.0000001
    for j=1,#row1 do
      local inc = dist(i.abouts[i],row1[j],row2[j])
      if   inc
      then n   = n   + 1
	   all = all + inc
    end end
    d = all^0.5 / n^0.5
    i.dists[k] = d
  end
  return d
end
---------------------------------------------------
function twin0()
  return {x=sp0(), y=sp0()}
end

function twinx1(i,row) sp1(i.x,row) end
function twiny1(i,row) sp1(i.y,row) end
---------------------------------------------------
function def( txt, get, better)
  return {txt=txt, get=get, better=better}
end

function from(lo,hi)
  return function () return lo + (hi - lo)*r() end
				  
function model1()
  local function ok(x) return true end
  local function f1(x) return x[1]**2 end
  local function f2(x) return (x[2] + x[3])**2 end
  return {
    ok = ok,
    x  = { def("age",            from(0,120)),
	   def("showSize",       from(1,12)),
	   def("height",         from(0,120)) }
    y  = { def("lifeExpectancy", f1, gt),
	   def("weight",         f2, lt) }
  }
end

function decs(model)
  local it = {x={},y={}}
  for i,f in ipairs(fs) do it.x[i] = f.get() end
  return xy
end

function objs(it,mpdel)....////////////////////wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
  if #xy.y == 0 then
    for i,f in ipairs(m.y) do xy.y[j] = f(xy.x) end
    space1(xy.y, spaces.y)
  end
  return xy
end
