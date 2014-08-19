import Data.Text
import System.Directory
import qualified Data.List as L
import System.Environment(getArgs)

xmlFlatternSource = pack "><"
xmlFlatternDest = pack ">\n<"

--cared = ['\r']

flat :: String -> String
flat s = unpack $ replace xmlFlatternSource xmlFlatternDest (pack s)

main = do
	args <- getArgs
	print (args)
	let isOutNameChange = case args of
		["-notchange"] -> False
		_ -> True

	curdir <- getCurrentDirectory
	files <- getDirectoryContents curdir
	let xmlfiles = L.filter (L.isSuffixOf ".xml") files
	let xmlfiles' = if isOutNameChange then L.map (++ ".out.xml") xmlfiles else xmlfiles
	mapM print xmlfiles
	xmlfilesContent <- mapM (readFile) xmlfiles
	let xmlfilesFlatContent = L.map (flat) xmlfilesContent
	mapM (\(name, con)-> writeFile name con) (L.zip xmlfiles' xmlfilesFlatContent)
	
	print "End."
