local function items(t)
  local i=0
  return function ()
    if t then
      i = i + 1
      if i <= #t then return t[i] end end end
end
