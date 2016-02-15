require "nsv"

Some = Object:new{max = 256,
		             kept = {},
		                n = 0}
Log = Object:new{name = "",
		  pass = "[\\?]",
                    n = 0,
                 some = Some:new()}
Sym = Log:new{ counts = {},
	               mode = nil,
	               most = 0}
Num = Log:new{     up = -1*10^32,
	                 lo = 10^32,
	                 mu = 0,
                   m2 = 0,
                   sd = 0}
Logs = Object:new{has = {},some=Some:new{}}

-- Some --------------------------------
function Some:keep(x)
  self.n  = self.n + 1
  local k = #self.kept
  if     k < self.max     then add(self.kept,x) 
  elseif r() < k / self.n then self.kept[round(r()*k)]= x
  end 
  return x
end
     
-- Log  --------------------------------
function Log:adds(t)
  for _,x in pairs(t) do
    self:add(x)
  end 
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
function Logs:header(t)
  c = nsv:new()
  for _,one in ipairs(t) do
    what = c:has(x,"nump") and Num or Sym
    add(self.has, what{name=what})
end end

function Logs:add(t)
  self.some:keep(t)
  for i,one in ipairs(self.has) do
    one.add(t[i])
end end
