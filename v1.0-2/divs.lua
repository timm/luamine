require "lib"
require "cols"
--[[

A little slow for millions of rows. So for large
data sets, discretize on the first (say) 10,000 rows
then only update if you get unusuala mounts in each
bin (e.g. if a bin got X% of the data in the
original split, then update if any bin gets 
50% < X < 150% of the data.

--]]

Split=Object:new()
function split0(o)
  o            = object0(o or Split)
  o.enough     = nil
  o.get        = last
  o.cohen      = 0.2
  o.maxBins    = 8
  o.minBinSize = 4
  o.small      = nil
  o.id         = 1
  o.trivial    = 1.05
  return o
 end

do
  local n = 0
  Range=Object:new()
  function range0(o)
    o       = object0(o or Range)
    n       = n + 1
    o.id    = n
    o.col   = nil
    o.range = nil
    o.lo    = nil; o.up= nil
    o.n     = 0  ; o._of= nil
    o.score = 0
    return o
  end
end

function Range:say(  txt)
  if type(self.col) == 'string' then
    txt = self.col 
  elseif type(self.col) == 'number' then
    txt = self.col 
  else
    txt = self.txt
  end
  return{txt=txt,lo=r3(self.lo),up=r3(self.up),
	 n=r3(self.score.n)} 
end


function Split:div(t,col)
  t = sort(t, function(a,b) 
                  return self.get(a) < self.get(b) end)
  local all    = num0():adds(map(self.get,t))
  local small0 = max{self.minBinSize, all.n/self.maxBins}
  self.enough  = self.enough or small0
  self.small   = self.small  or all:sd()*self.cohen
  local ranges = {} 
  self:div1(t, col,  all, ranges)
  return ranges
end

function Split:div1(t, col, all, ranges) 
  local cut,lo,hi
  local n = #t
  local start, stop = self.get(t[1]), self.get(t[#t])
  if stop - start >= self.small then
    local left, right = num0(), all:copy()
    local score = right:sd()
    local new, old 
    for i,x in ipairs(t) do
      new = self.get(x)
      left:add(new)
      right:sub(new)
      if new ~= old then
        if left.n >= self.enough then
          if  right.n < self.enough then
	    goto rest end -- using gotos to escape deep loop
          if new - start >= self.small then
            local maybe = left.n/n*left:sd() + right.n/n*right:sd()
            if maybe*self.trivial < score then
              cut, score = i, maybe
              lo, hi     = left:copy(), right:copy()
      end end end end
      old = new
  end end 
  ::rest:: 
  if cut then -- divide the ranage
    self:div1(sub(t,1,cut), col, lo, ranges)
    self:div1(sub(t,cut+1), col, hi, ranges)
  else -- we've found a leaf range
    local range = range0():has{col=col, lo=start,
	                       up=stop, range=#ranges,
                               _rows=t, score = all:copy()}
    add(ranges, range)
end end

