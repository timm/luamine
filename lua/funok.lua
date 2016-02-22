require "fun"

function _fun(f, d0,d1,h2)
  f= f or '../data/maxwell.csv'
  d0= fun0():has{f=f}
  d0:import(f)
  local d1= d0:copy()
  print(d1.spec.y[1])
  assert(#d0.rows[1].x == 26)
  for _,xy in pairs(d0.rows) do
    -- print(xy.x[1])
    d1:add(xy)
  end
  
  print("d1 rows",#d1.rows)
  -- for i,xy in pairs(d.rows) do  print(last(xy.x)) end
  for i,h1 in pairs(d0.xnums) do
    print(d1.xnums[i])
    h2 = d1.xnums[i]
    assert(h1.name   == h2.name)
    assert(h1 == h2)
    assert(r3(h1.sd) == r3(h2.sd))
  end
end

print(20000)
_fun() 