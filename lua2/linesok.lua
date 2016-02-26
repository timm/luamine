require "lines"

function _lines()
  io.input("../data/weather.csv")
  local tmp
  for n,cells in lines() do
    tmp = cells
    --print(n,cells)
  end
  assert(type(tmp[2]) == 'number')
end

function _xys()
  local i = 0
  io.input("../data/weather.csv")
  for n,xy in xys() do
    i = i + 1 --print(n,xy)
  end
end
  
ok{_lines}
	
