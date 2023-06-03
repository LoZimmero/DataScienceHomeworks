#
#       This script coalesces a given input log file into tuples.  
#
#	INPUT:	
#		- name of the log file (text lines)
#		- coalescence window (number in seconds)
#
#	OUTPUT:
#		- a directory named tuples-FILENAME-CWIN
#
#	Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#


import os
import sys
import shutil



def coalescence( logfile, cwin ):

	name=os.path.splitext(logfile)[0]

	outdir="tuples-"+name+"-"+cwin

	if not os.path.exists(outdir):
		print("\nINFO: coalescing " + name + " with CWIN = " + cwin + " ...")
		os.makedirs(outdir)

		logfile = open(logfile,"r")
		loglines = logfile.readlines()


		i=0		
		line = loglines[i].split()
		prev = line[0]

		ifile=open("./"+outdir+"/interarrivals.txt", "a")

		tcount=1
		tfile=open("./"+outdir+"/tuple-"+str(tcount)+".txt", "a")
		tfile.write(loglines[i])

		i = i + 1
		while i < len(loglines):
			line = loglines[i].split()
			succ = line[0]

			delta = int(succ) - int(prev)

			if int(delta)<int(cwin):
				tfile.write(loglines[i])
			else:
				tfile.close()
			
				ifile.write(str(delta)+"\n")

				tcount=tcount+1
				tfile=open("./"+outdir+"/tuple-"+str(tcount)+".txt", "a")

				tfile.write(loglines[i])


			prev=succ
			i = i + 1

		tfile.close()
		ifile.close()
		logfile.close()

		print ("INFO: " + str(tcount) + " tuples found; results in " + outdir + "\n")

	else:
		print ("\nWARNING: output directory already exists")
		print ("Fix:")
		print ("        remove dir " + outdir + "\n" )
	


if __name__ == '__main__':
	args = len(sys.argv)
	if len(sys.argv)!=3:
		print ("\nERROR: incorrect number of arguments")
		print ("Usage:")
		print ("	python " + sys.argv[0] + " <text_file> <cwin>\n" )
	else:
		logfile = sys.argv[1]
		cwin = sys.argv[2]
		coalescence(logfile, cwin)
