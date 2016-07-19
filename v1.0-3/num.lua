IGNORE="?"

function num0(some)
  local i= {mu= 0, n= 0, m2= 0, up= -1e32, lo= 1e32, put=num1}
  for _,one in pairs(some) do
    num1(i,one) end
  return i
end

function num1(i, one)
  if one ~= IGNORE then
    i.n  = i.n + 1
    if one < i.lo then i.lo = one end
    if one > i.up then i.up = one end
    local delta = one - i.mu
    i.mu = i.mu + delta / i.n
    i.m2 = i.m2 + delta * (one - i.mu)
end end

function unnum(i, one)
  i.n  = i.n - 1
  local delta = one - i.mu
  i.mu = i.mu - delta/i.n
  i.m2 = i.m2 - delta*(one - i.mu)
end

function sd(i)
  return i.n <= 1 and 0 or (i.m2 / (i.n - 1))^0.5
end

function norm(i,one)
  return (one - i.lo) / (i.up - i.lo + 1e-32)
end
