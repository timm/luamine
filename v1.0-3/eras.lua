function args(settings,updates)
  updates = updates or arg
  local i = 1
  while updates[i] ~= nil  do
    local flag = updates[i]:gsub("^-","")
    local a1   = updates[i+1]
    local a2   = tonumber(a1)
    settings[flag] = a2 and a2 or a1
    i = i + 2
  end
  return settings
end

function shuffled( t )
  local i = #t + 1
  return function()
    if i >= 2 then
      i = i - 1
      local j = math.random(i)
      t[i], t[j] = t[j], t[i]
      return t[i]
end end end

options = args{era=100,seed=1}
math.randomseed(options.seed)
row, cache, line = 1, {}, io.read()

while line ~= nil do
  if row==1 then
    print(row)
  else
    cache[ #cache + 1 ] = line
    if #cache >= options.era then
      for txt in shuffled(cache) do
	print("1",txt)
      end
      cache = {}
    end
  end
  row, line = row + 1 io.read()
end

for txt in shuffled(cache) do
  print("2",txt)
end

