require "cols"
require "space"
  
Fun=Object:new()
function fun0(o)
  o        = object0(o or Fun)
  o.x, o.y = space0(), space0()
  o.x.get  = function (row) return row.x end
  o.y.get  = function (row) return row.y end 
  o.x.put  = function (row) return row._ranges.x end
  o.y.put  = function (row) return row._ranges.y end 
  o.x._of  = self
  o.y._of  = self
  o.txt    = ""
  o._rows  = {} -- a list of Rows
  return o
end

Row=Object:new()
function row0(o)
  o = object0(o or Row)
  o.x, o.y = {},{}
  o._of= nil
  o._ranges = {x={}, y={}}
  return o
end

function Row:copy()
  return row0():has{_of = self._fun}
end

function Row:pretty()
  local show = function (range)
    if range.lo == range.up then
      return range.lo 
    else
      return range.lo .. ".." .. range.up
    end end
  out={}
  for x=1,#self.x do 
      add(out, show(self._ranges.x[x])) end
  for y=1,#self.y do
    add(out, show(self._ranges.y[y])) end
  return out
end

function Fun:header(xy)
  self.x:header(xy.x)
  self.y:header(xy.y)  
  self.x.txt = "X(" .. self.txt ..")"
  self.y.txt = "Y(" .. self.txt ..")"
  return self
end

function Fun:add(xy)
  self.x:add(xy.x)
  self.y:add(xy.y)
  local row= row0():has {_of=self,x=xy.x, y= xy.y}
  add(self._rows, row)
  row._ranges = row0():has {_of=self,x={},y={}}
  return self
end

function Fun:clone()
  local out = fun0():has{source=source}
  return out:header{x = self.x.spec, y=self.y.spec}
end

function Fun:discretize()
  self.x:discretize(self._rows)
  self.y:discretize(self._rows)
end

function Fun:pretty()
  local out={}
  add(out,
      tadds(deepcopy(self.x.spec),self.y.spec))
  for n,row in ipairs(self._rows) do
    add(out, row:pretty()) end
  return out
end



function Fun:import(file)
  self.txt = file
  io.input(file)
  for n,xy in lines() do
    if n==1 then self:header(xy) else self:add(xy) end
  end
  return self
end

