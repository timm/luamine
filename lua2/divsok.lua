require "divs"
require "cols"
require "fun"

function _divs1()
  local n = {}
  for i = 1,1000 do add(n,r()^2) end
  local s = split0():has{get=same,maxBins=16}
  for i,range in pairs(s:div(n)) do
    print(i,r3(range.lo),r3(range.up),range.n) end
end

function _divs2()
  local f= fun0()
  f:import('../data/maxwell100K.csv')
  for _,num in ipairs(f.x.nums) do
      local get=function (row) return row.x[num.pos] end
      local s=split0():has{get=get,cohen=0.1}:div(f._rows)
      if  #s>0 then
        print("")
        print{what=num.name, pos=num.pos,
	      mu= r3(num.mu),sd= r3(num:sd()), n=num.n,
	      lo = num.lo, up=num.up} 
        for j,range in pairs(s) do
          print(j,range:say())
  end end end
end

ok{_divs1,_divs2}


