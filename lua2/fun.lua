require "cols"
require "space"

Fun=Object:new()
function fun0(o)
  o        = object0(o or Fun)
  o.x, o.y = space0(), space0()
  o.x._of  = self
  o.y._of  = self
  o.txt    = ""
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
  
  self.x.txt = "X(" .. self.txt ..")"
  self.y.txt = "Y(" .. self.txt ..")"
  return self
end

function Fun:add(xy)
  self.x:add(xy.x)
  self.y:add(xy.y)
  local row= row0():has{_of=self,x=xy.x, y= xy.y}
  add(self._rows, row)
  row._ranges = row0():has(_of=self,x={},y={})
  return self
end

function Fun:clone()
  out = fun0():has{source=source}
  return out:header{x = self.x.spec, y=self.y.spec}
end

function Fun:discretize()
  self:discretize1(self.x,  "x")
  self:discretize1(self.y,  "y")
end

print("get ranges in rows working")

function Fun:discretize1(what,xy)
  print("\n==========\n",what.txt)
  for _,num in pairs(what.nums) do
    print("\n",num.txt)
    local get=function (row) return row[xy][num.pos] end
    num.bins =split0():has{get=get}:div(self._rows)
    for i,range in ipairs(num.bins) do
      for _,row in pairs(range.has) 
      print(i,range:say())
    end
  end
  return self
end

function Fun:import(file)
  self.txt = file
  io.input(file)
  for n,xy in lines() do
    if n==1 then self:header(xy) else self:add(xy) end
  end
  return self
end

  
