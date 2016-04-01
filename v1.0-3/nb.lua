require "sample"

do
  -----------------------------------------------------
  function nb0() return {
      m = 2,
      k = 1,
      ignore = "_",
      enough = 10}
  end
  -----------------------------------------------------    
  local function predict(row,opt,t,sizes,nh,most,out)
    for h,columns in pairs(t.subs) do
      local size  = columns.y[1].n
      local prior = (size + opt.k) / (n + k*nh)
      local tmp   = math.log(prior)
      for j,col in pairs(columns.x) do
	local inc,x = 0,row.x[j]
	if x ~= opt.ignore then
	  if col.put == num1 then
	    tmp = tmp + log( normpdf(x,col) )
	  else
	    local f = (col.counts[x] or 0) + (opt.m * prior)
	    tmp  = tmp + log( f/(size + opt.m) )
      end end end
      if tmp > most then most,out = tmp,h end
    end
    return out
  end
  -----------------------------------------------------    
  function nb(n)
    opt = opt or nb0()
    local log = abcd0()
    local t 
    for i,names,row in xys() do
      if i > opt.enough then
	local actual    = row.y[1]
	local predicted = predict(row,opt,t,i,#t.subs,-1)
	abcd1(actual, predicted,log)
      end
      t = sample1(row,t,names)
    end
    t = sample1(row,t)
    return t
  end
end

if arg[1] == "--nb" thne

end
