--简易计算、小写转大写
local ssymbol="="
local confs = {{
 comment=" 大写",
 number={
  [0]="零",
  "壹",
  "贰",
  "叁",
  "肆",
  "伍",
  "陆",
  "柒",
  "捌",
  "玖"
 },
 suffix={
  [0]="",
  "拾",
  "佰",
  "仟"
 },
 suffix2={
  [0]="",
  "万",
  "亿",
  "兆",
  "京"
 }
}, {
 comment=" 小写",
 number={
  [0]="零",
  "一",
  "二",
  "三",
  "四",
  "五",
  "六",
  "七",
  "八",
  "九"
 },
 suffix={
  [0]="",
  "十",
  "百",
  "千"
 },
 suffix2={
  [0]="",
  "万",
  "亿",
  "兆",
  "京"
 }
}}
local function read_seg(conf, n)
 local s = ""
 local i = 0
 local zf = true
 while string.len(n) > 0 do
  local d = tonumber(string.sub(n, -1, -1))
  if d ~= 0 then
   s = conf.number[d] .. conf.suffix[i] .. s
   zf = false
  else
   if not zf then
    s = conf.number[0] .. s
   end
   zf = true
  end
  i = i + 1
  n = string.sub(n, 1, -2)
 end
 return i < 4, s
end
local function read_number(conf, n)
 local s = ""
 local i = 0
 local zf = false
 n = string.gsub(n, "^0+", "")
 if n == "" then
  return conf.number[0]
 end
 while string.len(n) > 0 do
  local zf2, r = read_seg(conf, string.sub(n, -4, -1))
  if r ~= "" then
   if zf and s ~= "" then
    s = r .. conf.suffix2[i] .. conf.number[0] .. s
   else
    s = r .. conf.suffix2[i] .. s
   end
  end
  zf = zf2
  i = i + 1
  n = string.sub(n, 1, -5)
 end
 return s
end
cos = math.cos
sin = math.sin
tan = math.tan
acos = math.acos
asin = math.asin
atan = math.atan
rad = math.rad
deg = math.deg
abs = math.abs
floor = math.floor
ceil = math.ceil
mod = math.fmod
trunc = function(x, dc)
 if dc == nil then
  return math.modf(x)
 end
 return x - mod(x, dc)
end
round = function(x, dc)
 dc = dc or 1
 local dif = mod(x, dc)
 if abs(dif) > dc / 2 then
  return x < 0 and x - dif - dc or x - dif + dc
 end
 return x - dif
end
random = math.random
randomseed = math.randomseed
inf = math.huge
MAX_INT = math.maxinteger
MIN_INT = math.mininteger
pi = math.pi
sqrt = math.sqrt
cbrt = math.cbrt
exp = math.exp
e = exp(1)
ln = math.log
log = function(x, base)
 base = base or 10
 return ln(x) / ln(base)
end
min = function(arr)
 local m = inf
 for k, x in ipairs(arr) do
  m = x < m and x or m
 end
 return m
end
max = function(arr)
 local m = -inf
 for k, x in ipairs(arr) do
  m = x > m and x or m
 end
 return m
end
sum = function(t)
 local acc = 0
 for k, v in ipairs(t) do
  acc = acc + v
 end
 return acc
end
avg = function(t)
 return sum(t) / #t
end
isinteger = function(x)
 return math.fmod(x, 1) == 0
end
array = function(...)
 local arr = {}
 for v in ... do
  arr[#arr + 1] = v
 end
 return arr
end
irange = function(from, to, step)
 if to == nil then
  to = from
  from = 0
 end
 step = step or 1
 local i = from - step
 to = to - step
 return function()
  if i < to then
   i = i + step
   return i
  end
 end
end
range = function(from, to, step)
 return array(irange(from, to, step))
end
irev = function(arr)
 local i = #arr + 1
 return function()
  if i > 1 then
   i = i - 1
   return arr[i]
  end
 end
end
arev = function(arr)
 return array(irev(arr))
end
test = function(f, t)
 for k, v in ipairs(t) do
  if not f(v) then
   return false
  end
 end
 return true
end
map = function(t, ...)
 local ta = {}
 for k, v in pairs(t) do
  local tmp = v
  for _, f in pairs({...}) do
   tmp = f(tmp)
  end
  ta[k] = tmp
 end
 return ta
end
filter = function(t, ...)
 local ta = {}
 local i = 1
 for k, v in pairs(t) do
  local erase = false
  for _, f in pairs({...}) do
   if not f(v) then
    erase = true
    break
   end
  end
  if not erase then
   ta[i] = v
   i = i + 1
  end
 end
 return ta
end
foldr = function(t, f, acc)
 for k, v in pairs(t) do
  acc = f(acc, v)
 end
 return acc
end
foldl = function(t, f, acc)
 for v in irev(t) do
  acc = f(acc, v)
 end
 return acc
end
chain = function(t)
 local ta = t
 local function cf(f, ...)
  if f ~= nil then
   ta = f(ta, ...)
   return cf
  else
   return ta
  end
 end
 return cf
end
fac = function(n)
 local acc = 1
 for i = 2, n do
  acc = acc * i
 end
 return acc
end
nPr = function(n, r)
 return fac(n) / fac(n - r)
end
nCr = function(n, r)
 return nPr(n, r) / fac(r)
end
MSE = function(t)
 local ss = 0
 local s = 0
 local n = #t
 for k, v in ipairs(t) do
  ss = ss + v * v
  s = s + v
 end
 return sqrt((n * ss - s * s) / (n * n))
end
lapproxd = function(f, delta)
 local delta = delta or 1e-8
 return function(x)
  return (f(x + delta) - f(x)) / delta
 end
end
sapproxd = function(f, delta)
 local delta = delta or 1e-8
 return function(x)
  return (f(x + delta) - f(x - delta)) / delta / 2
 end
end
deriv = function(f, delta, dc)
 dc = dc or 1e-4
 local fd = sapproxd(f, delta)
 return function(x)
  return round(fd(x), dc)
 end
end
trapzo = function(f, a, b, n)
 local dif = b - a
 local acc = 0
 for i = 1, n - 1 do
  acc = acc + f(a + dif * (i / n))
 end
 acc = acc * 2 + f(a) + f(b)
 acc = acc * dif / n / 2
 return acc
end
integ = function(f, delta, dc)
 delta = delta or 1e-4
 dc = dc or 1e-4
 return function(a, b)
  if b == nil then
   b = a
   a = 0
  end
  local n = round(abs(b - a) / delta)
  return round(trapzo(f, a, b, n), dc)
 end
end
rk4 = function(f, timestep)
 local timestep = timestep or 0.01
 return function(start_x, start_y, time)
  local x = start_x
  local y = start_y
  local t = time  for i = 0, t, timestep do
   local k1 = f(x, y)
   local k2 = f(x + (timestep / 2), y + (timestep / 2) * k1)
   local k3 = f(x + (timestep / 2), y + (timestep / 2) * k2)
   local k4 = f(x + timestep, y + timestep * k3)
   y = y + (timestep / 6) * (k1 + 2 * k2 + 2 * k3 + k4)
   x = x + timestep
  end
  return y
 end
end
date = os.date
time = os.time
path = function()
 return debug.getinfo(1).source:match("@?(.*/)")
end
local function serialize(obj)
 local type = type(obj)
 if type == "number" then
  return isinteger(obj) and floor(obj) or obj
 elseif type == "boolean" then
  return tostring(obj)
 elseif type == "string" then
  return '"' .. obj .. '"'
 elseif type == "table" then
  local str = "{"
  local i = 1
  for k, v in pairs(obj) do
   if i ~= k then
    str = str .. "[" .. serialize(k) .. "]="
   end
   str = str .. serialize(v) .. ", "
   i = i + 1
  end
  str = str:len() > 3 and str:sub(0, -3) or str
  return str .. "}"
 elseif pcall(obj) then
  return "callable"
 end
 return obj
end
local greedy = true
local function calculator_translator(input, seg)
 if string.sub(input, 1, 1) ~= ssymbol then
  return
 end
 local expfin = greedy or string.sub(input, -1, -1) == ";"
 local exp = (greedy or not expfin) and string.sub(input, 2, -1) or string.sub(input, 2, -2) exp = exp:gsub("#", " ") if not expfin then
  return
 end
 local expe = exp expe = expe:gsub("%$", " chain ") do
  local count
  repeat
   expe, count = expe:gsub("\\%s*([%a%d%s,_]-)%s*%.(.-)|", " (function (%1) return %2 end) ")
  until count == 0
 end if expe:find("i?os?%.") then
  return
 end local result = load("return " .. expe)()
 if result == nil then
  return
 end
 result = serialize(result)
 yield(Candidate("number", seg.start, seg._end, result, "答案"))
 yield(Candidate("number", seg.start, seg._end, exp .. "=" .. result, "等式"))
 result = "=" .. result
 local n = string.sub(result, 2)
 if tonumber(n) ~= nil then
  for _, conf in ipairs(confs) do
   local r = read_number(conf, n)
   yield(Candidate("number", seg.start, seg._end, r, conf.comment))
  end
 end
end
return calculator_translator
