
local function member(x,t)
  for _,y in pairs(t) do
    if x== y then return true end end
  return false
end

function args(settings,ignore, updates)
  updates = updates or arg
  ignore = ignore or {}
  local i = 1
  while updates[i] ~= nil  do
    local flag = updates[i]
    local b4   = #flag
    flag = flag:gsub("^[-]+","")
    if not member(flag,ignore) then
      if settings[flag] == nil then
        error("unknown flag '" .. flag .. "'")
      else
        if b4 - #flag == 2 then
          settings[flag] = true
        elseif b4 - #flag == 1 then
          local a1 = updates[i+1]
          local a2 = tonumber(a1)
          settings[flag] = a2  or a1
          i = i + 1
        end end end
    i = i + 1
  end
  return settings
end

if arg[1] == "--args" then
  require "tprint"
  print(args({a=1,c=false,kkk=22},{"args"}))
end
