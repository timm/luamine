require "sample"
require "abcd"

do
  -----------------------------------------------------
  function nb0() return {
      m=2,
      n=1,
      enough = 5}
  end
  ----------------------------------------------------- 
  function likes(row, t, m, k, funnyFudgeFactor)
    local prior = (#t.rows  + k) / funnyFudgeFactor
    local like  = math.log(prior)
    for i,col in pairs(t.columns.x) do
      local x, inc = row.x[i]
      if x ~= t.ignore then
	if col.put == num1 then
	  like= like + math.log(normpdf(x,col))
	else
	  local f =col.counts[x] or 0
	  like= like +
	        math.log((f + m*prior) / (#t.rows + m)) 
    end end end
    return like
  end
  -----------------------------------------------------    
  local function predict(row,t,m,k,h)
    local max = 10 ^ -32
    print(2)
    for h1,t1 in pairs(t.subs) do
      print{h1=h1}
      local l = likes(row, t1, m, k,
		       #t.rows + k * #t.subs)		   
      if l > max then
	max, h = l, h1
    end end
    return h
  end 
  -----------------------------------------------------    
  function nb(opts)
    local opts, abcd = opts or nb0(), abcd0()
    print(abcd)
    local t 
    for i,names,row in xys() do
      if i > opts.enough then
	local mode = t.columns.y[1].mode
	print{n=2, mode=mode, a=t.columns.y}
	local want = row.y[1]
	local got  = predict(row,t, opts.m,opts.k, mode)
	print{want=want,  got=got}
	abcd1(want, got, abcd)
      end
      t = sample1(row,t,names)
      print("s",#t.rows)
    end
    return abcdz(abcd)
  end
end

if arg[1] == "--nb" then
  nb()
end
