#!/bin/bash

# args: string delimited by ',' and the index to return
getIndex() {
  echo $1 | cut -d',' -f $2
}

ex() {
  echo "ex$1:"
}

map() {
  python2 mappers.py $@
}

chainedMap() {
  python2 chainedMappers.py $@
}

reduce() {
  python2 reducers.py $@
}

cat_haddop() {
  output=$1
  hadoop fs -cat output/$output/part-00000
}

ex 1
res=`cat_hadoop ex1`
sum=`getIndex $res 1`
countMonths=`getIndex $res 2`
annualAverage=$(($sum/($countMonths/12)))
echo "annual average: $annualAverage"

ex 2
res=`cat_hadoop ex2`
year=`getIndex $res 2`
rains=`getIndex $res 1`
echo "Highest annualy precipitation was ${rains}mm in $year"

ex 3
res=`cat_hadoop ex3`
year=`getIndex $res 2`
month=`getIndex $res 3`
rains=`getIndex $res 1`
echo "Highest monthly precipitation was ${rains}mm in $month/$year"

ex 4
res=`cat_hadoop ex4`
year=`getIndex $res 2`
rains=`getIndex $res 1`
echo "Lowest annual precipitation was ${rains}mm in $year"

ex 5
res=`cat_hadoop ex5`
year=`getIndex $res 2`
month=`getIndex $res 3`
rains=`getIndex $res 1`
echo "Lowest monthly precipitation was ${rains}mm in $month/$year"

ex 6
res=`cat_hadoop ex6`
year=`getIndex $res 2`
season=`getIndex $res 3`
rains=`getIndex $res 1`
echo "Most wet season was $season $year with ${rains}mm"

ex 7
res=`cat_hadoop ex7`
year=`getIndex $res 2`
season=`getIndex $res 3`
rains=`getIndex $res 1`
echo "Least wet season was $season $year with ${rains}mm"

ex 8
res=`cat_hadoop ex8`
echo "Drought eras:"
echo "$res" | tr ',' ' ' | awk '{ print $1"-"$2": "$3"mm" }'
