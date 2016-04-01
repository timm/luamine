require "sample"

do
  function nb0() return {
      m = 2,
      k = 1,
      ignore = "_",
      enough = 10}
  end
  local function nbtest(row,n,t)
    for k,v in pairs(row) do
      if v ~=  n.ignore then
      end
    end
  end
  local function predict(row,n,t,sizes,nh,most,out)
    for h,columns in pairs(t.subs) do
      local size  = columns.y[1].n
      local prior = (size + n.k) / (n + k*nh)
      local tmp   = prior
      for j,x in pairs(row) do
	if x ~= n.ignore then
	  local col = columns[j]
	  local inc
	  if col.put == num1 then
	    inc =  normpdf(x,col)
	  else
	    local f = (col[x] or 0) + (n.m*prior)
	    inc = f/(size + n.m)
	  end
	  tmp = tmp * inc
	end
      end
      if tmp > most then most,out = tmp,h end
    end
    return most
  end
    
  function nb(n)
    n = n or nb0()
    local log = abcd0()
    local t 
    for i,names,row in xys() do
      if i > n.enough then
	local actual    = row.y[1]
	local predicted = predict(row,n,t,i,#t.subs,-1)
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
