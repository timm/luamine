require "cols"
require "lines"

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
  if #self.spec == 0
  then
    self:header(t)
  else
    for i,h in pairs(self.all) do
      h:add( t[i] ) end end
end

function Space:header(t)
  self.spec= t
  for pos,name in ipairs(t) do
    local nump = found(name, Chars.nump)
    local h    = nump and num0() or sym0()
    h:has{name = name, pos=pos}
    add(self.all, h)
    if   nump 
    then add(self.nums, h)
    else add(self.syms, h)
    end  
    if found(name, Chars.more) then
       add(self.more,  h) end
    if found(name, Chars.less) then
       add(self.kess,  h) end
    if found(name, Chars.klass) then
       add(self.klass, h) end
end end

function Space:clone()
  return space0():header{self.spect}  
end
