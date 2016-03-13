lua=luajit

weather()     { cat ../data/weather.csv ; }
maxwell()     { cat ../data/maxwell.csv ; }
maxwell100K() { cat ../data/maxwell100K.csv ; }

row2csv() { cat - | $lua rows2csv.lua; }
ignore()  { cat - | $lua ignore.lua ;  }
xy()      { cat - | $lua xy.lua $*   ;  }
bins()    { cat - | $lua bins.lua $*   ;  }


eg1() { weather     | row2csv; }
eg2() { weather     | row2csv | ignore; }
eg3() { weather     | row2csv | ignore  | xy   --xy; }
eg4() { weather     | row2csv | ignore  | bins --binWeather ; }
eg5() { maxwell     | row2csv | ignore  | bins --binMaxwell ; }
eg6() { maxwell100K | row2csv | ignore  | bins --binMaxwell100 ; }

