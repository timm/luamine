do
  local _id = 0
  local weaktable = setmetatable({}, {__mode="k"})
  function id(x)
    local old = weaktable[x]
    if   old
    then return old
    else _id = _id + 1
         weaktable[x] = _id
         return _id
  end end
end
