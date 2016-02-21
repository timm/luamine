require "nsv"
require "cols"


Fun=Object:new()
function fun0(o)
  o               = object0(o or Fun)
  o.name          = ""
  o.rows          = {}
  o.klass         = {}
  o.spec          = {}
  o.x,o.y         = {}, {}
  o.xnums,o.ynums = {}, {}
  o.xsyns,o.ysyms = {}, {}
  o.more, o.less  = {}, {}
  return o
end

Row=Object:new()
function row0(o)
  o        = object0(o or Row)
  o.x, o.y = {},{}
  return o
end

function Row:copy()
  tmp=self:copy0()
  local xs,ys = {},{}
  for _,x in ipairs(self.x) do add(xs, x) end
  for _,y in ipairs(self.y) do add(ys, y) end
  return tmp:has{x=xs,y=ys}
end

function Fun:add(xy)
   add(self.rows, xy)
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
  self:header1(nsv, xy.x, self.x,true)  
  self:header1(nsv, xy.y, self.y,false)
  return self
end

function Fun:header1(nsv,t,out,indep)
  for pos,x in ipairs(t) do
    nump = nsv:has(x,"nump")
    h    = nump and num0() or sym0()
    h:has{name=x}
    add(out,h)
    h.pos = pos
    if indep then
      if nump then add(self.xnums,h) else add(self.xsyms,h) end
    else  
      if nump then add(self.ynums,h) else add(self.ysyms,h) end
      if nsv:has(x, "more")  then add(self.more,  h) end
      if nsv:has(x, "less")  then add(self.less,  h) end
      if nsv:has(x, "klass") then add(self.klass, h) end 
end end end

function Fun:copy()
  return self:copy0():header(
    nsv0(),
    deepcopy(self.spec))
end

function Fun:import(file) 
  local data = nsv0():has{file=file} 
  for datap,xy in data:rows() do   
    if datap  then
      self:add(xy)
    else
      self:header(nsv, xy)
  end end
  return self
end


