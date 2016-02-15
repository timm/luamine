require "nsv"
require "cols"

Fun=Object:new{
  name="",     rows   = {},
  x      = {}, y      = {}, headers= {},
  spec   = {}, more   = {}, less   = {},
  klass  = {}, nums   = {}, syms   = {}
}
Row=Object:new{x={},y=nil}

function Fun:row(t,row)
  row=Row:new()
  for j,h in ipairs(self.x) do add(row.x,h:add(t[j])) end
  for j,h in ipairs(self.y) do add(row.y,h:add(t[j])) end
  return row
end

function Fun:header(nsv,n,x)  
  nump  = nsv:has(x,"nump")
  h     = nump and Num:new{name=x} or Sym:new{name=x} 
  add(self.headers, h) 
  if nsv:has(x, "more")  then add(self.more,  h) end
  if nsv:has(x, "less")  then add(self.less,  h) end
  if nsv:has(x, "klass") then add(self.klass, h) end
  if nump == true        then add(self.nums,  h)
                         else add(self.syms,  h) end
  if nsv:has(x, "dep") then 
    add(self.y,h)
    h.pos = {self.y, #self.y}
  else 
    add(self.x,h) 
    h.pos = {self.x, #self.x}
  end 
end

function Fun:import(file) 
  local nsv = Nsv:new{file=file} 
  for line in nsv:rows() do   
    if #self.headers == 0 then 
      self.spec = line   
      for n,x in ipairs(line) do  
       	self:header(nsv,n,x)  end
    else   
      add(self.rows, self:row(line,{}))
end end end