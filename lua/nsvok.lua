require "nsv"

function _nsv(f,tmp,i,n,tmp)
  i=0
  f= f or '../data/weather.csv'
  n = nsv0():has{file=f}
  for datap,row in  n:rows() do
    tmp=row
    i = i + 1
    str(row.x)
    
  end 
  local n = tmp.x[2]
  print(tmp)
  assert(i == 15)
  assert(type(n) == "number")
  assert(n == 71)
end

ok{_nsv}
