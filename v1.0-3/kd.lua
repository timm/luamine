require "sample"
require "abcd"

do
  -----------------------------------------------------
  function nb0() return {
      m=2,
      k=1,
      enough = 20}
  end
  ----------------------------------------------------- 
  function likes(row, t, m, k, funnyFudgeFactor)
    local prior = (#t.rows  + k) / funnyFudgeFactor
    local like  = math.log(prior)
    for i,col in pairs(t.columns.x) do
      local x, inc = row.x[i]
      if x ~= t.ignore then
	if numcol(col) then
	  like= like + math.log(normpdf(x,col.log))
	else
	  local f = col.log.counts[x] or 0
	  like= like +
	        math.log((f + m*prior) / (#t.rows + m)) 
    end end end
    return like
  end
  -----------------------------------------------------    
  local function predict(row,t,m,k,h)
    local max = -10 ^ 32
    for h1,t1 in pairs(t.subs) do
      local l = likes(row, t1, m, k,
		      #t.rows + k * t.h)
      if l > max then
	max, h = l, h1
    end end
    return h
  end 
  -----------------------------------------------------    
  function nb(opts)
    local opts, abcd = opts or nb0(), abcd0()
    local t
    print("#", opts)
    for i,names,row in xys() do
      if i > opts.enough then
	local mode = t.columns.y[1].log.mode
	local want = row.y[1]
	local got  = predict(row,t, opts.m,opts.k, mode)
	abcd1(want, got, abcd)
      end
      t = sample1(row,t,names)
      
    end
    return abcd
  end
end

if arg[1] == "--nb" then
  printabcd(nb( args(nb0(),{"nb"})))
end
