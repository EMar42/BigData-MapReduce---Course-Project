import sys
import operator
from utils import *

class Reducer:
    def __init__(self, operation, resultEmitter, initialvalue):
        self.operation = operation
        self.value = self.initialvalue = initialvalue
        self.resultEmitter = resultEmitter
        self.key = None

    def consume(self, value):
        self.value = self.operation(self.value, value)
    
    def getKey(self):
        return self.key

    def emit(self):
        return self.resultEmitter(self.key, self.value)
    
    def clear(self, newKey):
        self.value = self.initialvalue
        self.key = newKey

class compare:
    def __init__(self, op):
        self.op = op
    
    def compare(self, v1, v2):
        return v1 if self.op(int(v1[0]), int(v2[0])) else v2


reducers = {
    'sum': lambda v1, v2: [int(v1[0]) + int(v2[0])],
    'max': compare(operator.gt).compare,
    'min': compare(operator.lt).compare,
    'average': lambda v1, v2: [int(v1[0]) + int(v2[0]), int(v1[1]) + 1]
}

initialValues = {
    'sum': [0],
    'max': [0,0,0],
    'min': [99999,99999,99999],
    'average': [0,0]
}

method = sys.argv[1]
if(method not in reducers.keys()):
    unsupportedMethodError(method)
reducerMethod = reducers[method]
if(len(sys.argv) >= 3 and sys.argv[2] == "chainKey"):
    emitter = emitKeyValue
else:
    emitter = emitValue
reducer = Reducer(reducerMethod, emitter, initialValues[method])

# input format: k{,k} v{,v}
for line in sys.stdin:
    key, value = line.strip().split("\t")
    key = key.split(",")
    value = value.split(",")

    # check if finished processing the current key   
    if(reducer.getKey() != key):
        if(reducer.getKey()):
            reducer.emit()
        reducer.clear(key)

    # consume the current value
    reducer.consume(value)

# emit laster processed key
reducer.emit()