import alp
import pngcanvas
import subprocess
#import re
# from __future__ import print_function

names = {'aliceblue':'f0f8ff','antiquewhite':'faebd7','aqua':'00ffff','aquamarine':'7fffd4','azure':'f0ffff','beige':'f5f5dc','bisque':'ffe4c4','black':'000000','blanchedalmond':'ffebcd','blue':'0000ff','blueviolet':'8a2be2','brown':'a52a2a','burlywood':'deb887','burntsienna':'ea7e5d','cadetblue':'5f9ea0','chartreuse':'7fff00','chocolate':'d2691e','coral':'ff7f50','cornflowerblue':'6495ed','cornsilk':'fff8dc','crimson':'dc143c','cyan':'00ffff','darkblue':'00008b','darkcyan':'008b8b','darkgoldenrod':'b8860b','darkgray':'a9a9a9','darkgreen':'006400','darkgrey':'a9a9a9','darkkhaki':'bdb76b','darkmagenta':'8b008b','darkolivegreen':'556b2f','darkorange':'ff8c00','darkorchid':'9932cc','darkred':'8b0000','darksalmon':'e9967a','darkseagreen':'8fbc8f','darkslateblue':'483d8b','darkslategray':'2f4f4f','darkslategrey':'2f4f4f','darkturquoise':'00ced1','darkviolet':'9400d3','deeppink':'ff1493','deepskyblue':'00bfff','dimgray':'696969','dimgrey':'696969','dodgerblue':'1e90ff','firebrick':'b22222','floralwhite':'fffaf0','forestgreen':'228b22','fuchsia':'ff00ff','gainsboro':'dcdcdc','ghostwhite':'f8f8ff','gold':'ffd700','goldenrod':'daa520','gray':'808080','green':'008000','greenyellow':'adff2f','grey':'808080','honeydew':'f0fff0','hotpink':'ff69b4','indianred':'cd5c5c','indigo':'4b0082','ivory':'fffff0','khaki':'f0e68c','lavender':'e6e6fa','lavenderblush':'fff0f5','lawngreen':'7cfc00','lemonchiffon':'fffacd','lightblue':'add8e6','lightcoral':'f08080','lightcyan':'e0ffff','lightgoldenrodyellow':'fafad2','lightgray':'d3d3d3','lightgreen':'90ee90','lightgrey':'d3d3d3','lightpink':'ffb6c1','lightsalmon':'ffa07a','lightseagreen':'20b2aa','lightskyblue':'87cefa','lightslategray':'778899','lightslategrey':'778899','lightsteelblue':'b0c4de','lightyellow':'ffffe0','lime':'00ff00','limegreen':'32cd32','linen':'faf0e6','magenta':'ff00ff','maroon':'800000','mediumaquamarine':'66cdaa','mediumblue':'0000cd','mediumorchid':'ba55d3','mediumpurple':'9370db','mediumseagreen':'3cb371','mediumslateblue':'7b68ee','mediumspringgreen':'00fa9a','mediumturquoise':'48d1cc','mediumvioletred':'c71585','midnightblue':'191970','mintcream':'f5fffa','mistyrose':'ffe4e1','moccasin':'ffe4b5','navajowhite':'ffdead','navy':'000080','oldlace':'fdf5e6','olive':'808000','olivedrab':'6b8e23','orange':'ffa500','orangered':'ff4500','orchid':'da70d6','palegoldenrod':'eee8aa','palegreen':'98fb98','paleturquoise':'afeeee','palevioletred':'db7093','papayawhip':'ffefd5','peachpuff':'ffdab9','peru':'cd853f','pink':'ffc0cb','plum':'dda0dd','powderblue':'b0e0e6','purple':'800080','red':'ff0000','rosybrown':'bc8f8f','royalblue':'4169e1','saddlebrown':'8b4513','salmon':'fa8072','sandybrown':'f4a460','seagreen':'2e8b57','seashell':'fff5ee','sienna':'a0522d','silver':'c0c0c0','skyblue':'87ceeb','slateblue':'6a5acd','slategray':'708090','slategrey':'708090','snow':'fffafa','springgreen':'00ff7f','steelblue':'4682b4','tan':'d2b48c','teal':'008080','thistle':'d8bfd8','tomato':'ff6347','turquoise':'40e0d0','violet':'ee82ee','wheat':'f5deb3','white':'ffffff','whitesmoke':'f5f5f5','yellow':'ffff00','yellowgreen':'9acd32'}

def output(rgba, alpha=None):
	def rgbaToHsla (rgba):
		if (type(rgba) != dict or set(rgba.keys()) != set(['r','g','b','a'])):
			return
		
		maximium = max(rgba['r'], rgba['g'], rgba['b'])
		minimum = min(rgba['r'], rgba['g'], rgba['b'])
		h = s = l = (minimum + maximum) / float(2)
		if (maximum == minimum): # color is greyscale
			h = s = 0
		else:
			difference = maximum - minimum
			if (l > 0.5):
				s = difference / (2 - maximum - minimum)
			else:
				s = difference / (maximum + minimum)
			
			if (maximum == rgba['r']):
				h = (g - b) / difference + (6 if (g < b) else 0)
			elif (maximum == rgba['g']):
				h = (b - r) / difference + 2
			elif (maximum == rgba['b']):
				h = (r - g) / difference + 4
			h /= float(6)
		return {'h': h, 's': s, 'l': l, 'a': a}
	
	global names
	hsla = rgbaToHsla(rgba)
	hexa = hex((1 << 24) | (rgba255.r << 16) | (rgba255.g << 8) | rgba255.b)[1:] + hex((1 << 8) | rgba255.a)[1:]
	rgba255 = {}
	for channel, value in rgba:
		rgba255[channel] = round(value * 255)
	
	# CSS logic
	if (alpha == False or (alpha == None and rgba['a'] == 1)): # When alpha is None, decide automatically
		outputFormats['CSS_Hex']= '#{}'.format(hexa[:-2])
		outputFormats['CSS_HSL']= 'hsl({}, {}%, {}%)'.format(round(hsla.h * 360), round(hsla.s * 100, 1), round(hsla.l * 100, 1))
		# Finds named colors from names array
		for name, hexcode in names:
			if (hexcode == hexa[:-2]):
				outputFormats['CSS_Named']= name
				break
		outputFormats['CSS_RGB']= 'rgb({}, {}, {})'.format(rgba255.r, rgba255.g, rgba255.b)
		outputFormats['CSS_RGBpcnt']= 'rgb({}%, {}%, {}%)'.format(round(rgba['r'] * 100, 1), round(rgba['g'] * 100, 1), round(rgba['b'] * 100, 1))
		
	elif (alpha == True or (alpha == None and rgba['a'] != 1)):
		outputFormats['CSS_Hex']= '#{}'.format(hexa)
		outputFormats['CSS_HSL']= 'hsl({}, {}%, {}%)'.format(round(hsla.h * 360), round(hsla.s * 100, 1), round(hsla.l * 100, 1))
		# There are no named colors with alpha values
		outputFormats['CSS_RGB']= 'rgb({}, {}, {})'.format(rgba255.r, rgba255.g, rgba255.b)
		outputFormats['CSS_RGBpcnt']= 'rgb({}%, {}%, {}%)'.format(round(rgba['r'] * 100, 1), round(rgba['g'] * 100, 1), round(rgba['b'] * 100, 1))
	# [CG|NS|UI]Color logic
	if (hsla.s == 0): # Color is grayscale
		outputFormats['CGColor']= 'CGColorCreateGenericGray({}, {})'.format(round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['NSColor_CalibratedHSL']= '[NSColor colorWithCalibratedWhite:{} alpha:{}]'.format(round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['NSColor_CalibratedRGB']= '[NSColor colorWithCalibratedWhite:{} alpha:{}]'.format(round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['NSColor_DeviceHSL']= '[NSColor colorWithDeviceWhite:{} alpha:{}]'.format(round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['NSColor_DeviceRGB']= '[NSColor colorWithDeviceWhite:{} alpha:{}]'.format(round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['UIColor_HSL']= '[UIColor colorWithWhite:{} alpha:{}]'.format(round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['UIColor_RGB']= '[UIColor colorWithWhite:{} alpha:{}]'.format(round(hsla.l, 3), round(hsla.a, 3))
	else:
		outputFormats['CGColor']= 'CGColorCreateGenericRGB({}, {}, {}, {})'.format(round(rgba['r'], 3), round(rgba['g'], 3), round(rgba['b'], 3), round(rgba['a'], 3))
		outputFormats['NSColor_CalibratedRGB']= '[NSColor colorWithCalibratedRed:{} green:{} blue:{} alpha:{}]'.format(round(rgba['r'], 3), round(rgba['g'], 3), round(rgba['b'], 3), round(rgba['a'], 3))
		outputFormats['NSColor_CalibratedHSL']= '[NSColor colorWithCalibratedHue:{} saturation:{} brightness:{} alpha:{}]'.format(round(hsla.h, 3), round(hsla.s, 3), round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['NSColor_DeviceHSL']= '[NSColor colorWithDeviceHue:{} saturation:{} brightness:{} alpha:{}]'.format(round(hsla.h, 3), round(hsla.s, 3), round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['NSColor_DeviceRGB']= '[NSColor colorWithDeviceRed:{} green:{} blue:{} alpha:{}]'.format(round(rgba['r'], 3), round(rgba['g'], 3), round(rgba['b'], 3), round(rgba['a'], 3))
		outputFormats['UIColor_HSL']= '[UIColor colorWithHue:{} saturation:{} brightness:{} alpha:{}]'.format(round(hsla.h, 3), round(hsla.s, 3), round(hsla.l, 3), round(hsla.a, 3))
		outputFormats['UIColor_RGB']= '[UIColor colorWithRed:{} green:{} blue:{} alpha:{}]'.format(round(rgba['r'], 3), round(rgba['g'], 3), round(rgba['b'], 3), round(rgba['a'], 3))
		return outputFormats

def parse(query=None):
	if (query == None): return
	matches = {}
	query = query.lower()
	if (query[:1] == '#'):
		query = query[1:]
		if (len(query) <= 3):
			[query[i]+query[i] for i in range(0, len(query))]
		else:
			[query[i:i+2] for i in range(0, len(query), 2)]
		print 'CSS Hexadecimal'
	elif (query[:3] == 'hsl'):
		print 'CSS HSL'
	elif (query[:3] == 'rgb'):
		print 'CSS RGB'
	elif (query[:2] == 'cg'):
		print 'CGColor'
	elif (query[:2] == 'ns'):
		print 'NSColor'
	elif (query[:2] == 'ui'):
		print 'UIColor'

def preview(rgba, hexcode):
	image = pngcanvas.PNGCanvas(128, 128)
	checker = open('checker.png', 'r')
	image.load(checker)
	image.color = [int(round(rgba['r'] * 255)), int(round(rgba['g'] * 255)), int(round(rgba['b'] * 255)), int(round(rgba['a'] * 255))]
	image.filledRectangle(8, 8, 120, 120)
	image.color = [255, 255, 255, 255]
	image.rectangle(4, 4, 123, 123)
	image.rectangle(5, 5, 122, 122)
	image.rectangle(6, 6, 121, 121)
	image.rectangle(7, 7, 120, 120)
	#path = alp.cache() + '/' + hexcode + '.png'
	path = hexcode + '.png'
	file = open(path, 'w+')
	file.seek(0)
	file.write(image.dump())
	file.close()
	# print(image.dump(), path)
	return path

parse('#fff000')
#preview({'r': 1, 'g': 0, 'b': 0, 'a': 0.5}, 'ff0000ff')