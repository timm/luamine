require "fun"

function _fun(f, d)
  f= f or '../data/maxwell.csv'
  d= Fun:new{f=f}
  d:import(f)
  print(1)
  local d1= d:clone()
  print(d.x)
  print(2)
  -- d:close()
  --print(#d.rows); print(d.x[1]); print(d.y[1])
end

_fun() 