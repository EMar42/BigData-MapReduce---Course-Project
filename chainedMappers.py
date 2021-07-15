import sys
from utils import *

# (key,value) -> (1,(key,value))
def keyToValue(key, value):
    emit([1], value + key)

def emitDroughtYearsMethod(droughtThreshold):
    return lambda key, value: keyToValue(key, value) if value[0] < droughtThreshold else None

method = sys.argv[1]
keyLength = int(sys.argv[2])

# Special mapper for the drought eras exercise
if(method == "drought"):
    droughtThreshold = sys.argv[3]
    mapper = emitDroughtYearsMethod(droughtThreshold)
elif(method == "keyToValue"):
    mapper = keyToValue
else:
    unsupportedMethodError(method)

for line in sys.stdin:
    values = line.strip().split(",")
    key = values[:keyLength]
    value = values[keyLength:]
    mapper(key, value)