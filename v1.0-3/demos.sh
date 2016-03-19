lua=luajit

r() { reset ; }

weather()     { cat ../data/weather.csv ; }
maxwell()     { cat ../data/maxwell.csv ; }
maxwell100K() { cat ../data/maxwell100K.csv ; }

row2csv() { cat - | $lua rows2csv.lua; }
ignore()  { cat - | $lua ignore.lua ;  }
xy()      { cat - | $lua xy.lua $*   ;  }
bins()    { cat - | $lua binsok.lua $*   ;  }
columns() { cat - | $lua columns.lua  $*   ;  }

eg1() { r; weather     | row2csv             ; }
eg2() { r; weather     | row2csv | ignore    ; }
eg3() { r; weather     | row2csv | ignore  | xy   --xy            ; }
eg4() { r; weather     | row2csv | ignore  | bins --binWeather    ; }
eg5() { r; maxwell     | row2csv | ignore  | bins --binMaxwell    ; }
eg6() { r; maxwell100K | row2csv | ignore  | bins --binMaxwell100 ; }
eg7() { r; maxwell     | row2csv | ignore  | bins --binMaxwell0    ; }

eg8() { r; weather     | row2csv | ignore  | columns --cols ; }
eg9() { r; maxwell     | row2csv | ignore  | columns --cols ; }

