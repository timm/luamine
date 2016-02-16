require "fun"


function _fun(f, d)
  f= f or 'data/maxwell.csv'
  d= Fun:new{f=f}:import(f)
  tprint(d.x)
  --print(#d.rows); print(d.x[1]); print(d.y[1])
end

_fun() 