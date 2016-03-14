require "xy"
require "bins"

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

if arg[1] == "--binMaxwell0" then
  local opts = split0()
  opts.verbose = true
  opts.trivial = 0
  opts.cohen   = 0
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
