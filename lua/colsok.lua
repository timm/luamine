require "cols"
require "rand"

function _some()
  local some =some0{max=8}
  local some1 =some0()
  print("check",some1._kept ~= some._kept)
  rseed()
  for _ = 1,1000000 do
    some:keep(r())
  end
  assert(implode(map(r3,sort(some._kept))) ==
	 "{0.013,0.033,0.079,0.111,0.375,0.397,0.817,0.995}")
end

print(sym0())

function _syms()
  rseed()
  local some = some0{name="asdas",max=10}
  local sym  = sym0{name="asdas"}
  local words=[[To be or not to be that is the question]] 
  for _,c in pairs(explode(words)) do
    some:keep(c)
    sym:add(c)
  end
  assert(sym.counts["be"] == 2,"! 2")
  local num = num0{name="aaa"}
   for _,n in pairs{1,2,3,4,5,6} do
    num:add(n)
  end
  assert(r3(num.sd)==1.871)
  local num1=num:copy()
  for i=1,1000 do num1:add(r()^3) end
  assert(r3(num1.sd)==0.4)
  tmp = num0():adds{1,2,3,4,5,6}.sd*0.1
  assert(r3(tmp)==0.187)
  local t,r0,r1={},{},{}
  local num = num0()
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
      print("b4",num)
      print("af",downs[j])
  end end
  
  for i = 1,#ups-1 do
    print(i)
    print(r3(downs[i].mu), r3(ups[i].mu))
    assert(r3(downs[i].mu) == r3(ups[i].mu))
    print(r3(downs[i].sd), r3(ups[i].sd))
    assert(r3(downs[i].sd) == r3(ups[i].sd))
    print(r3(downs[i].n), r3(ups[i].n))
    assert(r3(downs[i].n) == r3(ups[i].n))
end end

rogue()

_some()
_syms()
-- ok{_some,_syms}
