require "lines"

function _lines()
  io.input("../data/weather.csv")
  local tmp
  for n,cells in lines() do
    tmp = cells
  end
  print(tmp)
  assert(type(tmp.x[2]) == 'number')
end

function _xys()
  io.input("../data/maxwell.csv") -- 100 records
  for n,xy in lines() do
    print(n,xy)
  end
end

function _xys2()
  local n=1
  io.input("../data/maxwellBig.csv") -- 10MB
  for _,xy in lines() do
    n = n + 1
  end
  print(n)
end
  
ok{_xys2}
	
