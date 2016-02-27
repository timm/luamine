require "space"

function _space()
  local t = {
    {"name", "$age"},
    {"tim",  10},
    {"zhe",  11},
    {"zhe",  30}}
  local sp = space0()
  for _,one in pairs(t) do
    sp:add(one)
  end
  assert(sp.all[2].up == 30)
  assert(sp.all[1].counts["zhe"] == 2)
end

ok{_space}
