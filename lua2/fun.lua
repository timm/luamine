require "cols"
require "space"

Fun=Object:new()
function fun0(o)
  o        = object0(o or Fun)
  o.x, o.y = space0(), space0()
  o.source = ""
  o._rows  = {}
  return o
end

Row=Object:new()
function row0(o)
  o = object0(o or Row)
  o.x, o.y, o._fun = {},{},nil
  return o
end

function Row:copy()
  return row0():has{_fun = self._fun}
end

function Fun:add(n,xy)
  self.x:add(xy.x)
  self.y:add(xy.y)
  if n > 1 then
    local row = row0():has{_fun=self,x=xy.x, y= xy.y}
    add(self._rows, row)
  end
end

function Fun:clone()
  out = fun0():has{name=name}
  out.x:add( self.x.spec )
  out.y:add( self.y.spec )
  return out
end

function Fun:import(file)
  self.source = file
  io.input(file)
  for n,xy in lines() do
    self:add(n,xy) end 
  return self
end


