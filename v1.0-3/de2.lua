-- i = self
-- xx0(items), xx0() creates new "xx", initilize with items
-- xx1(i, item) : increatement "i" of type "xx" with item

The={}
The.all= {seed    = 10013,
	  missing = "_",
	  id      = 0,
	  builtin = { "The","jit", "bit", "true","math",
		      "package","table","coroutine",
		      "os","io","bit32","string","arg",
		      "debug","_VERSION","_G"}}

function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false
end

function eman(x)
  for k,v in pairs(_G) do
    if v==x then return k end
end end
 
do
  local y,n = 0,0
 
  function rogue()
    local tmp={}
    for k,v in pairs( _G ) do
      if type(v) ~= 'function' then
	if not member(k, The.all.builtin) then
	  table.insert(tmp,k) end end end
    table.sort(tmp)
    print("-- Globals: ",tmp)
  end
  local function report()
    print(string.format(
          ":PASS %s :FAIL %s :percentPASS %s%%",
    y,n,math.floor(0.5 + 100*y/(0.001+y+n))))
    end
  local function test(s,x)
    print("\n-------------------------------------")
    print("-- test:", s,eman(x))
    y = y + 1
    local passed,err = pcall(x)
    if not passed then
       n = n + 1
       print("Failure: ".. err) end end
  local function tests(t)
    for s,x in pairs(t) do test(s,x) end end
  function ok(t)
    if   not t then report()
    else tests(t);report() end end
end

----------------------------------------------------


function same(z) return z end

function map(t,f)
  local out = {}
  if t ~= nil then
    for i,v in pairs(t) do out[i] = f(v)
  end end
  return out
end

function copy(t) return map(t,same) end

function deepcopy(t)
  return type(t)=="table" and map(t,deepcopy) or t
end

function with(t1,t2)
  t1 = deepcopy(t1)
  for k,v in pairs(t2) do
    assert(t1[k],"unknown key: "..k)
    t1[k]=v
  end
  return t1
end

function fcreate(fs)
  return assert(
    loadstring(
      "return function (x) return " .. fs.." end"))()
end

function _copy()
  local t1 = {"aa","bb","cc",dd={kk=3,ll=4}}
  local t2 = deepcopy(t1)
  t2[1]="ee"
  t2.dd.kk=30
  assert(t1[1] ~= "ee")
  assert(t1.dd.kk ~= 30)
end

push = table.insert

function pushs(t,t1)
  map(t1, function(x) push(t,x) end)
  return t
end

function sub(t, first, last)
  last = last or #t
  local out = {}
  if last < first then last = first end
  for i = first,last do
    push(out, t[i])
  end
  return out
end

function sort(t,fn)
  fn = fn and fn or lt
  table.sort(t,fn)
  return t
end

function _sort()
  local t = {20,10,20,5}
  t = sort(t)
  assert(t[1] <= t[#t])
end

function items(t)
  local i=0
  return function ()
    if t then
      i = i + 1
      if i <= #t then return t[i] end end end
end

function _items()
  local a={}
  for x in items{10,20,30} do
    push(a,x) end
  assert(a[1] == 10 and a[2]==20 and a[3] == 30)
  local b= pushs({}, {10,20,30})
  assert(b[1] == 10 and b[2]==20 and b[3] == 30)
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

function _keys()
  local tmp, t = {}, {bb=1,aa=2,cc=3}
  for k,v in keys(t) do
    push(tmp,{k,v})
  end
  assert(tmp[1][1] == "aa" and tmp[1][2]==2)
end

function weaktable()
  return setmetatable({}, { __mode = 'v' })
end

function dot(x) io.write(x); io.flush() end

function gt( a,b) return a > b end
function lt( a,b) return a < b end
function max(a,b) return a > b and a or b end
function min(a,b) return a < b and a or b end

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
    seed = n and n or seed0
  end
  function r()
    return park_miller_randomizer()
  end
end

function any(t)
  local pos =  math.floor(0.5 + r() * #t)
  return t[ min(#t, pos) ]
end

function _r()
  local n=5
  rseed(n)
  local a,b = {},{}
  for i=1,n do push(a,r()) end
  rseed(n)
  for i=1,n do push(b,r()) end
  a = sort(a,lt)
  b = sort(b,lt)
  assert(a[1] == b[1] and a[#a] == b[#b])
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
    if type(t) == 'function' then return "FUNC(".. (eman(t) or "") ..")" end
    if type(t) ~= 'table'    then return _tostring(t) end
    seen = seen and seen or {}
    if seen[t] then return "..." end
    seen[t] = t
     local out,sep= {'{'},""
    if stringkeys(t) then
      for k,v in keys(t) do
	if k:sub(1,1) ~= "_" then
	  pushs(out,{sep,k,"=",tostring(v,seen)})
	  sep=", "
      end end
    else
      for item in items(t) do
	pushs(out, {sep, tostring(item,seen)})
	sep=", "
    end end
    push(out,"}")
    return table.concat(out)
  end
end

-- do
--   _tostring = tostring
--   local function is_t(x)      return type(x) == "table"  end
--   local function is_s(x)      return type(x) == "string" end
--   local function is_n(x)      return type(x) == "number" end
--   local function is_hidden(x) return is_s(x) and x:sub(1,1) == "_" end
--   function all_numericKeys(t)
--     for key,_ in pairs(t) do
--       if not is_n(key) then return false end
--     end
--     return true
--   end
--   -------------------------------
--   local function tostring(t,spacing,seen,out)
--     if not is_t(t) then
--       push(out, spacing .. _tostring(t) )
--     else
--       if seen[t] then
-- 	push(out, "..")
--       else
-- 	seen[t] = t
-- 	if all_numericKeys(t) then
-- 	  push(out, spacing .. _tostring(t))
-- 	else
-- 	  for k,v in keys(t) do
-- 	    if not is_hidden(k) then
-- 	      print("K>",k)
-- 	      push(out, spacing .. _tostring(k) .. "\t ".. (not is_t(v) and _tostring(v) or ""))
-- 	      if is_t(v) then
-- 		tostring(v, spacing .. '|   ',seen,out)
--     end end end end end end end
--   -------------------------------
--   function showt(t)
--     local out = {}
--     showt1(t, "", {}, out)
--     print(out)
--     return table.concat(out,"\n")
--   end 
-- end

-- table.print= showt

function _show()
  local t1 = {kk=22,_ll=341,bb=31,cc={d44={ee={ff=2,gg={1,2,3,4,5}}}}}
  t1.a = t1
  assert(tostring{1,2,3,3}        == "{1, 2, 3, 3}")
  assert(tostring{aa=1,bb=2,cc=3} == "{aa=1, bb=2, cc=3}")
  assert(tostring{3,2,1, t1}      == "{3, 2, 1, {a=..., bb=31, cc={d44={ee={ff=2, gg={1, 2, 3, 4, 5}}}}, kk=22}}")
 end

-------------------------------------------------------

function num0(some)
  local i= {mu= 0, n= 0, m2= 0, up= -1e32, lo= 1e32, put=num1}
  for one in items(some) do
    num1(i,one) end
  return i
end

function num1(i, one)
  if one ~= The.all.missing then
    i.n  = i.n + 1
    if one < i.lo then i.lo = one end
    if one > i.up then i.up = one end
    local delta = one - i.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (one - i.mu)
end end

function unnum(i, one)
  i.n  = i.n - 1
  local delta = one - i.mu
  i.mu = i.mu - delta/i.n
  i.m2 = i.m2 - delta*(one - i.mu) -- untrustworthy for very small n and z
  return t
end

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
  if one ~= The.all.missing then
    i.n  = i.n + 1
    local old = t.counts[one]
    local new = old and old + 1 or 1
    t.counts[one] = new
    if new > t.most then
      t.most, t.mode = new,one
end end end

function dist(i,a,b)
  if (a == The.all.missing and b == The.all.missing) then
    return nil
  end
  if i.put == sym1 then
    return a==b and 0 or 1
  end
  -- so now we are about numbers
  if a == b then
    return 0
  end
  if     a == The.all.missing then
         b = norm(i, b)
         a = b > 0.5 and 0 or 1
  elseif b == The.all.missing then
         a = norm(i, a)
         b = b > 0.5 and 0 or 1
  else   a = norm(i, a)
         b = norm(i, b)
  end
  return (a-b)^2
end

----------------------------------------------------
function xx(z)   return z.x end
function yy(z)   return z.y end

function row0(x,y)
  The.all.id = The.all.id + 1
  x = x and x or {}
  y = y and y or {}
  return {x=x, y=y, id=The.all.id}
end
----------------------------------------------------
function tub0(get)
  The.all.id = The.all.id + 1
  return {abouts={}, _rows={}, n=0,
	  get=get or same, id = The.all.id,
	  dists={}, subs={}}
end

function tub1(i,row)
  local once=false
  for pos,item in ipairs( i.get(row) ) do
    if item ~= The.all.missing then
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
  row1=i.get(row1)
  row2=i.get(row2)
  local d = i.dists[k]
  if not d then
    local all,n = 0, 0.0000001
    for j=1,#row1 do
      local inc = dist(i.abouts[j],row1[j],row2[j])
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
    if row1.id ~= row2.id then
      local d = dists(i,row1,row2)
      if bt(d,best) then
  best,out = d,row2
  end end end
  return out
end

function closest(i, row1)
  return furthest(i, row1, 1e32, lt)
end
--------------------------------------------------
The.bins0 =  {
    enough     = nil,
    cohen      = 0.3,
    maxBins    = 10,
    minBin     = 2,
    small      = nil,
    verbose    = false,
    trivial    = 1.05}

function bins0() return copy(The.bins0) end

do
  local function bins1(i, nums, all, ranges,lvl)
    if i.verbose then
      print(string.rep('|.. ',lvl),nums)
    end
    local cut,lo,hi
    local n = #nums
    local start, stop = nums[1], nums[n]
    if stop - start >= i.small then
      local lhs, rhs = num0(), copy(all)
      local score, score1 = sd(rhs), nil
      local new, old
      for j,new in ipairs(nums) do
  num1( lhs, new)
  unnum(rhs, new)
  if new  ~= old            and
     lhs.n >= i.enough      and
     rhs.n >= i.enough      and
     new - start >= i.small
  then
    -- dont trust unnum for small "n". only if n > i.enough
     score1 = lhs.n/n*sd(lhs) + rhs.n/n*sd(rhs)
     if score1*i.trivial < score
     then
       cut, score, lo, hi = j, score1, copy(lhs), copy(rhs)
     end
  end
  old = new
      end
    end
    if cut then -- divide the ranage
      bins1(i, sub(nums,1,cut-1), lo, ranges,lvl+1)
      bins1(i, sub(nums,cut),     hi, ranges,lvl+1)
    else        -- we've found a leaf range
      push(ranges, {id=#ranges+1, lo=start, up=stop, items={}})
  end end

  function bins(t,i)
    i          = i or bins0()
    i.maxBins = 7
    i.cohen   = 0.3
    local nums = sort(t)
    local all  = num0(t)
    i.enough   = i.enough or max(i.minBin, all.n/i.maxBins)
    i.small    = i.small  or sd(all) * i.cohen
    print{min=i.minBin, n=all.n, maxBins=i.maxBins, enough=i.enough}
    local ranges = {}
    bins1(i, nums, all, ranges,1)
    return ranges
  end
end

function _bins()
  local t={}
  for i=1,1000 do
    pushs(t,{r()^2, r()^4}) --, r()^6})
  end
  for x in items(bins(t)) do
    print(x)
  end
end

--------------------------------------------------
function range0(lo,hi,items, score)
  return {lo=lo, hi=hi,
    score = score or 1,
    items=items}
end

function range(x,row,ranges)
  local near, min = ranges[1], 1e32
  for r in items(ranges) do
    local lo, up = r.lo, r.up
    if lo <= x and x <= up then
      return r
    end
    local d1 = math.abs(val - lo)
    local d2 = math.abs(val - up)
    if d1 < near then near,min = r, d1 end
    if d2 < near then near,min = r, d2 end
  end
  return r
end


--- XXX cluster here
The.cluster0= {enough=0.5,
	       min=20,
	       deltac=0.1,
	       verbose=true,
	       tooStrange=20,
	       tiny=0.05}

function cluster0(sp)
  return with(The.cluster0,
	      {sp=sp, get=sp.get,ranges={},
	       better = function (x,y) return false end,
	       verbose=true})			  
end

function cluster(tub,i)
  i = i and i or cluster0(tub)
  local tiny = #tub._rows ^ i.enough
  tiny = tiny > i.min and tiny or i.min
  ---------------------------
  local function project(here,one,c,west,east)
    local a = dists(here,one,west)
    local b = dists(here,one,east)
    local x = (a*a + c*c - b*b) / (2*c + 0.000001)
    x = x^2 <= a^2 and x or a
    local y = (a^2 - x^2)^0.5
    return x,y
  end
  ---------------------------------
  function split(here, items)
    local z    = any(items)
    local east = furthest(here, z)
    local west = furthest(here, east)
    local c    = dists(here, west, east)
    here.east=east; here.west=west; here.c=c
    local deltac = i.deltac * c
    local xs   = {}
    local cache= weaktable()
    for _,item in ipairs(items) do
      local x,y = project(here,item,c,west,east)
      if x > c  + deltac or x < -1 * deltac then
        here.strange = here.strange + 1
      end
      cache[item] = x
      push(xs,x)
    end
    local ranges = bins(xs)
    for item,x in ipairs(cache) do
      local r   = range(x,item,ranges)
      push(r.items, item)
    end
    return west,east, ranges
  end
  ------------------------------
  local function prune(noeast,nowest, branches)
    local oddp =  number %2 == 1
    local k,l,m =1, #branches, math.floor(#branches/2)
    if noeast and nowest then
      return {}
    elseif noeast then
      l = oddp and m+1 or m
    elseif nowest then
      k = oddp and m+1 or m
    end
    return sub(branches,k,l)
  end
  ------------------------------
  local function recurse(items, lvl)
    if i.verbose then print(string.rep("-- ",lvl), #items) end
    local here = tub0(tub.get)
    for item in items do tub1(here,item) end
    here.lvl     = lvl
    here.strange = 0
    if #items >= tiny then
      local west,east,subs = split(here, items)
      here.subs = prune(i.better(west,east),
              i.better(east,west),
              subs)
      for sub in items(here.subs) do
	recurse(sub.items,lvl+1)
  end end end
  return recurse(sp._rows, lvl)
end
-------------------------------------------------
function twin0()
  return {x=tub0(xx), y=tub0(yy)}
end

function twinx1(i,row) tub1(i.x,row) end
function twiny1(i,row) tub1(i.y,row) end
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
    x  = { def("age",             from(0,120)),
     def("showSize",        from(1,12)),
     def("height",          from(0,120)),
     def("1age",            from(0,120)),
     def("1showSize",       from(1,12)),
     def("1height",         from(0,120)),
     def("2age",            from(0,120)),
     def("2showSize",       from(1,12)),
     def("2height",         from(0,120))
         },
    y  = { def("lifeExpectancy", f1, gt),
     def("weight",         f2, lt) }
  }
end

function _model1(n,model)
     n     = n and n or 10000
     model = model and model or model1
     rseed()
     local twin = twin0()
     local all  = {}
     local m    = model()
     for j = 1,n do
       local i = decs(m,twin)
       i = objs(i,m,twin)
       push(all, i)
     end
     return twin,all
end

function _model2()
  local twin,all = _model1()
  print("T1>", twin.y.abouts[1])
  print("T2>", twin.y.abouts[2])
  print("R>", #twin.x._rows)
  print("A>", all[1].y)
  print("F>", furthest(twin.y, all[1]).y)
  print("C>", closest( twin.y, all[1]).y)
end
----------------------------------------------

The.cliffs={dull= 0.147} --small  0.33,  # medium   0.474 # large

do
  local function runs(t)
    local i,old = 1,t[1]
    return function ()
      if i <= #t then
	local buffer = {}
	while old == t[i] do
	  buffer[ #buffer+1 ] = t[i]
	  i = i + 1
	end
	old = t[i]
	return #buffer , t[i-1]
  end end end

  function cliffsDelta(lst1,lst2)
    local m, n = #lst1, #lst2
    lst2 = sort(lst2)
    local j,more,less=1,0,0
    for repeats,x in runs(sort(lst1)) do
      while lst2[j] and lst2[j] <  x do 
	j = j+1
      end
      more = more + (j-1)*repeats
      while lst2[j] and lst2[j] == x do
	j = j+1
      end
      less = less + (n - j +1)*repeats
    end
    local d= (more - less) / (m*n)
    return math.abs(d)  --> The.cliffs.dull
  end
end

function time(f,n)
  n=n and n or 1
  local m = n
  local t1=os.clock()
  local out
  while m > 0 do m=m - 1; out=f(); end
  return (os.clock() - t1)/n,out
end

do
  local function cdSlow(t1,t2)
    local n,gt,lt=0,0,0
    for x in items(t1) do
      for y in items(t2) do
	n=n+1
	if x > y then gt = gt + 1 end
	if x < y then lt = lt + 1 end
    end end
    return math.abs(gt-lt)/n
  end

  local function worker(pre,t1,t2)
      local n1,a=time(function () cliffsDelta(t1,t2) end,10)
      local n2,b=time(function () cdSlow(t1,t2)      end,10)
      print(pre,{fast=n1,slow=n2,delta=n2/n1})
      assert(a == b)
  end
  
  function _cliffs()
    worker("simple",{1,2,3,4,5},{1,8,9,10,11})
    for i=1,4 do
      local t1,t2={},{}
      for j=1,10^i do
	push(t1, r()^2  )
	push(t2, r()^0.5)
      end
      worker(10^i,t1,t2)
  end end
end
---------------------------------------------
do
  local backup = deepcopy(The)
  function reset(seed)
    The = deepcopy(backup)
    rseed(seed and seed or The.all.seed)
    return The
  end
  reset()
end

if arg and arg[1] then
  local i = 0
  while i <= #arg do
    i = i + 1
    if arg[i] == "--tests" then
      ok{_sort,   _items, _keys,
	 _r,      _show,
	 _model1, _model2}
      rogue()
    elseif arg[i] == "--test" then
      ok{loadstring("_" .. arg[i+1] .. "()")}
      rogue()
    elseif arg[i] == "--with" then
      -- eg --with cluster0 bin=01
      local settings= fcreate("{" .. arg[i+2] .. "}")
      The[ arg[i+1] ] = with(The[ arg[i+1] ], settings())
      i = i + 2
      rseed()
  end end
end
