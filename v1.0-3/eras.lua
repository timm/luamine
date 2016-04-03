function args(settings,updates)
  updates = updates or arg
  local i = 1
  while updates[i] ~= nil  do
    local flag = updates[i]:gsub("^-","")
    local a1   = updates[i+1]
    local a2   = tonumber(a1)
    if settings[flag] == nil then
      error("bad flag '".. flag.."'")
    end
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
  end end
end

do 
  local options = args{era=100,seed=1}
  math.randomseed(options.seed)
  local row,cache,line = 1,{},io.read()
  ------------------------------------------
  function dump()
    for x in shuffled(cache) do print(x) end
  end
  ------------------------------------------
  while line ~= nil do
    if   row==1
    then print(line)
    else cache[ #cache + 1 ] = line
         if #cache >= options.era then
	   dump()
	   cache = {}
    end end
    row, line = row + 1, io.read()
  end
  dump()
end
