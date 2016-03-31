require "tools"

do
  function abcd0(db,rx)
    return {db=db or 'all',
	    rx=rx or 'all',
	    yes=0,
	    no=0,
	    known={}, a={}, b={}, c={}, d={}}
  end
  ----------------------------------------------
  local function known(x,t)
    if not t.known[x] then
      t.a[x], t.b[x], t.c[x], t.d[x] = 0,0,0,0
      t.known[x] = 0
    end
    t.known[x] = t.known[x] + 1
    if t.known[x] == 1 then
      t.a[x] = t.yes + t.no
  end end
  ----------------------------------------------	
  function abcd1(actual, predicted, t)
    known(actual,    t)
    known(predicted, t)
    if   actual == predicted then
         t.yes = t.yes + 1
    else t.no  = t.no  + 1 end 
    for x,_ in pairs(t.known) do
      if actual == x then
	if   actual == predicted then
	     t.d[x] = t.d[x] + 1
	else t.b[x] = t.b[x] + 1 end 
      else
	if   predict == x then
	     t.c[x] = t.c[x] + 1
	else t.a[x] = t.a[x] + 1 end 
      end
  end end
  local function p(x) return 100*math.floor(x + 0.5) end
  local function n(x) return     math.floor(x)       end
  ------------------------------------------------
  function abcdz(t)
    local pd,pf,pn,prec,g,f,acc = 0,0,0,0,0,0,0
    local out = {}
    for x,_ in pairs(t.known) do
      local a,b,c,d = t.a[x], t.b[x], t.c[x], t.d[x]
      if b+d > 0          then pd   = d     / (b+d) end
      if a+c > 0          then pf   = c     / (a+c) end
      if a+c > 0          then pn   = (b+d) / (a+c) end
      if c+d > 0          then prec = d     / (c+d) end
      if 1-pf+pd > 0      then g = 2 * (1-pf) * pd / (1-pf+pd) end
      if prec+pd > 0      then f = 2*prec*pd / (prec + d)      end
      if t.yes + t.no > 0 then acc = t.yes   / (t.yes + t.no)  end
      out[x] = {db=t.db,  rx = t.rx, yes = n(b+d),    all = n(a+b+c+d),
		a=n(a),   b=n(b),    c=n(c), d= n(d), acc = p(acc),
		pd=p(pd), pf=p(pf),  prec=p(prec),
		f=p(f),   g=p(g),    x=x}
    end
    return out
  end
end



if arg[1] == '--abcd' then
  local function _abcd(s)
    local ws = {}
    local log = abcd0()
    for w in s:gmatch("%w+") do table.insert(ws, w) end
    for i = 1,#ws,2 do
      abcd1(ws[i], ws[i+1], log)
    end
    print("")
    for k, v in pairs(abcdz(log)) do
      print(k,{a=v.a,b=v.b,c=v.c,d=v.d,pd=v.pd,prec=v.prec })
    end
  end
  --[[
              a b c == actual
  predicted a 3 2 1
            b 5 6 1
            c 2 2 8
  ]]--
  _abcd([[   a a a a a a
                  b a b a
                  c a 
                  a b a b a b a b a b
                  b b b b b b b b b b b b
                  c b
                  a c a c
                  b c b c
                  c c c c c c c c 
                  c c c c c c c c 
             ]])
   --[[
              a b c == actual
  predicted a 1 1 0
            b 1 1 1
            c 0 1 1
  ]]--
  _abcd([[ a a b a a b b b c b b c c c  ]])
end


--[[

a b c 
2      a
  1    b
    2  c
     
]]--
