require "nsv"

function _nsv(f,tmp,i)
  i=0
  f= f or 'data/weather.csv'
  n = Nsv:new()
  n.file=f
  tprint(n)
  for row in  n:rows() do 
    tmp = row
  end
  local n = tmp[#tmp]
  assert(type(n) == "number")
  assert(n == 39479)
end

_nsv('data/maxwell.csv')
