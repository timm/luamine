row2csv() { cat - | lua rows2csv.lua; }
ignore()  { cat - | lua ignore.lua;   }

eg1() { cat ../data/weather.csv | row2csv; }
eg2() { cat ../data/weather.csv | row2csv | ignore; }
