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
  local maker = {}
  io.input("../data/maxwell.csv")
  for n,xy in lines(true) do
    print(n,xy)
  end
end
  
_xys()
rogue()
	
