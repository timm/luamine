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
  f:import('../data/weather.csv')
  print(#f.nums)
  os.exit()
  for _,num in ipairs(f.xnums) do
    print(num.pos,num.name,r3(num.mu)) 
    local get=function (row) return row.x[num.pos] end
    print(1)
    s=Split:new{get=get,cohen=0.1}:div(f.rows)
    print(2)
    print("length",#s,#f.rows)
    for j,range in pairs(s) do
      print(">>",range.id,r3(range.lo),r3(range.up),r3(range.n)) end
    os.exit()
  end
end

_divs()


