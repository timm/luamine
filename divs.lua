require "aaa"
require "cols"

Split=Object:new{enough=nil, get=last, cohen=  0.2, 
                 maxBins=16,
                 small =nil, id= 1,    trivial=1.05}

function Split:div(t,    all,out)
  t = sort(t, function(a,b) 
                  return self.get(a) < self.get(b) end)
  all = Num:new():adds(map(self.get,t))
  self.small  = self.small  or all.sd*self.cohen
  self.enough = self.enough or all.n/self.maxBins
  out= {} 
  self:div1(t, #t, all, out)
  return out
end

function Split:div1(t,n,all,out) 
  local cut,lo,hi
  local start, stop = self.get(t[1]), self.get(t[#t])
  local range = {id=self.id, lo=start, up=stop, n=#out,
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
    self:div1(sub(t,1,cut), n, lo, out)
    self:div1(sub(t,cut+1), n, hi, out)
  else -- we've found a leaf range
    add(out,range)
end end
  
