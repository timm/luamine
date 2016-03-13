require "xy"
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

function bins(t,i)
  i = i or split0()
  local nums = sort(t)
  local all  = num0(t)
  i.enough   = i.enough or max(i.minBin, all.n/i.maxBins)
  i.small    = i.small  or sd(all) * i.cohen
  local ranges = {} 
  bins1(i, nums, all, ranges,1)
  return ranges
end

function bins1(i, nums, all, ranges,lvl)
  if i.verbose then
    print(string.rep('|.. ',lvl),nums)
  end
  local cut,lo,hi
  local n = #nums
  local start, stop = nums[1], nums[n]
  if stop - start >= i.small then
    local left, right = num0(), copy(all)
    local score = sd(right)
    local new, old 
    for j,new in ipairs(nums) do
      num1( new, left)
      unnum(new, right)
      if new ~= old then
	if left.n >= i.enough and right.n >= i.enough then
	  if new - start >= i.small then
	    local maybe = left.n/n*sd(left) + right.n/n*sd(right)
	    if maybe*i.trivial < score then
	      cut, score = j, maybe
	      lo, hi     = copy(left), copy(right)
      end end end end
      old = new
    end
  end
  if cut then -- divide the ranage
    bins1(i, sub(nums,1,cut-1), lo, ranges,lvl+1)
    bins1(i, sub(nums,cut),     hi, ranges,lvl+1)
  else        -- we've found a leaf range
    ranges[#ranges+1] = {id=#ranges+1, lo=start,
			 n=#nums,       up=stop}
end end

if arg[1] == "--binWeather" then
  local opts = split0()
  opts.verbose = true
  local nums = map(xy().rows,
	            function (row) return row.x[2] end)
  local b = bins(nums, opts)
  assert(b[2].lo == 69)
  assert(b[2].up == 72)
end

if arg[1] == "--binMaxwell" then
  local opts = split0()
  opts.verbose = true
  local nums =  map(xy().rows,
			function (row) return row.x[24] end)
  local b = bins(nums, opts)
  for _,b1 in ipairs(b) do
    print(b1)
  end
end

if arg[1] == "--binMaxwell100" then
  rseed(1)
  local opts = split0()
  opts.verbose = false
  local nums = map(xy().rows,
			function (row) return row.x[24] end)
  local b = bins(nums, opts)
  for _,b1 in ipairs(b) do
    print(b1)
  end
end
