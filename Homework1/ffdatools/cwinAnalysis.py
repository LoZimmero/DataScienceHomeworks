#
#       This script assesses the sensitivity of the tuple count with 
#	respect to the coalescence window.
#
#	INPUT:	
#		- name of the log file (text lines)
#
#	OUTPUT:
#		- a file named tcount-FILENAME.txt stored in the directory 'counts'
#
#	Software is distributed without any warranty;
#       bugs should be reported to antonio.pecchia@unisannio.it
#


import os
import sys
import shutil



def count(cwin,cfile,logfile):

	logfile = open(logfile,"r")
	loglines = logfile.readlines()


	i=0		
	line = loglines[i].split()
	prev = line[0]

	tcount=1
		
	i = i + 1
	while i < len(loglines):
		line = loglines[i].split()
		succ = line[0]

		delta = int(succ) - int(prev)

		if int(delta)>=int(cwin):
			tcount=tcount+1

		prev=succ
		i = i + 1


	cfile.write(str(cwin)+"\t"+str(tcount)+"\n")
	logfile.close()	


if __name__ == '__main__':
	args = len(sys.argv)
	if len(sys.argv)!=2:
		print ("\nERROR: incorrect number of arguments")
		print ("Usage:")
		print ("	python " + sys.argv[0] + " <text_file>\n" )
	else:

		logfile = sys.argv[1]
	
		#list of tentative CWINs, feel free to edit
		cwins=[2,5,10,15,30,45,60,90,120,180,240,300,360,480,600,720,900,1200,1800,2700,3600,4000,5000]

		name=os.path.splitext(logfile)[0]
		outfile="tcount-"+name+".txt"

		print("\nINFO: assessing the tuple count wrt to CWIN ...")

		cfile=open("./counts/"+outfile, "w")		

		cfile.write("CWIN\tCOUNT\n")
		for cwin in cwins:
			count(cwin,cfile,logfile)
	
		cfile.close()

		print("INFO: DONE! results in ./counts/"+outfile+"\n")
