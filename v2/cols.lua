require "lib"

Some = Object:new()
function some0(o)
  o      = object0(o or Some)
  o.max  = 256
  o._kept = {}
  o.n    = 0
  return o
end

Log = Object:new()
function log0(o)
  o      = object0(o or Log)
  o.name = ""
  o.pass = "[\\?]"
  o.n    = 0
  o.some = some0()
   return o
end

Sym = Log:new()
function sym0(o)
  o        = log0(o or Sym)
  o.counts = {}
  o.mode   = nil
  o.most   = 0
   return o
end

Num = Log:new()
function num0(o)
  o = log0(o or Num)
  o.up = -1*10^32
  o.lo = 10^32
  o.mu = 0
  o.m2 = 0
  return o
end

Logs = Object:new()
function logs0(o)
  o = object0(o or Logs)
  o.has  = {}
  o.some = some0()
  return o
end

-- Some --------------------------------
function Some:keep(x)
  self.n  = self.n + 1
  local k = #self._kept
  if     k < self.max     then add(self._kept,x) 
  elseif r() < k / self.n then self._kept[round(r()*k)]= x
  end 
  return x
end

function Some:copy(x)
  local o=self:shallowCopy(x)
  o._kept = deepcopy(self._kept)
  return o
end
     
-- Log  --------------------------------
function Log:adds(t)
  for _,x in pairs(t) do self:add(x) end
  return self
end

function Log:add(x)
  if x ~= nil then
    if x ~= self.ignore then
      self.n = self.n + 1
      self:add1(x)
      self.some:keep(x)
  end end 
  return x
end 

function Sym:add1(x)
  local old = self.counts[x]
  local new = (old == nil and 0 or old) + 1
  self.counts[x] = new
  if new > self.most then
    self.mode, self.most = x,new
  end end

function Sym:copy()
  return self:shallowCopy():has{
    some   = self.some:copy(),
    counts = deepcopy(self.counts)}
end

function Sym:entropy()
  local e = 0
  for _,f in pairs(self.counts) do
    if f > 0 then
      local p = f/self.n
      e = e - p*log2(p)
    end end
  return e
end

function Num:copy()
  return self:shallowCopy(): has{
    some = self.some:copy()}
end

function Num:add1(x)
  if x > self.up then self.up = x end
  if x < self.lo then self.lo = x end
  local delta = x - self.mu
  self.mu     = self.mu + delta / self.n
  self.m2     = self.m2 + delta * (x - self.mu)
end

function Num:sd()
  return self.n <= 1 and 0 or (self.m2/(self.n - 1))^0.5
end

--[[
Warning, this sub function fails when approach n=1
for very, very small numbers.
e.g. after adding 1000 values of s where s= r^300 and 
r is a random 0 < r < 1, then on substraction
from 1000 back to 1, sd becomes Nan at n=1. that said,
for numbers even slightly bigger, that problem goes away
(e.g. for s=r^250 there is no such problem).
--]]

function Num:sub(x)
  self._kept      = some0()
  self.lo,self.up = 10^32,-10^32
  self.n      = self.n - 1
  local delta = x - self.mu
  self.mu     = self.mu - delta/self.n
  self.m2     = self.m2 - delta*(x - self.mu)
end 

-- Logs --------------------------------
-- function Logs:header(t)
--   c = Nsv:new()
--   for _,one in ipairs(t) do
--     what = c:has(x,"nump") and Num or Sym
--     add(self.has, what{name=what})
-- end end

function Logs:add(t)
  self.some:keep(t)
  for i,one in ipairs(self.has) do
    one.add(t[i])
end end

function Logs:copy()
  return self:shallowCopy():has{
    some = some0(),
    has  = map(function (x) return x:copy() end,
	       self.has)
    }
end

  
