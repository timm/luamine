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
  o.x, o.y = {},{}
  o._of, o._ranges = nil,nil
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
  local row= row0():has {_of=self,x=xy.x, y= xy.y}
  add(self._rows, row)
  row._ranges = row0():has {_of=self,x={},y={}}
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


function Fun:discretize1(what,xy)
  local ranges = {}
  for _,num in pairs(what.nums) do
    local get=function (row) return row[xy][num.pos] end
    num.bins =split0():has{get=get}:div(self._rows)
    for i,range in ipairs(num.bins) do
      for _,row in pairs(range._rows) do
	row._ranges[xy][num.pos] = range --- backpointers
      end
      add(ranges,range)
    end
  end
  -- add backpointers discretes
  for _,sym in pairs(what.syms) do
    local tmp = {}
    for k,_ in pairs(sym.counts) do tmp[k] = {} end
    local get=function (row) return row[xy][sym.pos] end
    for _,row in pairs(self._rows) do
      add(tmp[get(row)], row)
    end
    for val,rows in pairs(tmp) do
      range = range0():has{id=sym.txt, lo=val, up=val, n=#ranges,
			   _rows=rows, score=sym:copy()}
      add(ranges,range)
    end
  end
  self[xy]._ranges = ranges
  print(#ranges)
  for _,range in ipairs(ranges) do
    print(range)
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

  
