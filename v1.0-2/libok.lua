require "lib"
require "lines"

function _test1()
  assert(1==1,"or else")
  assert(2==1,"oh dear") 
end

function _test2()
  assert(3==3,"or else")
  assert(4==3,"oh dear,again") 
end

function _maths() 
  assert(r3(9.87654321) == 9.877 , "round to 3 error")
  assert(round(3.6)==4           , "rounding error"  )
end

function _lists(t,t1,sub23)
  t={10,20,30,40}
  assert(first(t) == 10,"first error")
  assert(last(t) == 40,"first error")
  assert(empty({}),"empty error")
  t=  sort{10,1,20,2} 
  assert(t[1]==1 and t[2]==2 
         and t[3]== 10 and t[4] == 20,
        "bad sort")  
  t1={}
  for x in items{1,2,3,4,5} do
    add(t1,x) end
  assert(t1[1]==1,"one")
  assert(t1[5]==5,"five")
  assert(member(
	   22,{11,22,33}),"! member")
  local ten = function (x) return 10*x end
  t1 = map(ten,{1,2,3,4})
  assert(t1[1]==10,"! ten")
  assert(t1[4]==40,"! fourty")
  sub23 = sub({1,2,3,4,5,6,7},4,7)
  assert(sub23[4] == 7, "! seven")
  assert(min{3,4,4,5,2,1,3}== 1)
  assert(max{3,4,4,5,2,1,3}== 5)
end

function _string(t)
  assert(len("") == 0,"empty string")
  assert(len(nil) == 0,"empty string")
  assert(len("timothy") == 7,"seven")
  assert(found("tim","^t") == true, "tim")
  assert(lastchar("timm") == "m","!m")
  t= explode("aa,bb,cc,dd",",")
  assert(t[1]=="aa","! aa")
  assert(t[4]=="dd","! dd")
  assert(str(t)=="{aa bb cc dd}")
end

function _printm(      m)
  m = {{"name","age","shewize"},
       {"====","===","======="},
       {1,2,3},
       {10,20,30},
       {40,50,60}}
  printm(m)
end


function _lines(t)
  io.input("../data/weather.csv")
  t={}
  for _,line in lines(" *","#.*") do
    add(t,len(line.x))
  end
  assert(last(t) == 3, "! 3")
  t={}
  for i = 1,25 do add(t,i) end
  assert(str(t) == str(reverse(reverse(t))))
end


Person=Object:new()
 function person0(o)
   o = object0(o or Person)
   o.name="adam"
   o.dob={1,1,{1901, "ad"}}
   o.addr={ }
   return o
 end

function _oo(  p1,p2,p3)
  p1=person0()
  p2=person0()
  p1.dob[1] = 20
  assert(p1      ~= p2)
  assert(p1.addr ~= p2.addr)
  p3=p1:copy{name="tim"}
  assert(p3.dob == p1.dob)
  assert(p3.name ~= p1.name)
  assert(p3.name == "tim")
end


function _rand(repeats)
  repeats = repeats or 10^5
  local function minmax( lo,hi,tmp)
    lo = 10^32
    hi =- 1*10^32
    for i = 1,repeats do
      tmp=r()
      if tmp > hi then hi = tmp end
      if tmp < lo then lo = tmp end
    end
    return lo,hi
  end
  local function run(seed)
    rseed(seed)
    local one=r()
    local lo1,hi1 = minmax()
    local lo2,hi2 = minmax()
    assert(lo1 >= 0); assert(hi1 <= 1)
    assert(lo2 >= 0); assert(hi2 <= 1)
    
    rseed(seed)
    local two=r()
    assert(one == two)
    local lo3,hi3 = minmax()
    assert(lo3 >= 0);  assert(hi3 <= 1)
    assert(lo2 ~= lo3)
    assert(hi2 ~= hi3)
    assert(lo1 == lo3)
    assert(hi1 == hi3)
  end
  run()
  run(101)
end

ok{_test1,_test2, _maths,_lists,_string,_lines,_oo,_printm,_rand}

