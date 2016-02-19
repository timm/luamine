require "lib"

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
  assert(implode(t)=="{aa,bb,cc,dd}")
end

function _lines(t)
  io.input("../data/weather.csv")
  t={}
  for line in lines(" *","#.*") do
    add(t,len(line))
  end
  assert(last(t) == 19, "! 19")
  t={}
  for i = 1,25 do add(t,i) end
  assert(implode(t) == implode(reverse(reverse(t))))
end

ok{_test1,_test2, _maths,
  _lists,_string,_lines}


Emp=Object:new()
function emp0(t) return new(
    Emp,t,
    {name='tim',
     age= 23,
     jobs={}})
end

print(emp0{name='jane',
	   jobs={'manager',
		 'accountant',
	         'engineer',
	         'plumber',
	         'banker'}})





one = emp0()
two = emp0()
assert(one.jobs ~= two.jobs)
