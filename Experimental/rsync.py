from subprocess import call
from os import path

def sync(path1=None, path2=None):
	# Prefer path1 as source
	if path.exists(path1):
		call(['rsync', '-u', '-r', path1, path2])
	
	if path.exists(path2):
		call(['rsync', '-u', '-r', path2, path1])
