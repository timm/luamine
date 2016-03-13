require "divs"
require "cols"
require "fun"

function _divs1()
  local n = {}
  for i = 1,1000 do add(n,r()^2) end
  local s = split0():has{get=same,maxBins=16}
  local old = -10^32
  assert(#s > 0)
  for i,range in pairs(s:div(n,1)) do
    assert(range.lo > old)
    assert(range.lo <= range.up)
    -- print(i,r5(range.lo),r5(range.up),range.n)
    old = range.lo
  end
end

function _divs0(file)
  file=file or '../data/maxwell100K.csv'
  io.write(file)
  local f= fun0()
  f:import(file)
  for _,num in ipairs(f.x.nums) do
    io.write("."); io.flush()
    local get=function (row) return row.x[num.pos] end
    local ranges=split0():has{get=get,cohen=0.2}:div(f._rows,num)
    assert(#ranges > 0)
    local old = -10^32
    if  #ranges>0 then
        --print{what=num.name, pos=num.pos,
	  --    mu= r3(num.mu),sd= r3(num:sd()), n=num.n,
	    --  lo = num.lo, up=num.up}
	for n,range in ipairs(ranges) do
	  assert(range.lo > old)
	  assert(range.lo <= range.up)
	  old = range.lo
	  -- print(n,range.lo, range.up)
	end
    end
  end
  print("")
end

function _divs2() _divs0('../data/weather.csv')     end
function _divs3() _divs0('../data/maxwell.csv')     end
function _divs4() _divs0('../data/maxwell100K.csv') end

ok{_divs1,_divs2,_divs3,_divs4}

