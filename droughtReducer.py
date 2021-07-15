import sys
from utils import *

# Number of years in current in a row
yearCount = 0
# First year in the row
firstYear = -99999
# Last year in the row
lastYear = -99999
# Accumulator of rains in the range of years
totalRains = 0
# Min row for drought era
droughtEraThreshold = 3

# input format: k{,k} v{,v}
for line in sys.stdin:
    key, value = line.strip().split("\t")
    value = value.split(",")
    rains = value[0]
    year = int(value[1])
    
    # check if finished processing the current key
    if(year != lastYear + 1):
        if(yearCount >= droughtEraThreshold):
            emitValue(key, [firstYear, lastYear, totalRains])
        yearCount = 0
        firstYear = year
        totalRains = 0
    lastYear = year
    yearCount += 1
    totalRains += int(rains)

# emit laster processed key
if(yearCount >= droughtEraThreshold):
    emitValue(key, [firstYear, lastYear, totalRains])
