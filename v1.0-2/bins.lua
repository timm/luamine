require "xy"
require "tools"

function split0(get) return {
    get        = get or same,
    enough     = nil,
    get        = last,
    cohen      = 0.2,
    maxBins    = 16,
    minBinSize = 4,
    small      = nil,
    id         = 1,
    trivial    = 1.05}
end

function bins(t,i,get)
  i = i or split0(get)
  print("get",get)
  table.sort(t, function(a,b)
                  return i.get(a) < i.get(b)
                end)
  local nums   = map(i.get,t)
  local all    = num0(all)
  local small0 = max{i.minBinSize, all.n/i.maxBins}
  i.enough     = i.enough or small0
  i.small      = i.small  or sd(all) * t.cohen
  local ranges = {} 
  bins1(i, nums, all, ranges)
  return ranges
end

function bins1(i, nums, all, ranges)
  local cut,lo,hi
  local n = #t
  local start, stop = nums[1], nums[n]
  if stop - start >= i.small then
    local left, right = num0(), table.copy(all)
    local score = sd(right)
    local new, old 
    for j,new in ipairs(nums) do
      num1( new, left)
      unnum(new, right)
      if new ~= old then
	if left.n >= i.enough then
	  if  right.n >= i.enough then
	    if new - start >= i.small then
	      local maybe = left.n/n*sd(left) + right.n/n*sd(right)
	      if maybe*i.trivial < score then
		cut, score = j, maybe
		lo, hi     = table.copy(left), table.copy(right)
      end end end end end 
      old = new
  end end
  if cut then -- divide the ranage
    bins1(sub(nums,1,cut-1), lo, ranges)
    bins1(sub(nums,cut),     hi, ranges)
  else -- we've found a leaf range
    ranges[#ranges] = {id=#ranges+1, lo=start,up=stop}
end end

if arg[1] == "bins" then
  t = xy()
  print(bins(t.rows))
end
