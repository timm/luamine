require "nsv"
require "cols"

function fun0() return {
  name="",     rows   = {},
  x      = {}, y      = {},  
  spec   = {}, more   = {}, less   = {},
  klass  = {},  
  xnums  = {}, ynums  = {},
  xsyms  = {}, ysyms  = {}} end

Fun=Object:new(fun0())

Row=Object:new{x={},y={}}

function Row:copy()
  local xs,ys = {}, {}
  for _,x in ipairs(self.x) do add(xs,x) end
  for _,y in ipairs(self.y) do add(ys,y) end
  return Row:new{x=x,y=y}
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
end

function Fun:header1(nsv,t,out,indep)
  for pos,x in ipairs(t) do
    nump = nsv:has(x,"nump")
    h    = nump and Num:new{name=x} or Sym:new{name=x}
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

function Fun:clone()
  local fun= Fun:new(fun0())
  fun:header( Nsv:new(),
	      self.spec:copy())
  return fun
end

function Fun:import(file) 
  local nsv = Nsv:new{file=file} 
  for datap,xy in nsv:rows() do   
    if datap  then
      self:add(xy)
    else
      self:header(nsv, xy)
  end end
  return self
end


