--[[ 
Lua is a "batteries not included" language that does
arrive, off the shelf, with numerous large and
intricate libraries.

Some people prefer Python since it arrives with
those large libraries. Other people prefer Lua since
it doesn't.

Every Lua progarmmer has their own little library of
tricks that contains all their common tricks for the
"batteries not included" in standard Lua.  This
file contains by "battries". Share and enjoy!

╔═══════════════════════╗
║██████████████████████ ╚╗
║████ Full Battery █████ ║
║██████████████████████ ╔╝
╚═══════════════════════╝

--]]

require "lib/rand"
require "lib/tostring"
require "lib/oo"
require "lib/unittest"

-- Number stuff -----------------------

function log2 (n) return math.log(n,2) end

function round(x) return math.floor(x + 0.5) end

function r3(x) return rn(x,3) end
function r5(x) return rn(x,5) end

function rn(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) 
          / math.pow(10,precision)
end

function gt(a,b) return a > b end
function lt(a,b) return a < b end

function most(a,b)
  if a==nil then return b end
  if b==nil then return a end
  if a> b then return a else return b end
end

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

function spit(i,n,    a,b)
  a = a or "."
  b = b or "\n"
  n = n or 1
  io.write(i % n == 0 and b or a)
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
  for i,x in ipairs(t) do
    print(s,i,"["..tostring(x).."]") end
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
  if last < first then last = first end
  for i = first,last do
    out[#out + 1] = t[i]
  end
  return out
end
  
function reverse(t)
  for i=1, math.floor(#t / 2) do
    t[i], t[#t - i + 1] = t[#t - i + 1], t[i]
  end
  return t
end

function tadds(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

-- String stuff --------------------
function len(x)
  if type(x) == 'table' then return #x end
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

function printm(t,sep)
  sep = sep or " | "
  local widths={}
  local cols, rows = #t[1], #t
  local w = function (r,c) return #(""..t[r][c]) end
  for c=1,cols do
    for r=1,rows do
      widths[c] = most( w(r,c), widths[c]) end end
  for r=1,rows do
    local trow = {}
    for c=1,cols do
      add(trow, string.rep(" ",widths[c] - w(r,c)))
      add(trow, t[r][c])
      if c < cols then add(trow,sep) end
    end
    print(table.concat(trow))
  end
end
	      
-- Meta stuff -------------------------
function same(x) return x end

function eman(x)
  -- may be slow
  for name,y in pairs(_G) do
    if y == x then return name end
end end
 
