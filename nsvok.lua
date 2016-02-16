require "nsv"

function _nsv(f,tmp,i,n,tmp)
  i=0
  f= f or 'data/weather.csv'
  n = Nsv:new{file=f}
  for datap,row in  n:rows() do 
    tmp=row
    tprint(row.x) 
  end 
  local n = tmp.x[2]
  assert(type(n) == "number")
  assert(n == 71)
end

_nsv('data/weather.csv')

rogue()
