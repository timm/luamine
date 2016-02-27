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
  return o
end

function Space:add(t)
  for _,h in pairs(self.all) do h:add( t[h.pos] ) end
end

function Space:header(t)
  self.spec= t
  local c=Chars
  for pos,name in ipairs(t) do
    -- make num or sym?
    local nump = found(name, c.nump)
    local h    = nump and num0()    or sym0()
    h:has{name = name, pos=pos}
    -- store in nums or syms?
    local what = nump and self.nums or self.syms
    add(what,     h)
    -- store everywhere else that might like it
    add(self.all, h)
    if found(name, c.more ) then add(self.more,  h) end
    if found(name, c.less ) then add(self.less,  h) end
    if found(name, c.klass) then add(self.klass, h) end
  end
  return self
end

function Space:discretize()
  for _,num in pairs(self.nums) do
    local get=function (row) return row.x[num.pos] end
    num.bins =split0():has{get=get}:div(self._rows)
    for i,range in ipairs(num.bins) do
      print(i,range:say())
    end
  end
  return self
end

