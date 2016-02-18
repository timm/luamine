require "lib"
require "cols"

Split=Object:new{enough=nil, get=last, cohen=  0.2, 
                 maxBins=8,  minBinSize=4,
                 small =nil, id= 1,    trivial=1.05}

function Split:div(t,    all,ranges)
  t = sort(t, function(a,b) 
                  return self.get(a) < self.get(b) end)
  all         = Num:new():adds(map(self.get,t))
  local small0= max{self.minBinSize,
		    all.n/self.maxBins}
  self.enough = self.enough or small0
  self.small  = self.small  or all.sd*self.cohen
  ranges = {} 
  self:div1(t, #t, all, ranges)
  return ranges
end

function Split:div1(t, n, all, ranges) 
  local cut,lo,hi
  local start, stop = self.get(t[1]), self.get(t[#t])
  local range = {id=self.id, lo=start, up=stop, n=#ranges,
                 has=t, score = all:copy()}
  if stop - start >= self.small then 
    local l, score = Num:new(), all.sd
    local new, old 
    for i,x in ipairs(t) do
      new = self.get(x)
      l:add(new)
      all:sub(new)
      if new ~= old then
        if l.n >= self.enough then
          if  all.n < self.enough then goto rest end
          if new - start >= self.small then
            local maybe = l.n/n*l.sd + all.n/n*all.sd
            if maybe*self.trivial < score then
              cut, score = i, maybe
              lo, hi     = l:copy(), all:copy()
      end end end end
      old = new
  end end 
  ::rest::
  if cut then -- divide the ranage
    self:div1(sub(t,1,cut), n, lo, ranges)
    self:div1(sub(t,cut+1), n, hi, ranges)
  else -- we've found a leaf range
    add(ranges, range)
end end
  
