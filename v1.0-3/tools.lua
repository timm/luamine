require "lib/tostring"
require "lib/rand"

function gt(a,b) return a > b end
function lt(a,b) return a < b end

function log2(n) return math.log(n)/math.log(2) end

function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false
end

function sort(t,f)
  table.sort(t,f or lt)
  return t
end

function copy(t)
  out={}
  for k,v in pairs(t) do out[k] = v end
  return out
end

--- return thing 2
function push2(t, x, y, z)
  local tx = t[x]                      
  if not tx then tx={}; t[x] = tx end
  local txy = tx[y]
  if not txy then txy={}; tx[y] = txy end
  txy[#txy+1] = z
  return z
end

function ent2(t, x, y, z)
  local tx = t[x]                      
  if not tx then tx={}; t[x] = tx end
  local txy = tx[y]
  if not txy then txy=sym0(); tx[y] = txy end
  sym1(z,txy)
  return z
end
 
function rogue()
  local builtin = { "jit", "bit", "true","math",
		    "package","table","coroutine",
		    "os","io","bit32","string","arg",
		    "debug","_VERSION","_G"}
  local tmp={}
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then  
      if not member(k, builtin) then
	table.insert(tmp,k) end end end
  print("-- Globals: ",sort(tmp))
end

do
  local y,n = 0,0
  local function report() 
    print(string.format(
              ":PASS %s :FAIL %s :percentPASS %s%%",
              y,n,round(100*y/(0.001+y+n))))
    rogue() end
  local function test(s,x) 
    print("\n-------------------------------------")
    print("-- test:", s,eman(x))
    print("-------------------------------------")
    y = y + 1
    local passed,err = pcall(x) 
    if not passed then   
       n = n + 1
       print("Failure: ".. err) end end 
  local function tests(t)
    for s,x in pairs(t) do test(s,x) end end 
  function ok(t) 
    if empty(t) then report() else tests(t);report() end end
end

function reverse(t)
  for i=1, math.floor(#t / 2) do
    t[i], t[#t - i + 1] = t[#t - i + 1], t[i]
  end
  return t
end

function map(t,f)
  local out = {}
  if t ~= nil then
    for i,v in pairs(t) do
      out[i] = f(v)
    end end
  return out
end


function r3(x) return rn(x,3) end
function r5(x) return rn(x,5) end

function rn(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) 
          / math.pow(10,precision)
end

function dot(x) io.write(x); io.flush() end

function max(a,b) return a>b and a or b end
function min(a,b) return a<b and a or b end

function same(x)  return x end

function sub(t, first, last)
  last = last or #t
  local out = {}
  if last < first then last = first end
  for i = first,last do
    out[#out + 1] = t[i]
  end
  return out
end

function sym0(t)
  local tmp = {counts={}, most=0, mode=nil, n=0}
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

function ent(t)
  local e = 0
  for _,n in pairs(t.counts) do
    local p = n/t.n
    e = e - p*log2(p)
  end
  return e
end
  
function num0(t)
  local tmp = {mu=0,n=0,m2=0}
  map(t, function (z) num1(z,tmp) end)
  return tmp
end

function num1(z,t)
  t.n  = t.n + 1
  local delta = z - t.mu
  t.mu = t.mu + delta / t.n
  t.m2 = t.m2 + delta * (z - t.mu)
  return t
end

function unnum(z,t)
  t.n  = t.n - 1
  local delta = z - t.mu
  t.mu = t.mu - delta/t.n
  t.m2 = t.m2 - delta*(z - t.mu)
  return t
end

function sd(t)
  return t.n <= 1 and 0 or (t.m2/(t.n - 1))^0.5
end

if arg[1] == "--tools" then
  print(ent(sym0{"a","a","a","b","b"}))
  
  local up,n = {},num0()
  local t = map({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20} ,
		function (x) return x*10 end )
  assert(t[1] == 10)
  for i,x in ipairs(t) do
    up[i] = sd(num1(x,n))
  end
  for j,x in ipairs(reverse(t)) do
    if j < #t then
      assert(sd(unnum(x,n)) == up[#t-j])
  end end
  rogue()
end
