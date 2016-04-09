lua=luajit

r() { reset ; }

weather()     { cat ../data/weather.csv     ; }
maxwell()     { cat ../data/maxwell.csv     ; }
maxwell100K() { cat ../data/maxwell100K.csv ; }
diabetes()    { cat ../data/diabetes.csv    ; }
audiology()   { cat ../data/audiology.csv   ; }

row2csv() { cat - | $lua rows2csv.lua   ; }
ignore()  { cat - | $lua ignore.lua     ; }
xy()      { cat - | $lua xy.lua $*      ; }
bins()    { cat - | $lua binsok.lua $*  ; }
sample()  { cat - | $lua sample.lua $*  ; }
nb()      { cat - | $lua nb.lua $*      ; } 
tests()   { $lua oks.lua                ; }
eras()    { cat - | $lua eras.lua $*    ; }
dists()   { cat - | $lua dists.lua $*    ; }
grid()    { cat - | $lua grid.lua $*    ; }

egs() {
  reset
  for e in `cat demos.sh |
             gawk '/^eg[0-9]+[(]/ {
                gsub(/[(].*/,""); 
                print $0} '`
  do
      b="--------"
      echo ""; echo "$b| $e |$b$b$b$b$b$b"
      $e
  done
}
eg1() { r; weather     | row2csv             ; }
eg2() { r; weather     | row2csv | ignore    ; }
eg3() { r; weather     | row2csv | ignore  | xy   --xy            ; }
eg3a() { r; maxwell100K| row2csv | ignore  | xy   --xy       ; }
eg3b() { r; diabetes   | row2csv | ignore  | xy   --xy       ; }

eg4() { r; weather     | row2csv | ignore  | bins --binWeather    ; }
eg5() { r; maxwell     | row2csv | ignore  | bins --binMaxwell    ; }
eg6() { r; maxwell100K | row2csv | ignore  | bins --binMaxwell100 ; }
eg7() { r; maxwell     | row2csv | ignore  | bins --binMaxwell0   ; }

eg8(){  r;weather      |row2csv|ignore|sample --sample; }
eg9(){  r;maxwell      |row2csv|ignore|sample --sample; }
eg10(){ r;maxwell100K  |row2csv|ignore|sample --sample; }
eg11(){ r;diabetes     |row2csv|ignore|sample --sample; }

eg20(){ r;weather|row2csv|ignore|nb --nb; }
eg21(){ r;diabetes|row2csv|ignore|nb --nb; }

eg22a() {
    Seed=$RANDOM
    echo -n "# m $2 k $3 "
    r;$1|row2csv|ignore|
	eras -era 10000 -seed $Seed |
	nb --nb -m $2 -k $3 | sort -n -k 23 |
	gawk '$23 > 0 || /#/ ' 
    }

eg22n(){
    for((k=0;k<=3;k=k+1)); do
	for((m=0;m<=3;m=m+1)); do
	    eg22a $1 $m $k
	done
    done  
}
 
eg23(){ r;audiology|row2csv|ignore|nb --nb | sort -n -k 17 ;}
eg24(){ eg22n audiology;  }
eg25(){ r;weather|row2csv|ignore|dists --dists; }
eg26(){ r;weather|row2csv|ignore|grid  --grid ; }
