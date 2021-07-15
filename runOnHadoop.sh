#!/bin/bash
runJob() {
  mapper=$1
  reducer=$2
  output=$3
  input=$4
  if [ -z $input ]; then
    input='input/DataFile.csv'
  fi
  hadoop fs -rm -r output/$output
hadoop jar ../share/hadoop/tools/lib/hadoop-streaming-2.9.0.jar -file \
mappers.py -mapper "python mappers.py $mapper" -file reducers.py -reducer \
"python reducers.py $reducer" -input $input -output output/$output &
}

runChained() {
  mapper=$1
  reducer=$2
  output=$3
  input=$4
  if [ -z $input ]; then
    input='input/DataFile.csv'
  fi

  hadoop fs -rm -r output/$output
  hadoop jar ../share/hadoop/tools/lib/hadoop-streaming-2.9.0.jar -file \
chainedMappers.py -mapper "python chainedMappers.py $mapper" -file reducers.py -reducer \
"python reducers.py $reducer" -input $input -output output/$output &
}

runDrought() {
  mapper=$1
  reducer=$2
  output=$3
  input=$4
  if [ -z $input ]; then
    input='input/DataFile.csv'
  fi

  hadoop fs -rm -r output/$output
  hadoop jar ../share/hadoop/tools/lib/hadoop-streaming-2.9.0.jar -file \
chainedMappers.py -mapper "python chainedMappers.py $mapper" -file  droughtReducer.py -reducer \
"python droughtReducer.py $reducer" -input $input -output output/$output &
}

firstRun() {

runJob total average ex1

runJob totalAnnual "sum chainKey" ex248_tmp

runJob totalMonthly max ex3

runJob totalMonthly min ex5

runJob totalSeasonal "sum chainKey" ex67_tmp

}

secondRun() {

runChained "keyToValue 1" max ex2 output/ex248_tmp/part-00000

runChained "keyToValue 1" min ex4 output/ex248_tmp/part-00000

runChained "keyToValue 2" max ex6 output/ex67_tmp/part-00000

runChained "keyToValue 2" min ex7 output/ex67_tmp/part-00000

runDrought "drought 1 1527" "" ex8 output/ex248_tmp/part-00000 

}

if [ $1 == first ]; then
	firstRun
elif [ $1 == second ]; then
	secondRun
else
	echo wrong option
fi
