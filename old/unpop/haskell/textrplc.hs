import Data.Text
import System.Directory

--test1 = unpack (replace (pack "><") (pack ">\n<") (pack "<some></dome>\n"))
fileName = "d:\\Q\\2123\\new\\veiw\\rep\\EPBS_004_001_report testH.xml"
--TODO: process all files xml in cur dir
xmlFlatternSource = pack "><"
xmlFlatternDest = pack ">\n<"

deleteFMextra = pack "<sv:property sv:name=\"fm:extra\" sv:type=\"String\">\n<sv:value>\n</sv:value>\n</sv:property>"
deleteFMmulti = pack "<sv:property sv:name=\"fm:multi\" sv:type=\"String\">\n<sv:value>false</sv:value>\n</sv:property>"
nothingText = pack ""
{-
getCurrentDirectory
getDirectoryContents 
-}

main = do
	--putStr test1
	--content <- readFile fileName
	--let result = unpack $ replace xmlFlatternSource xmlFlatternDest (pack content)
	--let result = replace xmlFlatternSource xmlFlatternDest (pack content)
	--writeFile (fileName ++ ".out.xml") result
	curdir <- getCurrentDirectory
	--putStr curdir
	files <- getDirectoryContents curdir
	--mapM print files
	print $ files !! 1
	let firstFile = files !! 1
	content <- readFile firstFile
	print content
	let result = replace xmlFlatternSource xmlFlatternDest (pack content)
	let result' =  replace deleteFMextra nothingText result
	let result'' = unpack $ replace deleteFMmulti nothingText result'
	
	writeFile (firstFile ++ ".out.xml") result''
	
	print "End."
