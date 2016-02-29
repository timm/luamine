require "fun"


function _fun1()
  local f1 = fun0()
  f1:import('../data/weather.csv')
  assert(f1.x.all[1].mode == "sunny")
  assert(f1.y.all[1].n == 14)
  f2 = f1:clone()
  
  for _,row in pairs(f1._rows) do
    f2:add(row)
  end
  assert(f1.x.all[1] ~= f2.x.all[1])
  assert(r3(f1.x.nums[1]:sd()) == r3(f2.x.nums[1]:sd()))
  assert(f1.x.syms[1].name == f2.x.syms[1].name)
end

function _fun2()
  local f1 = fun0()
  f1:import('../data/weather.csv')
  print(f1.y.all)
  f1:discretize()
  print(f1._rows[1]._ranges.x[1])
end

-- ok{_fun1}

_fun2()
