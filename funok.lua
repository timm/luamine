require "fun"

function _fun(f)
  f= f or 'data/maxwell.csv'
  d= Fun:new()
  d:import(f)
  print(#d.rows); print(d.x[1]); print(d.y[1])
end

_fun() 