require "lib"
require "rand"

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

ok{_rand}
rogue()