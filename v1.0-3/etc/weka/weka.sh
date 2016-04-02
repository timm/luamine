#!/bin/bash
gui() {
    Jar=./weka.jar
    Weka="nice -n 20 java -Xmx2048M -jar $Jar "
    #learner=weka.classifiers.functions.LinearRegression
    #$Weka $learner -S 0 -R 1.0E-8 -i -t $1 -x $2
    #echo "$Weka $learner -S 0 -R 1.0E-8 -i -t $1 -x $2"
}

gui
