import sys
from utils import *

class Precipitation:
    def __init__(self, data):
        self.year = data[0]
        self.values = data[1:]

def totalAnnual(precipitation):
    list(map(lambda value: emit(precipitation.year, value), precipitation.values))

def totalMonthly(precipitation):
    for i in range(0, len(precipitation.values)):
        emit(1, [precipitation.values[i], precipitation.year, i + 1])
        # emit([precipitation.year, i + 1], precipitation.values[i])

def totalSeasonal(precipitation):
    for i in range(0, len(precipitation.values)):
        emit([precipitation.year, inverseSeasonsMap[i + 1]], precipitation.values[i])

def mapToMonths(precipitation):
    [emit(1, value) for value in precipitation.values]

seasons = {
    "winter": [12, 1, 2],
    "spring": [3, 4, 5],
    "summer": [6, 7, 8],
    "autumn": [9, 10, 11]
}

inverseSeasonsMap = {}
for key in seasons:
    for value in seasons[key]:
        inverseSeasonsMap[value] = key

mappers = {
    "totalAnnual": totalAnnual,
    "totalMonthly": totalMonthly,
    "totalSeasonal": totalSeasonal,
    "total": mapToMonths
}

method = sys.argv[1]
if method not in mappers.keys():
    unsupportedMethodError(method)
mapper = mappers[method]

for line in sys.stdin:
    line = line.strip()
    mapper(Precipitation(line.split(",")))