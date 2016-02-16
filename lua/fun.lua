require "nsv"
require "cols"

Fun=Object:new{
  name="",     rows   = {},
  x      = {}, y      = {},  
  spec   = {}, more   = {}, less   = {},
  klass  = {},  
  xnums  = {}, ynums  = {},
  xsyms  = {}, ysyms  = {}
}
Row=Object:new{x={},y={}}

function Fun:add(data,meta) 
  for i = 1,#meta do 
    meta[i]:add(data[i]) end
end 

function Fun:header(nsv,t,out)  
  for pos,x in ipairs(t) do
    nump = nsv:has(x,"nump")
    h    = nump and Num:new{name=x} or Sym:new{name=x}
    add(out,h)
    h.pos = pos
    if out == self.x then
      if nump then add(self.xnums,h) else add(self.xsyms,h) end
    else  
      if nump then add(self.ynums,h) else add(self.ysyms,h) end
      if nsv:has(x, "more")  then add(self.more,  h) end
      if nsv:has(x, "less")  then add(self.less,  h) end
      if nsv:has(x, "klass") then add(self.klass, h) end 
end end end

function Fun:import(file) 
  local nsv = Nsv:new{file=file} 
  for datap,xy in nsv:rows() do   
    if datap then
      add(self.rows,xy)
      self:add(xy.x,self.x)
      self:add(xy.y,self.y)
    else
      self.spec = xy   
      self:header(nsv,xy.x,self.x)  
      self:header(nsv,xy.y,self.y)  
  end end 
  return self
end
