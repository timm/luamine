-- i = self
-- xx0(items), xx0() creates new "xx", initilize with items
-- xx1(i, item) : increatement "i" of type "xx" with item

id = 1
function MISSING(x) return x == "_" end

-------------------------------------------------------

function map(t,f)
  local out = {}
  if t ~= nil then
    for i,v in pairs(t) do out[i] = f(v)
  end end
  return out
end

push = table.insert

function pushs(t,t1)
  map(t1, function(x) push(t,x) end)
  return t
end

function sort(t,fn)
  fn = fn and fn or lt
  table.sort(t,fn)
  return t
end

function __sort()
  local t = {20,10,20,5}
  t = sort(t)
  return t[1] <= t[#t]
end

function items(t)
  local i=0
  return function ()
    if t then
      i = i + 1
      if i <= #t then return t[i] end end end
end

function __items()
  local a={}
  for x in items{10,20,30} do
    push(a,x) end
  local c1= a[1] == 10 and a[2]==20 and a[3] == 30
  b= pushs({}, {10,20,30})
  local c2= b[1] == 10 and b[2]==20 and b[3] == 30
  return c1 and c2
end

function keys(t)
  local ks={}
  for k,_ in pairs(t) do push(ks,k) end
  ks = sort(ks)
  local i = 0
  return function ()
   if i < #ks then 
      i = i + 1
      return ks[i],t[ks[i]] end end
end

function __keys()
  local tmp, t = {}, {bb=1,aa=2,cc=3}
  for k,v in keys(t) do
    push(tmp,{k,v})
  end
  return tmp[1][1] == "aa" and tmp[1][2]==2
end

function member(x,t)
  for y in items(t) do
    if x== y then return true end end
  return false
end


function gt(a,b) return a > b end
function lt(a,b) return a < b end

function rogue()
  local builtin = { "jit", "bit", "true","math",
		    "package","table","coroutine",
		    "os","io","bit32","string","arg",
		    "debug","_VERSION","_G"}
  local tmp={}
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then
      if not member(k, builtin) then
	push(tmp,k) end end end
  print("-- Globals: ",sort(tmp))
end

function tests()
  for k,v in keys( _G ) do
    if type(v) == 'function' and
       k:sub(1,2) == "__"  
    then
      print("\n=====| "..k.." |============================")
      print(v() == true) end end
end

do
  local seed0     = 10013
  local seed      = seed0
  local modulus   = 2147483647
  local multipler = 16807
  local function park_miller_randomizer()
    seed = (multipler * seed) % modulus
    return seed / modulus
  end 
  function rseed(n)
    if n then seed = n else seed = seed0 end
    randomtable = nil
  end
  function r()
    return park_miller_randomizer()
  end
end

function __r()
  n=5
  rseed(n)
  local a,b = {},{}
  for i=1,n do push(a,r()) end
  rseed(n)
  for i=1,n do push(b,r()) end
  return sort(a,lt) == sort(b,lt)
end

do
  -- print table contents
  -- print tables in sorted key order
  -- dont print private keys (starting with "_")
  -- block recursive infinite loops
  _tostring = tostring
  local function stringkeys(t)
    for key,_ in pairs(t) do
      if type(key) ~= "string" then return false end
    end
    return true
  end
  function tostring(t,seen)
    if type(t) == 'function' then return "FUNC" end
    if type(t) ~= 'table'    then return _tostring(t) end
    seen = seen and seen or {}
    if seen[t] then return "..." end
    seen[t] = t
    local out,pre  = {'{'},""
    if stringkeys(t) then
      for k,v in keys(t) do
	if k:sub(1,1) ~= "_" then
	  pushs(out,{pre,k,"=",tostring(v,seen)})
	  pre=", "
      end end
    else
      for item in items(t) do
	pushs(out, {pre, tostring(item,seen)})
	pre=", "
    end end
    push(out,"}")
    return table.concat(out)
  end
end

function __show()
  local t1 = {kk=22,_ll=341,bb=31}
  t1.a = t1
  print{3,2,1, t1}
  print{1,2,3}
  print{aa=1,bb=2,cc=3}
  return true
 end

-------------------------------------------------------
function num0(some)
  local i= {mu= 0, n= 0, m2= 0, up= -1e32, lo= 1e32, put=num1}
  for one in items(some) do
    num1(i,one) end
  return i
end

function num1(i, one)
  if not MISSING(one) then 
    i.n  = i.n + 1
    if one < i.lo then i.lo = one end
    if one > i.up then i.up = one end
    local delta = one - i.mu
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
  if not MISSING(one) then
    i.n  = i.n + 1
    local old = t.counts[one]
    local new = old and old + 1 or 1
    t.counts[one] = new
    if new > t.most then
      t.most, t.mode = new,one
end end end
  
function dist(i,a,b)
  if (MISSING(a) and MISSING(b)) then
    return nil
  end
  if i.put == sym1 then
    return a==b and 0 or 1
  end
  -- so now we are about numbers
  if a == b then
    return 0
  end
  if     MISSING(a) then
         b = norm(i, b)
         a = b > 0.5 and 0 or 1
  elseif MISSING(b) then
         a = norm(i, a)
    
         b = b > 0.5 and 0 or 1
  else   a = norm(i, a)
         b = norm(i, b)
  end
  return (a-b)^2
end 
  
----------------------------------------------------
function row0(x,y)
  x = x and x or {}
  y = y and y or {}
  id = id + 1
  return {id=id, x=x, y=y}
end
----------------------------------------------------
function sp0()
  return {abouts={}, _rows={}, n=0, dists={}}
end

function sp1(i,row)
  local once=false
  for pos,item in ipairs(row) do
    if not MISSING(item) then
      once=true
      if not i.abouts[pos] then
	local tmp = tonumber(item)
	i.abouts[pos] = tmp and num0() or sym0()
	i.abouts[pos].pos = pos
      end
      local about = i.abouts[pos]
      local put   = about.put
      put(about, item)
  end end
  if once then
    i.n = i.n + 1
    push(i._rows, row)
  end
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

function furthest(i, row1, best, bt, out)
  best = best and best or -1
  bt   = bt   and bt   or gt
  out = row1
  for row2 in items(i._rows) do
    print(row1.id, row2.id)
    local d = dists(i,row1,row2)
    print(">",d,best)
    if bt(d,best) then
      best,out = d,row2
  end end
  return out
end

function closest(i, row1)
  return furthest(i, row1, 1e32, lt)
end
  
---------------------------------------------------
function twin0()
  return {x=sp0(), y=sp0()}
end

function twinx1(i,row) sp1(i.x,row.x) end
function twiny1(i,row) sp1(i.y,row.y) end
---------------------------------------------------
function def( txt, get, better)
  return {txt=txt, get=get, better=better}
end

function from(lo,hi)
  return function () return lo + (hi - lo)*r() end
end

function decs(m,twin)
  local i = row0()
  for j,f in ipairs(m.x) do i.x[j] = f.get() end
  if twin then twinx1(twin,i) end
  return i
end

function objs(i,m,twin)
  if #i.y == 0 then
    for j,f in ipairs(m.y) do i.y[j] = f.get(i.x) end
  end
  if twin then twiny1(twin,i) end
  return i
end

function model1()
  local function ok(x) return true end
  local function f1(x) return x[1]^2 end
  local function f2(x) return (x[2] + x[3])^2 end
  return {
    ok = ok,
    x  = { def("age",            from(0,120)),
	   def("showSize",       from(1,12)),
	   def("height",         from(0,120)) },
    y  = { def("lifeExpectancy", f1, gt),
	   def("weight",         f2, lt) }
  }
end

function __model1(n,model)
  n     = n and n or 10
  model = model and model or model1
  local twin = twin0()
  rseed()
  local all = {}
  local m = model()
  for _ = 1,n do
    local i = decs(m,twin)
    i = objs(i,m,twin)
    push(all, i)
    print(i)
  end
  print(twin.y.abouts[2])
  return twin,all
end

function x__model2()
  local twin,all = __model1(10)
  print("T>",twin.x.abouts[2])
  print("A>",all[1])
  print("F>",furthest(twin.x, all[1]))
end
----------------------------------------------
if arg and arg[1] then
  if arg[1]:sub(1,2) == "__" then
    print(loadstring( arg[1] .. '()')()) 
  else
    tests()
  end
  rogue()
end

