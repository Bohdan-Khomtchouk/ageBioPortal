#!/usr/bin/python

######################################################################
# tempSeg.py                                                         #
# Author:  Dario Ghersi                                              #
# Version: 20150407                                                  #
# Goal:    implementation of the temporal segmentation of time       #
#          series as described in:                                   #
#          Siy, Chundi, Rosenkrantz, and Subramaniam                 #
#          Journal of Software maintenance and evolution, 2007; 11   #
# Usage:   tempSeg.py TIME_SERIES_DIR ALPHA P                        #
######################################################################

import glob
import sys

######################################################################
# CONSTANTS                                                          #
######################################################################

MIN_SIZE = 4 # the minimum size for a token

######################################################################
# FUNCTIONS                                                          #
######################################################################

def acquireTimeSeries(timeSeriesDir):
	"""
	Store the time series as a list of dictionaries
	"""
	## set up the variables
	allFiles = glob.glob(timeSeriesDir + "/*")
	timeSeries = [{} for _ in range(numPoints)]
	## process each time point
	for i, f in enumerate(allFiles):
    	with open(f) as timePointFile:
			for line in timePointFile:
				token, freq = line[:-1].split()
				# include only tokens above a minimum length
				if len(token) >= MIN_SIZE:
					timeSeries[i][token] = int(freq)
  	return timeSeries

######################################################################

def calcDecomp(T):
	"""
	Calculate the optimal decomposition.
	"""
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
	curr = len(T) - 1
	decomp = []
	numCl = len(T[0]) # number of segments
	while curr > 0:
		decomp.append(curr)
		curr = T[curr][numCl - 1]
		numCl -= 1

	decomp.reverse()
	return decomp

######################################################################
  
def calcNumPap(allAbstrFileName):
	"""
	calculate the total number of papers per year
	"""

	numPap = defaultdict(int)
	with open(allAbstrFileName) as allAbstrFile:
		for line in allAbstrFile:
			fields = line[:-1].split()
			try:
				numPap[int(fields[0])] += 1
			except ValueError:
				# invalid literal for int() with base 10
				pass
  	numPapSorted = [numPap[year] for year in sorted(numPap.keys())]
  	return numPapSorted

######################################################################

def computeSegDiff(timeSeries, numPap, alpha):
	"""
	compute the loss for combining two or more segments together
	"""

	numSets = len(timeSeries)
	totSize = numSets * (numSets - 1) / 2
	segDiff = [[0 for x in range(totSize)] for x in range(totSize)]
	## extract the significant items for each item set
	signifItems = [getSignifItems2(timeSeries[i:i+1],
									numPap,
									alpha, i, i) for i in range(numSets)]
	## process each possible segment
	for i in range(numSets - 1):
		for j in range(i + 1, numSets):	
			# extract the significant items
			#segmentItems = getSignifItems(timeSeries[i:j + 1], alpha)
			segmentItems = getSignifItems2(timeSeries[i:j + 1], numPap,
											alpha, i, j)
			segDiff[i][j] = fracDiff(signifItems, segmentItems, i, j)
      
	return segDiff, signifItems

######################################################################

def fracDiff(signifItems, segmentItems, i, j):
	"""
	compute the cumulative fractional difference between item sets in
	a segment i <= x <= j
	"""

	segmentItems = set(segmentItems)
	fracDiff = sum(len(segmentItems.symmetric_difference(
		set(signifItems[x]))
		) for x in range(i, j+1))

	return fracDiff

######################################################################

def getSignifItems(segment, alpha):
	"""
	extract the items in the segment whose relative
	frequency is above alpha
	"""
	totals = sum(Counter(timePoint) for timePoint in segment)
	## extract the items whose relative frequency is >= alpha
	total = float(sum(totals.values()))
	signifItems = [
		item for item, value in totals.items()
			if value / total >= alpha
				]
	return signifItems

######################################################################

def getSignifItems2(segment, numPap, alpha, i, j):
	"""
	extract the items in the segment whose relative
	frequency is above alpha
	"""

	signifItems = []
	avgs = defaultdict(int)
	weights = numPap[i:j+1]
	numSeg = j - i + 1
	for k in range(numSeg):
		timePoint = segment[k]
		for item in timePoint:
			avgs[item] += timePoint[item]

	## extract the items whose relative frequency is >= alpha
	total = float(sum(weights))
	signifItems = [
		item for item, value in avgs.items()
			if value / total >= alpha
	]
	#print signifItems, i, j
	#sys.exit(1) 
	return signifItems

######################################################################

def optimalSeg(segDiff, n, p):
	"""
	apply dynamic programming to optimally segment the time series
	"""

	## initialize the R and T arrays, which will contain the loss values
	## and the segmentation path, respectively
	R = [[0 for x in range(p)] for x in range(n)]
	T = [[0 for x in range(p)] for x in range(n)]

	for j in range(n):
		R[j][0] = segDiff[0][j]
		kmax = min(j + 1, p)

		for k in range(1, kmax):
			R[j][k] = R[k - 1][k - 1] + segDiff[k][j]
			T[j][k] = k - 1

		for z in range(k - 1, j):
			if (R[z][k - 1] + segDiff[z + 1][j]) < R[j][k]:
				R[j][k] = R[z][k - 1] + segDiff[z + 1][j]
				T[j][k] = z

	return R, T
    
######################################################################
# MAIN PROGRAM                                                       #
######################################################################

if __name__ == "__main__":
	## parse the parameters
	if len(sys.argv) != 5:
		print "Usage: tempSeg.py TIME_SERIES_DIR ALL_ABSTR ALPHA P"
		sys.exit(1)

	timeSeriesDir, allAbstrFileName, alpha, p = sys.argv[1:]
	alpha = float(alpha)
	p = int(p)
	## calculate the number of papers for each year
	numPap = calcNumPap(allAbstrFileName)
	## acquire the time series
	timeSeries = acquireTimeSeries(timeSeriesDir)
	## compute the segment difference for each possible segment and
	## the significant items
	segDiff, signifItems = computeSegDiff(timeSeries, numPap, alpha)
	## run the optimal segmentation algorithm
	R, T = optimalSeg(segDiff, len(timeSeries), p)
	for i in range(len(T)):
		print i, T[i]
	## calculate the decomposition
	decomp = calcDecomp(T)
	print decomp
	#print signifItems[10]
	#print "***"
	#print signifItems[1]