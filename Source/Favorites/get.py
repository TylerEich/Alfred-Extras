from os import path
from types import *
import alp

if len(alp.args()) > 0:
	query = alp.args()[0].strip()
else:
	query = ''

# Sync & load favorites
favs = alp.jsonLoad('favorites.json', default=[])
if type(favs) is DictType:
	favs = favs.values()

if not favs:
	item = alp.Item(title='No Favorites', subtitle='No favorites were found. Add favorites via the File Actions panel.', uid=alp.bundle() + ' none', valid=False)
	
	alp.feedback(item)
# SCRIPT EXITS

# Remove duplicate favorites (sets can't have duplicates)
favs = list(set(favs))

# Remove non-existent favorites
new_favs = []
for fav in favs:
	if path.exists(fav):
		new_favs.append(fav)
favs = new_favs
alp.jsonDump(favs, 'favorites.json')

if not query:
	# Return all favorites
	results = favs
else:
	# Return matches
	results = alp.fuzzy_search(query, favs, key=lambda x: x)

if not results:
	item = alp.Item(title='No Results', subtitle='No favorites matched your search.', uid=alp.bundle() + ' none', valid=False)
	
	alp.feedback(item)
# SCRIPT EXITS

# Send to Alfred
items = []
for fav in results:
	item = alp.Item(arg=fav, title=path.basename(fav), subtitle=fav, icon=fav, fileIcon=True, type='file', uid=alp.bundle() + ' ' + fav, valid=True)
	
	items.append(item)

alp.feedback(items)