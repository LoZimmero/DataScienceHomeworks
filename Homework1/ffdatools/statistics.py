#
#       This script generates the list of top-20 occurring nodes by entries.
#
#	INPUT:	
#		- name of the log file (text lines)
#
#	OUTPUT:
#		- prints the top-20 nodes
#
#	Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#


import os
import sys
import shutil
from collections import Counter


if __name__ == '__main__':
	args = len(sys.argv)
	if len(sys.argv)!=2:
		print ("\nERROR: incorrect number of arguments")
		print ("Usage:")
		print ("	python " + sys.argv[0] + " <text_file>\n" )
	else:

		logfile = sys.argv[1]

		nodeCol=-1
		if logfile == "CSTest.txt":
			nodeCol=1
		else:
			nodeCol=2


		logfile = open(logfile,"r")
		loglines = logfile.readlines()

		nodes=[]

		i=0
		while i < len(loglines):       
			line = loglines[i].split()
			nodes.append(line[nodeCol])
			i=i+1

		c = Counter( nodes )

		print("\nNODE\t\tENTRIES")
		print("-----------------------")
	
		for node, count in c.most_common(20):
			print (node+"\t"+str(count))
		
		print("\n")
		logfile.close()
