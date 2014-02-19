from subprocess import check_output
from sys import stdout

osName = check_output(['sw_vers', '-productName']).strip()
osVersion = check_output(['sw_vers', '-productVersion']).strip()
osBuild = check_output(['sw_vers', '-buildVersion']).strip()

stdout.write(osName + ' ' + osVersion + ' (' + osBuild + ')')