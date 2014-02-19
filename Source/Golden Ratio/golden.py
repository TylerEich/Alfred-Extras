import math
import alp

if len(alp.args()) > 0:
	query = alp.args()[0]
else:
	query = ''
#query = ""

Phi = 1.6180339887
phi = 0.6180339887

if not query:
	Phi_item = alp.Item(title=str(Phi), subtitle=u"\u03D5", valid=True, arg=str(Phi), uid="tylereich.goldenratio Phi")
	phi_item = alp.Item(title=str(phi), subtitle=u"1 \u00F7 \u03D5", valid=True, arg=str(phi), uid="tylereich.goldenratio phi")
	
	alp.feedback([Phi_item, phi_item])

try:
	query = int(query)
except ValueError:
	try:
		query = float(query)
	except ValueError:
		query = None

if query is not None:
	long_side = query * Phi
	short_side = query * phi

	if type(query) is int:
		long_side = int(round(long_side))
		short_side = int(round(short_side))

	long_side = str(long_side)
	short_side = str(short_side)

	long_item = alp.Item(title=long_side, subtitle=str(query) + u" \u00D7 \u03D5", valid=True, arg=long_side, uid="tylereich.goldenratio long")
	short_item = alp.Item(title=short_side, subtitle=str(query) + u" \u00F7 \u03D5", valid=True, arg=short_side, uid="tylereich.goldenratio short")

	alp.feedback([long_item, short_item])
else:
	alp.feedback(alp.Item(title="No Results", subtitle="Please input a real number", valid=False, arg="", uid="tylereich.goldenratio none"))

