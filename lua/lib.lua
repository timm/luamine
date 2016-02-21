--[[ 
Lua is a "batteries not included" language that does
arrive, off the shelf, with numerous large and
intricate libraries.

Some people prefer Python since it arrives with
those large libraries. Other people prefer Lua since
it doesn't.

Every Lua progarmmer has their own little library of
tricks that contains all their common tricks for the
"batteries not included" in standard Lua. 

Share and enjoy!
--]]

-- Number stuff -----------------------

function round(x)
  return math.floor(x + 0.5)
end

function r3(x) return rn(x,3) end

function rn(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) 
          / math.pow(10,precision)
end

function gt(a,b) return a > b end
function lt(a,b) return a < b end

function max(t) return min(t,-10^32, gt) end
  
function min(t, out, better)
  out    = out or 10^32
  better = better or lt
  for _,x in pairs(t) do
    if better(x,out) then out = x end end
  return out
end

function near(one,two,n)
  n = n or 0.01
  diff = two - one
  if diff < 0 then diff=-1*diff end
  return diff < n
end

-- Table stuff ------------------------
add = table.insert

function first(t) return t[ 1] end
function last(t)  return t[#t] end
function empty(t) return t == nil or #t ==0 end

function sort(t,f)
  local lt = function (a,b) return a < b end
  f= f or lt
  table.sort(t,f) 
  return t
end

function oo(t,s)
  s = s or ">"
  for i,x in ipairs(t) do print(s,i,"["..tostring(x).."]") end
end

function items(t)
  local i,max=0,#t
  return function ()
    if i< max then
      i = i + 1
      return t[i]
end end end

function member(x,t)
  for y in items(t) do
    if x== y then return true end end
  return false
end

function map(f, t)
  local out = {}
  for i,v in pairs(t) do
    out[i] = f(v)
  end
  return out
end

function sub(t, first, last)
  last = last or #t
  local out = {}
  for i = first,last do
    out[#out + 1] = t[i]
  end
  return out
end

do
  _tostring = tostring  
  local lineWidth = 8000
  
  local function toStringSimple(t)
    -- for when the indexes are all numeric
    local out,sep,lines="","{",1
    for _,y in ipairs(t) do
      out = out..sep..tostring(y) 
      sep = " "
      if #out > lines*lineWidth then
	lines = lines+1
	sep = "\n "
    end end
    return out..'}'
  end
  
  function tostring(t)
    -- for arbitary stuff
    if type(t) ~= 'table' then
      return _tostring(t) 
    else
      local out,sep,lines="{",":",1
      local allNums,empty=true,true
      for x,y in pairs(t) do
	empty   = False
	allNums = allNums and type(x) == 'number'
	if string.sub(x,1,1) ~= "_" -- skip 'private' stuff
	then
	  out = out..sep..x.." "..tostring(y) 
	  sep = " :"
	  if #out > lines*lineWidth then 
	    lines = lines+1
	    sep = "\n  :"
      end end end
      if empty then
        return "{}" 
      elseif allNums then
        return toStringSimple(t)
      else
        return out..'}'
  end end end
  str = tostring
end
  
function reverse(t)
  for i=1, math.floor(#t / 2) do
    t[i], t[#t - i + 1] = t[#t - i + 1], t[i]
  end
  return t
end


-- String stuff --------------------
function len(x)
  return string.len(x==nil and "" or x) end

function found(x,pat)
  return string.find(x,pat) ~= nil end

function lastchar(s)
  return string.sub(s, -1, -1) end

function explode(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t,i = {},1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

-- OO stuff --------------------
Object={}


function Object:new(o)
   o = o or {} 
   setmetatable(o,self)  
   self.__index = self
   return o
end

function Object:has(t)
  if t then
    for k,v in pairs(t) do
      self[k] = v
    end end
  return self
end

function Object:copy0(t)
  return self:new():has(self):has(t)
end

function Object:copy(t)
  error("Should be implemented by subclass")
end

function object0(t)
  return t:new()
end


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


-- Meta stuff -------------------------
function same(x) return x end

function rogue(x) 
  local builtin = { "true","math","package","table","coroutine",
       "os","io","bit32","string","arg","debug","_VERSION","_G"}
  io.write "-- Globals: "
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then  
       if not member(k, builtin) then 
         io.write(" ",k) end end end
  print  ""
end
 
-- Test engine stuff -----------------------
do
  local y,n = 0,0
  local function report() 
    print(string.format(
              ":pass %s :fail %s :percentPass %s%%",
              y,n,round(100*y/(0.001+y+n))))
    rogue() end
  local function test(s,x) 
    print("# test:", s) 
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

-- File stuff ------------------------

function lines(white,comment)
  -- kill white space, join comma-ending files
  -- to next line, skip empty lines
  -- has to precluded with io.input(file)
  return function()  
    local pre, line = "", io.read()
    while line ~= nil do
      line = line:gsub(white,""):gsub(comment,"")
      if line ~= "" then
	    if lastchar(line) == "," then
	      pre  = pre .. line
      else
	      line =  pre .. line
	      pre  = ""
	      return line
    end end
    line = io.read()
    end
    if len(pre) > 0 then return pre end
end end