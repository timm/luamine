require "nsv"
require "cols"

Fun=Object:new()
function fun0(o)
  o               = object0(o or Fun)
  o.name          = ""
  o._rows          = {}
  o.klass         = {}
  o.spec          = {}
  o.x             = {}
  o.y             = {}
  o.xnums,o.ynums = {}, {}
  o.xsyns,o.ysyms = {}, {}
  o.more, o.less  = {}, {}
  return o
end

Row=Object:new()
function row0(o)
  o = object0(o or Row)
  o.x, o.y = {},{}
  return o
end

function Row:copy()
  return row0():has{x=deepcopy(self.x),
		    y=deepcopy(self.y)}
end

function Fun:add(xy)
   add(self._rows, xy)
   self:add1(xy.x, self.x)
   self:add1(xy.y, self.y)
end

function Fun:add1(data,meta) 
  for i,h in ipairs(meta) do
    --h = meta[i]
    h:add(data[i]) 
end end 

function Fun:header(nsv,xy)
  self.spec = xy
  self:header1(nsv, xy.x, self.x, true)  
  self:header1(nsv, xy.y, self.y, false)
  return self
end

function Fun:header1(nsv,t,out,indep)
  for pos,name in ipairs(t) do
    local nump = nsv:char(name,"nump")
    local h    = nump and num0() or sym0()
    h:has{name=name}
    add(out,h)
    h.pos = pos
    if indep then
      if nump then add(self.xnums,h) else add(self.xsyms,h) end
    else  
      if nump then add(self.ynums,h) else add(self.ysyms,h) end
      if nsv:char(name, "more")  then add(self.more,  h) end
      if nsv:char(name, "less")  then add(self.less,  h) end
      if nsv:char(name, "klass") then add(self.klass, h) end 
end end end

function Fun:clone()
  -- clones are babies with the same properties, but
  -- not the same data, as their parent(s). if they
  -- meet the same data as their parent(s) they will
  -- turn into something different.
  return fun0():has{name=name}:header(nsv0(),self.spec)
end

function Fun:import(file)
  local nsv = nsv0():has{file=file} 
  for datap,xy in nsv:rows() do
    if datap  then
	self:add(xy)
      else
	self:header(nsv, xy)
  end end
  return self
end


