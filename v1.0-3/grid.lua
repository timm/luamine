require "tools"
require "samples"

function grid0() return {
    bins=16,
    tooMuch=1.05,
    n=0,
    first=nil
    second=nil
    }
end

function grid1(row, t)
  t = t or grid0()
  if t.first == nil then
    t.first = row
  elseif t.second == nil then
    t.second = row
    gridReset(t.first, row,t)
    t.n = t.n + 1
  else

