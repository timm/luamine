require "space"

function _space()
  local sp = space0():header{"name", "$age"}
  local data = {
    {"tim",  10},
    {"zhe",  11},
    {"zhe",  30}}
  for _,one in pairs(data) do
    sp:add(one)
  end
  assert(sp.all[2].up == 30)
  assert(sp.all[1].counts["zhe"] == 2)
end

ok{_space}
