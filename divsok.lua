require "divs"
require "cols"
require "fun"

function _divs(n,s,d)
  n = {}
  for i = 1,1000 do add(n,r()^2) end
  s = Split:new{get=same,maxBins=4}
  for i,range in pairs(s:div(n)) do
    print(i,range.lo,range.up) end
  f= Fun:new()
  f:import('data/maxwell.csv')
  print(#f.nums)
  for _,num in ipairs(f.nums) do
    get=function (row) return row.x[num.pos] end
    s=Split:new{get=get}:div(f.rows)
    
    print(num.pos,num.name,r3(num.mu)) end
end

_divs()


