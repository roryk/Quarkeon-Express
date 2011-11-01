import os.path
import sys
from PIL import Image

def main(theSprite, theMask, theTargetDir, theOutputName):
	theSprite=Image.open(theSprite)
	theSprite=theSprite.convert('RGBA')
	theBox= theSprite.getbbox()
	theSize= theSprite.size
	newImage= Image.new('RGBA', theSize)
	theMask=Image.open(theMask)
	theMask=theMask.convert('L')
	newImage.paste(theSprite, theBox, theMask)
	#print "ok to here"
	newImage.save(theTargetDir+'/'+theOutputName+'.png')

if __name__=='__main__':
	thisName=sys.argv[0]
	try:
		theSprite=sys.argv[1]
		#print theSprite
		theMask=sys.argv[2]
		#print theMask
		theTargetDir=os.path.dirname(theSprite)
		#print theTargetDir
		theOutputName=os.path.splitext(theSprite)[0]
		theOutputName=os.path.basename(theOutputName)+'-spritesheet'
		#print theOutputName
	except:
		print "Usage: python %s spriteFile maskFile" % (thisName)
		sys.exit(0)
	main(theSprite, theMask, theTargetDir, theOutputName)