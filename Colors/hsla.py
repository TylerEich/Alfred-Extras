def rgbaToHsla (r, g, b, a):
    maximum = max(r, g, b)
    minimum = min(r, g, b)
    h = s = l = (minimum + maximum) / float(2)
    if (maximum == minimum): # color is greyscale
        h = s = 0
    else:
        difference = maximum - minimum
        if (l > 0.5):
            s = difference / (2 - maximum - minimum)
        else:
            s = difference / (maximum + minimum)

        if (maximum == r):
            h = (g - b) / difference + (6 if (g < b) else 0)
        elif (maximum == g):
            h = (b - r) / difference + 2
        elif (maximum == b):
            h = (r - g) / difference + 4
        h /= float(6)
    print "hsla(%d, %.2f%%, %.2f%%, %.2f)\n".format(int(round(h*100)), (s * 100), (l * 100), float(a))
rgbaToHsla(1, 0.5, 0.25, 0.125)