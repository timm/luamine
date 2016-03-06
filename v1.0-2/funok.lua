require "fun"

function _fun1()
  local f1 = fun0()
  f1:import('../data/weather.csv')
  assert(f1.x.all[1].mode == "sunny")
  assert(f1.y.all[1].n == 14)
  local f2 = f1:clone()
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
  f1:discretize()
  for _,row in pairs(f1._rows) do
    local ranges = row._ranges
    assert(#row.x > 0)
    assert(#row.y > 0)
    assert(#ranges.x > 0)
    assert(#ranges.y > 0)  
    for i=1,#row.x do
      --print("X>>", row.x[i], ranges.x[i]._rows)
      assert(row.x[i] <= ranges.x[i].up)
      assert(row.x[i] >= ranges.x[i].lo)
    end
    for i=1,#row.y do
      --print("Y>>", row.y[i], ranges.y[i]._rows) 
      assert(row.y[i] <= ranges.y[i].up)
      assert(row.y[i] >= ranges.y[i].lo)
    end
end end 
    
--  local rang = last(f1._rows)._ranges.x[2]._rows --._ranges.x[1])
--  local val= last(f1._rows).x[2]
--  print("rang",val,rang)
-- end

ok{_fun1,_fun2}

