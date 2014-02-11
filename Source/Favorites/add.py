from os import path
from types import *
import alp

# Check for input
if len(alp.args()) > 0:
	adds = alp.args()[0].split('\t')
else:
	print 'Nothing to add to Favorites.'
	raise SystemExit
# SCRIPT EXITS

# Sync & load favorites
favs = alp.jsonLoad('favorites.json', default=[])

# Correct existing favorites
if type(favs) is DictType:
	favs = favs.items()

# Hide non-existent favorites
new_favs = []
for fav in favs:
	if path.exists(fav):
		new_favs.append(fav)
favs = new_favs
alp.jsonDump(favs, 'favorites.json')

# Add new entries
deleted = []
for add in adds:
	favs.append(add)

# Remove duplicates
favs = list(set(favs))

# Save new list
alp.jsonDump(favs, 'favorites.json')

# User feedback
if len(adds) is 1:
	print '\'' + path.basename(adds[0]) + '\' was added to Favorites.'
elif len(adds) > 1:
	print str(len(adds)) + ' items were added to Favorites.'