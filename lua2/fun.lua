require "cols"
require "space"
  
Fun=Object:new()
function fun0(o)
  o        = object0(o or Fun)
  o.x, o.y = space0(), space0()
  o.x._of  = self
  o.y._of  = self
  o._ranges = {}
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
  self:discretizeNums( "x" )
  self:discretizeNums( "y" )
  self:discretizeSyms( "x" )
  self:discretizeSyms( "y" )
  return self
end

function Fun:discretizeNums(xy)
  for _,col in pairs(self[xy].nums) do
    local get = function (row)
                  return row[xy][col.pos]
                end
    self:record(xy,
      split0():has{get=get}:div(self._rows,col))
end end

-- this sucks. when do i score?
function Fun:discretizeSyms(xy)
  for _,col in pairs(self[xy].syms) do
    local tmp, nth = {},0
    for k,_ in pairs(col.counts) do tmp[k] = {} end
    local get=function (row) return row[xy][col.pos] end
    for _,row in pairs(self._rows) do
      add(tmp[get(row)], row)
    end
    for val,rows in pairs(tmp) do
      nth = nth + 1
      range = range0():has{col=col, o.range=nth,
			   lo=val, up=val, 
			   _rows=rows}
      self:record(xy,{range})
    end end
end

function Fun:record(xy,ranges)
  for _,range in pairs(ranges) do
    self._ranges[range.id] = range
    for _,row in pairs(range._rows) do
      row._ranges[xy][range.col.pos] = range --- backpointers
    end
end end

function Fun:import(file)
  self.txt = file
  io.input(file)
  for n,xy in lines() do
    if n==1 then self:header(xy) else self:add(xy) end
  end
  return self
end

