require "cols"


function _some()
  local some =some0():has{max=8}
  local some1 =some0()
  print("check",some1._kept ~= some._kept)
  rseed()
  for _ = 1,1000000 do
    some:keep(r())
  end
  assert(str(map(r3,sort(some._kept))) ==
	 "{0.013 0.033 0.079 0.111 0.375 0.397 0.817 0.995}")
end

function _ent()
  assert( r3(sym0():adds{"a","a","a","b","b","b"}:entropy())==1 )
  assert( r3(sym0():adds{"a","a","b"}:entropy())==0.918 )
end

_ent()
os.exit()

function _syms()
  rseed()
  local some = some0():has{name="asdas",max=10}
  local sym  = sym0():has{name="asdas"}
  local words=[[To be or not to be that is the question]] 
  for _,c in pairs(explode(words)) do
    some:keep(c)
    sym:add(c)
  end
  
  assert(sym.counts["be"] == 2,"! 2")
  local num = num0():has{name="aaa"}
   for _,n in pairs{1,2,3,4,5,6} do
    num:add(n)
  end
   assert(r3(num:sd())==1.871)
  local num1=num:copy()
  for i=1,1000 do num1:add(r()^3) end
  assert(r3(num1:sd())==0.4)
  local tmp = num0():adds{1,2,3,4,5,6}:sd()*0.1
  assert(r3(tmp)==0.187)
  local t,r0,r1={},{},{}
  local num = num0()
  local m = 1000
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
    spit(i,50)
      --print("\n",i)
      --print{downs[i].n,    ups[i].n }
      --print(map(r5, {downs[i].mu,    ups[i].mu }))
      -- print(map(r5, {downs[i]:sd(), ups[i]:sd()}))
      assert(r3(downs[i].mu) == r3(ups[i].mu),tostring(i))
      assert(r3(downs[i]:sd()) == r3(ups[i]:sd()),tostring(i))
      assert(r3(downs[i].n)  == r3(ups[i].n),tostring(i))
  end
  print("")
end 


ok{_some,_syms}
