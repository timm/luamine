function num0(t)
  local tmp = {mu= 0, n= 0, m2= 0, w=1, 
	       up= -1e32,   lo= 1e32}
  map(t, function (z) num1(z,tmp) end)
  return tmp
end

function num1(z,t)
  if z < t.lo then t.lo = z end
  if z > t.up then t.up = z end
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
  t.m2 = t.m2 - delta*(z - t.mu) -- untrustworthy for very small n and z
  return t
end

function sd(t)
  return t.n <= 1 and 0 or (t.m2 / (t.n - 1))^0.5
end

function norm(z, t)
  return (z - t.lo) / (t.up - t.lo + 1e-32)
end

function normpdf(x,t)
  local s = sd(t)
  return math.exp(-1*(x - t.mu)^2/(2*s*s))
         * 1 / (s * ((2*math.pi)^0.5))
end

if arg[1] == "--num" then
  local t = {1,2,2.5,3,3.5,4,4,4,4.5,5,5.5,6,7}
  local n = num0(t)
  print{mu = n.mu, sd = sd(n)}
  for _,i in pairs(t) do
    print(i, normpdf(i,n))
  end
end
