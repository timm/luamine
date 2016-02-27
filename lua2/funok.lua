require "fun"

function _fun(f)
  local f= f or '../data/maxwell.csv'
  local d0= fun0():has{f=f}
  d0:import(f)
  local d1= d0:clone()
  for _,xy in pairs(d0._rows) do
    d1:add(xy)
  end
  assert(d1.x[1]:sd() == d0.x[1]:sd())
  assert(d1.x[1]    ~= d0.x[1])
  assert(#d1._rows == #d0._rows)
  for i,h0 in pairs(d0.xnums) do
    local h1 = d1.xnums[i]
    assert(h1.name   == h0.name)
    assert(h1 ~= h0)
    assert(r3(h1:sd()) == r3(h0:sd()))
  end
end

function _fun1()
  local f = fun0()
  f:import('../data/weather.csv')
  for n,x in pairs(f.x.all) do
    print(n,x)
  end
end

ok{_fun1} 
