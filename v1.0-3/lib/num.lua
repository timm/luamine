function num0(t)
  local tmp = {mu=0,n=0,m2=0}
  map(t, function (z) num1(z,tmp) end)
  return tmp
end

function num1(z,t)
  t.n  = t.n + 1
  local delta = z - t.mu
  t.mu = t.mu + delta / t.n
  t.m2 = t.m2 + delta * (z - t.mu)
  return t
end

function unnum(z,t)
  t.n  = t.n - 1
  local delta = z - t.mu
  t.mu = t.mu - delta/t.n
  t.m2 = t.m2 - delta*(z - t.mu)
  return t
end

function sd(t)
  return t.n <= 1 and 0 or (t.m2/(t.n - 1))^0.5
end
