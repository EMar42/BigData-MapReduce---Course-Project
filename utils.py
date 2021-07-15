def listToString(l):
    if(type(l) == list):
        return ",".join(str(x) for x in l)
    return l

def emit(key, value):
    key = listToString(key)
    value = listToString(value)
    print("{}\t{}".format(key, value))

def emitValue(key, value):
    value = listToString(value)
    print(value)

def emitKeyValue(key, value):
    key = listToString(key)
    value = listToString(value)
    print("{},{}".format(key, value))

def unsupportedMethodError(method):
    print("Unsupported method: {}".format(method))
    exit(1)