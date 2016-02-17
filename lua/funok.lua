require "fun"

function _fun(f, d)
  f= f or '../data/maxwell.csv'
  d= Fun:new{f=f}
  d:import(f)
  print(1)
  local d1= d:clone()
  print(#d.rows[1].x)
  for i,xy in pairs(d.rows) do  print(last(xy.x)) end
  for i,h1 in pairs(d.xnums) do
    h2 = d1.xnums[i]
    -- print(i,h1.name,h2.name,r3(h1.mu),r3(h2.mu))
  end
    -- print(xy)
    --d1.add(xy) end
    -- end
  -- d:close()
  --print(#d.rows); print(d.x[1]); print(d.y[1])
end

_fun() 