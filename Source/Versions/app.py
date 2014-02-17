from plistlib import readPlist
from AppKit import NSWorkspace
from sys import stdout
from sys import argv

path = ''

if len(argv) > 1:
	path = argv[1]

if path == '':
	path = NSWorkspace.sharedWorkspace().activeApplication()['NSApplicationPath']

path += '/Contents/Info.plist'
info = readPlist(path)

appName = info['CFBundleExecutable']
if 'CFBundleDisplayName' in info:
	appName = info['CFBundleDisplayName']
elif 'CFBundleName' in info:
	appName = info['CFBundleName']

appVersion = info['CFBundleVersion']
appShortVersion = info['CFBundleShortVersionString']
if appShortVersion and appVersion:
	if appVersion != appShortVersion:
		appVersion = appShortVersion + ' (' + appVersion + ')'
elif not appVersion and appShortVersion:
	appVersion = appShortVersion

stdout.write(appName + ' v' + appVersion)