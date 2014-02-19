from os import path
from os import listdir
from os import chdir
from itertools import chain
from subprocess import call
from sys import argv

# archiveExtension = argv[1]
# query = argv[2]
archiveExtension = 'zip'
query = '/Users/Tyler/Desktop/screen shot/Test.rtf'

# Separate files string
files = query.split('\t')

# Get the first file
file = files[0]

# Get path components
directory = path.dirname(file)
name, extension = path.splitext(file)

# Name 
if len(files) > 1:
	archiveName = 'Archive'
else:
	archiveName = name + extension

# Count existing archives to avoid naming collisions
contents = listdir(directory)
archiveCount = 0

for file in contents:
	if file.startswith(archiveName) and file.endswith('.' + archiveExtension):
		archiveCount += 1

if archiveCount > 0:
	archiveName += '-' + str(archiveCount + 1)

archiveFile = archiveName

# Find files whose directories do not match the first file
sameDirectoryFiles = [file[len(directory) + 1:] for file in files if file.startswith(directory)]
	
# Switch to directory of first file
chdir(directory)

# Apply the specified command
if archiveExtension == 'dmg':
	# Only handles directories
	srcFolders = list(chain.from_iterable(('-srcfolder', file) for file in files if path.isdir(file)))
	
	# Create disk image
	call(['hdiutil', 'create', '-volname', archiveName, '-format', 'UDZO'] + srcFolders + [archiveFile])
	
elif archiveExtension == 'tar.bz2':
	# Create bz2 tarball
	call(['tar', '-cjf', archiveFile] + sameDirectoryFiles)
	
elif archiveExtension == 'tar.gz':
	# Create gzip tarball
	call(['tar', '-czf', archiveFile] + sameDirectoryFiles)
	
elif archiveExtension == 'zip':
	# Create zip archive
	call(['zip', '-rq', archiveFile] + sameDirectoryFiles)
	
# Return the path of the archive
print directory + '/' + archiveFile