require "lib/maths"
require "lib/sym"
require "lib/num"
require "lib/tables"
require "lib/rand"
require "lib/unittests"
require "lib/tostring"

function same(x)  return x end

function dot(x) io.write(x); io.flush() end

if arg[1] == "--tools" then
  print(ent(sym0{"a","a","a","b","b"}))
  
  local up,n = {},num0()
  local t = map({1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20} ,
		function (x) return x*10 end )
  assert(t[1] == 10)
  for i,x in ipairs(t) do
    up[i] = sd(num1(x,n))
  end
  for j,x in ipairs(reverse(t)) do
    if j < #t then
      assert(sd(unnum(x,n)) == up[#t-j])
  end end
  rogue()
end
