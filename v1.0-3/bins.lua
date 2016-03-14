require "tools"


function split0() return {
    enough     = nil,
    cohen      = 0.2,
    maxBins    = 16,
    minBin     = 4,
    small      = nil,
    verbose    = false,
    trivial    = 1.05}
end 

do
  local pretty = {"a","b","c","d","e","f","g","h","i","j","k","l","m",
		  "n","o","p","q","r","s","t","u","v","w","x","y","z"}
  
  local function bins1(i, nums, all, ranges,lvl)
    if i.verbose then
      print(string.rep('|.. ',lvl),nums)
    end
    local cut,lo,hi
    local n = #nums
    local start, stop = nums[1], nums[n]
    if stop - start >= i.small then
      local lhs, rhs = num0(), copy(all)
      local score, score1 = sd(rhs), nil
      local new, old
      for j,new in ipairs(nums) do
	num1( new, lhs)
	unnum(new, rhs)
	score1 = lhs.n/n*sd(lhs) + rhs.n/n*sd(rhs) 
	if new  ~= old            and
	   lhs.n >= i.enough      and
	   rhs.n >= i.enough      and
	   new - start >= i.small and
	   score1*i.trivial < score
	then
	  cut, score, lo, hi = j, score1, copy(lhs), copy(rhs)
	end 
	old = new
      end
    end
    if cut then -- divide the ranage
      bins1(i, sub(nums,1,cut-1), lo, ranges,lvl+1)
      bins1(i, sub(nums,cut),     hi, ranges,lvl+1)
    else        -- we've found a leaf range
      ranges[#ranges+1] = {id=pretty[#ranges+1],
			   lo=start, also=nil,
			   n=#nums,  up=stop}
  end end

  function bins(t,i)
    i          = i or split0()
    local nums = sort(t)
    local all  = num0(t)
    i.enough   = i.enough or max(i.minBin, all.n/i.maxBins)
    i.small    = i.small  or sd(all) * i.cohen
    local ranges = {} 
    bins1(i, nums, all, ranges,1)
    return ranges
  end
end
