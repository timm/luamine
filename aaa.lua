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

r = math.random

function rseed(seed)
  math.randomseed(seed and seed or 1)
end

function round(x)
  return math.floor(x + 0.5)
end

function r3(x) return rn(x,3) end

function rn(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) 
          / math.pow(10,precision)
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

function o(t,s)
  s = s or ">"
  for i,x in ipairs(t) do print(s,i,"["..x.."]") end
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
  for i,v in ipairs(t) do
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

function tstring(t) 
    local out,sep="{",":"
    for xx,yy in pairs(t) do
      if type(yy) ~= 'function' then
        if string.sub(xx,1,1) ~= "_" then
            out = out..sep..xx.." "..yy 
          sep = " :"
    end end end  
    return out..'}'
end  

function tprint(t) print(tstring(t)) end

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

function lastchar(str)
  return string.sub(str, -1, -1) end

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

function implode(t, sep)
  sep = sep and sep or "{"
  local str = ""
  for i,x in ipairs(t) do
     str = str..sep..x
     sep= ","
  end
  return str..'}'
end

-- OO stuff --------------------
Object={}

function Object:s()
  return tstring(self)
end

function Object:new(o)
   o = o or {} 
   setmetatable(o,self)  
   self.__index = self
   self.__tostring =  o.s
   return o
end

function Object:copy()
   local o = {}
   setmetatable(o,self)
   self.__index = self
   for x,y in pairs(self) do o[x] = y end
   return o
end

-- Meta stuff -------------------------
function same(x) return x end

function rogue(x) 
  local builtin = { "true","math","package","table","coroutine",
       "os","io","bit32","string","arg","debug","_VERSION","_G"}
  for k,v in pairs( _G ) do
    if type(v) ~= 'function' then  
       if not member(k, builtin) then 
         print(":globals",k) end end end end

-- Test engine stuff -----------------------
do
  local y,n = 0,0
  local function report() 
    print(string.format(
              ":pass %s :fail %s :percentPass %s%%",
              y,n,math.floor(y/(0.001+y+n))))
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
    if empty(t) then report() else tests(t) end end
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