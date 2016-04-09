require "tools"
require "sample"
require "dists"

function grid0() return {
    bins    = 16,
    tooMuch = 1.05,
    t       = nil,
    xy      = rowx,
    enough  = 100,
    east=nil,west=nil,c=nil,
    firsts= {}, cells = {}, values={}, pos={} 
    }
end
----------------------------------------------
local function gridNew(east, west, inits, g)
  dot('.')
  local b4  = copy(inits)
  g.east, g.west = east, west
  g.c            = dist(east, west, g.t, g.xy)
  g.values       = {}
  g.pos          = {}
  g.cells        = {}
  for i=1,g.bins do
    g.cells[i] = {}
    for j = 1,g.bins do
      g.cells[i][j] = {} end end
  for row in places(inits) do
    grid1(row,g)
  end   
end
----------------------------------------------
local function bin(x,g)
  x = math.floor( x / ((g.c + 0.00001)/g.bins) )
  return max(0, min( g.bins - 1, x ))
end
----------------------------------------------
function grid1(row, g)
  g = g or grid0()
  if g.first == nil then
    g.first = row
  elseif g.second == nil then
    g.second = row
    gridNew(g.first, g.second,
	    {g.first, g.second}, g)
  else
    local a = dist(g.east, row, g.t, g.xy)
    local b = dist(g.west, row, g.t, g.xy)
    local c = g.c
    local tooMuch = c*g.tooMuch
    if 0 < tooMuch and tooMuch < a
    then
      gridNew(g.east, row, g.values, g)
      return grid1(row, g)
    elseif 0 < tooMuch and tooMuch < b
    then
      gridNew(row, g.west, g.values, g)
      return grid1(row,g)
    end
    g.values[ #g.values + 1] = row
    local x = (a^2 + c^2 - b^2) / (2*c + 0.000001)
    x = x^2 > a^2 and a or x
    local y = (a^2 - x^2)^0.5
    local binx,biny = bin(x,g), bin(y,g)
    print{ binx = binx, biny = biny }
    local tmp = g.cells[ binx ][ biny ]
    tmp[#tmp+1] = row
    g.pos[ row.id ] = {x=x, y=y,  binx=binx,
		       biny=biny, a=a, b=b} 
  end
  return g
end

if arg[1] == "--grid" then
  local n = 100
  local cache,grid,t = {},grid0()
  for _,names,row in xys() do
    t = sample1(row,t,names)
    grid.t = t
    cache[ #cache + 1 ] = row
    if #cache == n then
      for row in shuffled(cache) do
	grid = grid1(row,grid)
      end
      cache = {}
    end
  end
  for row in shuffled(cache) do
    grid = grid1(row,grid)
  end
end

