require "lib"

print(lt)
print("new",new)

Some = Object:new()
function some0(t) return fresh(Some,t,
    {max = 256,
     _kept = {},
     n = 0}) end

--[[
function Object:has(t)
  for k,v in pairs(t)
    self[k] = v
  end
  return self
end

function object0(x)
  return return x:new()
end

Log=Object:new()
function log0(o)
   o = object0(o or Log)
   o.name=""
   o.pass="[\\?]"
   o.n = 0
   o.some = some0()
   return o
end


--]]
Log = Object:new()
function log0(t) return fresh(Log,t,
     {name = "",
      pass = "[\\?]",
      n = 0,
      some = some0()}) end

Sym = Log:new()
function sym0(t) return fresh(Sym,log0(t),
    {counts = {},
     mode = nil,
     most = 0}) end

Num = Log:new()
function num0(t) return fresh(Num,log0(t), {
      up = -1*10^32,
      lo = 10^32,
      mu = 0,
      m2 = 0,
      sd = 0}) end

Logs = Object:new()
function logs0(t) return fresh(Logs,t,
    { has  = {},
      some = some0()}) end

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
  local tmp = some0(self)
  self._kept = {}
  return self
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
  new = (old == nil and 0 or old) + 1
  self.counts[x] = new
  if new > self.most then
    self.mode, self.most = x,new
  end end

function Sym:copy()
  tmp = sym0(self)
  tmp.some = self.some:copy()
  return tmp
end

function Num:copy()
  tmp = num0(self)
  tmp.some = self.some:copy()
  return tmp
end

function Num:add1(x)
  if x > self.up then self.up = x end
  if x < self.lo then self.lo = x end
  local delta = x - self.mu
  self.mu     = self.mu + delta / self.n
  self.m2     = self.m2 + delta * (x - self.mu)
  if self.n > 1 then
    self.sd = (self.m2/(self.n - 1))^0.5  
end end 

function Num:sub(x)
  self.n = self.n - 1
  local delta = x - self.mu
  self.mu = self.mu - delta/self.n
  self.m2 = self.m2 - delta*(x - self.mu)
  if self.n > 1 then
    self.sd = (self.m2/(self.n - 1))^0.5  
end end

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
