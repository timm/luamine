require "divs"
require "cols"
require "fun"

function _divs(n,s,d)
  n = {}
  for i = 1,1000 do add(n,r()^2) end
  s = Split:new{get=same,maxBins=16}
  for i,range in pairs(s:div(n)) do
    print(i,r3(range.lo),r3(range.up),range.n) end
  f= Fun:new()
  f:import('../data/maxwell.csv')
  for _,num in ipairs(f.xnums) do
      local get=function (row) return row.x[num.pos] end
      s=Split:new{get=get,cohen=0.1}:div(f.rows)
      if #s>0 then
        print("")
        tprint{what=num.name, pos=num.pos, mu= r3(num.mu),sd= r3(num:sd()), lo = num.lo, up=num.up} 
        for j,range in pairs(s) do
          print(">>",range.id,r3(range.lo),r3(range.up),r3(range.score.n)) 
  end end end
end

_divs()


