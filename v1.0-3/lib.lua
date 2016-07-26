function max(a,b) return a > b and a or b end
function min(a,b) return a < b and a or b end
function abs(x)   return x >= 0 and x or -1*x end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function dot(x) io.write(x); io.flush() end

function any(t)
  local pos =  math.floor(0.5 + r() * #t)
  return t[ min(#t, pos) ]
end

function sub(t, first, last)
  last = last or #t
  local out = {}
  if last < first then last = first end
  for i = first,last do
    out[#out+1] = t[i]
  end
  return out
end

function same(x) return x end
-------------------------------------------------------
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

-------------------------------------------------------
function map(t,f)
  if t then
    for i,v in pairs(t) do f(v)
end end end

function map2(t,i,f)
  if t then
    for i,v in pairs(t) do f(i,v) end
  end
  return i
end

function collect(t,f)
  local out={}
  if t then  
    for i,v in pairs(t) do out[i] = f(v) end end
  return out
end 

function copy(t)
  return collect(t,same)
end

function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false
end

function f3(x) return string.format('%.3f',x) end
function f5(x) return string.format('%.5f',x) end
------------------------------------------------------
function args(settings,ignore, updates)
  updates = updates or arg
  ignore = ignore or {}
  local i = 1
  while updates[i] ~= nil  do
    local flag = updates[i]
    local b4   = #flag
    flag = flag:gsub("^[-]+","")
    if not member(flag,ignore) then
      if settings[flag] == nil then
        error("unknown flag '" .. flag .. "'")
      else
        if b4 - #flag == 2 then
          settings[flag] = true
        elseif b4 - #flag == 1 then
          local a1 = updates[i+1]
          local a2 = tonumber(a1)
          settings[flag] = a2  or a1
          i = i + 1
        end end end
    i = i + 1
  end
  return settings
end

function _args()
  if arg[1] == "--args" then
    print(args({a=1,c=false,kkk=22},{"args"})) end
end

-------------------------------------------------------
function rogue()
  local tmp={}
  local builtin ={ "The","jit", "bit", "true","math",
		  "package","table","coroutine",
		  "os","io","bit32","string","arg",
		  "debug","_VERSION","_G"}
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then
      if not member(k, builtin) then
	table.insert(tmp,k) end end end
  table.sort(tmp)
  if #tmp > 0 then
    print("-- Globals: ")
    for i,v in pairs(tmp) do
      print("    ",i,v)
end end end
-------------------------------------------------------
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

local function keys(t)
  local ks={}
  for k,_ in pairs(t) do ks[#ks+1] = k end
  table.sort(ks)
  local i = 0
  return function ()
   if i < #ks then
      i = i + 1
      return ks[i],t[ks[i]] end end
end

local function eman(x)
  for k,v in pairs(_G) do
    if v==x then return k end
end end

function tostring(t,seen)
  if type(t) == 'function' then return "FUNC(".. (eman(t) or "") ..")" end
  if type(t) ~= 'table'    then return _tostring(t) end
  seen = seen or {}
  if seen[t] then return "..." end
  seen[t] = t
  local out,sep= {'{'},""
  if stringkeys(t) then
    for k,v in keys(t) do
      if k:sub(1,1) ~= "_" then
	for _,v in pairs{sep,k,"=",tostring(v,seen)} do
	  out[#out+1] =v
	end
	sep=", "
      end
    end
  else
    for _,item in pairs(t) do
      for _,v in pairs{sep,k,"",tostring(item,seen)} do
	  out[#out+1] =v
      end
      sep=", "
  end end
  out[#out+1] = "}"
  return table.concat(out)
end