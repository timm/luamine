require "cols"
require "lines"
require "magic"
require "divs"

Space=Object:new()
function space0(o)
  o = object0(o or Space)
  o.nums, o.syms = {},{}
  o.less, o.more = {},{}
  o.klass        = {}
  o.spec         = {}
  o.all          = {}
  o._ranges      = {}
  o.txt          = ""
  o._of          = nil
  return o
end

function Space:add(t)
  for _,h in pairs(self.all) do h:add( t[h.pos] ) end
end

function Space:header(t)
  self.spec= t
  local c=Chars
  for pos,txt in ipairs(t) do
    -- make num or sym?
    local nump = found(txt, c.nump)
    local h    = nump and num0()    or sym0()
    h:has{txt = txt, pos=pos, _rows={}}
    -- store in nums or syms?
    local what = nump and self.nums or self.syms
    add(what,     h)
    -- store everywhere else that might like it
    add(self.all, h)
    if found(txt, c.more ) then add(self.more,  h) end
    if found(txt, c.less ) then add(self.less,  h) end
    if found(txt, c.klass) then add(self.klass, h) end
  end
  return self
end

-- have to create sapces with an xy getter

function Space:discretize(rows)
  for _,col in pairs(self.nums) do
    self:discretizeNums(col, rows) end
  for _,col in pairs(self.syms) do
    self:discretizeSyms(col, rows) end
end

function Space:discretizeNums(col,rows)
  ranges = split0():has{get= function (row)
			       return self.get(row)[col.pos]
			     end
		       }:div(rows,col) 
  self:record(ranges)
end

function Space:discretizeSyms(col, rows)
  self:collectRowsForEachValue(col,rows)
  local nth=0
  for val,rows in pairs(col._rows) do
    nth = nth + 1
    local range = range0:has{col=col, n = nth,
			     lo=val,up=val, _rows = rows}      
    self:record({range})
end end 

function Space:collectRowsForEachValue(col,rows)
  for _,row in pairs(rows) do
    local val  = self.get(row)[col.pos]
    local kept = col._rows[val]
    kept = kept==nil and {} or kept
    add(kept,row)
    col._rows[val] = kept
end end

function Space:record(ranges)
  for _,range in pairs(ranges) do
    add(self._ranges[range.col.pos], range)
    for _,row in pairs(range._rows) do
      self.get(row)[range.col.pos] = range --- backpointers
end end end

