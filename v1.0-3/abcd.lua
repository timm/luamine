do
  function abcd0(db,rx)
    return {db=db or 'all',
	    rx=rx or 'all',
	    yes=0,
	    no=0,
	    known={}, a={}, b={}, c={}, d={}}
  end
  ----------------------------------------------
  local function knowns(x,t)
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
    if actual == predicted then
      t.yes = t.yes + 1
    else
      t.no  = t.no + 1
    end
    for k,v in pairs(i.known) do
      if actual = 
    end
  end
end
