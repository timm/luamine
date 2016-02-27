require "cols"
require "space"

Fun=Object:new()
function fun0(o)
  o        = object0(o or Fun)
  o.x, o.y = space0(), space0()
  o.x._of  = self
  o.y._of  = self
  o.source = ""
  o._rows  = {} -- a list of Rows
  return o
end

Row=Object:new()
function row0(o)
  o = object0(o or Row)
  o.x, o.y, o._of = {},{},nil
  return o
end

function Row:copy()
  return row0():has{_of = self._fun}
end

function Fun:header(xy)
  self.x:header(xy.x)
  self.y:header(xy.y)
  return self
end

function Fun:add(xy)
  self.x:add(xy.x)
  self.y:add(xy.y)
  add(self._rows,
      row0():has{_of=self,x=xy.x, y= xy.y})
  return self
end

function Fun:clone()
  out = fun0():has{source=source}
  return out:header{x = self.x.spec, y=self.y.spec}
end

function Fun:import(file)
  self.source = file
  io.input(file)
  for n,xy in lines() do
    if n==1 then self:header(xy) else self:add(xy) end
  end
  return self
end

  
