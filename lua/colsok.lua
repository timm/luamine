require "cols"

function _some()
  local some = Some:new{max=8}
  rseed(1)
  for _ = 1,1000000 do
    some:keep(r())
  end
  assert(implode(map(r3,sort(some.kept))) == 
        "{0.14,0.196,0.404,0.57,0.601,0.634,0.659,0.821}")
end

function _syms()
  rseed(1)
  local some=Some:new{name="asdas",max=10}
  local sym=Sym:new{name="asdas"}
  local words=[[To be or not to be that is the question]] 
  for _,c in pairs(explode(words)) do
    some:keep(c)
    sym:add(c)
  end
  assert(sym.counts["be"] == 2,"! 2")
  local num = Num:new{name="aaa"}
  for _,n in pairs{1,2,3,4,5,6} do
    num:add(n)
  end 
  assert(r3(num.sd)==1.871)
  local num1=num:copy()
  for i=1,1000 do num1:add(r()^3) end
  assert(r3(num1.sd)==0.394)
  tmp = Num:new():adds{1,2,3,4,5,6}.sd*0.1
  assert(r3(tmp)==0.187)
  local t,r0,r1={},{},{}
  local num = Num:new()
  local m = 100
  for i = 1,m do add(t,r()) end
  local ups,downs={},{}
  for i,n in ipairs(t) do
    num:add(n)
    ups[i] = num:copy() 
  end
  for i,n in ipairs(reverse(t)) do
    local j = m - i
    if j >= 1 then
      num:sub(n)
      downs[j] = num:copy()
  end end 
  for i = 1,#ups-1 do  
    assert(r3(downs[i].mu) == r3(ups[i].mu))
    assert(r3(downs[i].sd) == r3(ups[i].sd))
    assert(r3(downs[i].n) == r3(ups[i].n))
end end

ok{_some,_syms}
