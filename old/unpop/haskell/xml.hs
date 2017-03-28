import qualified Data.Tree.Class as Tree
import Data.Tree.NTree.TypeDefs
import qualified Text.XML.HXT.DOM.FormatXmlTree as F
import qualified Text.XML.HXT.Parser.XmlParsec as P
import qualified Text.XML.HXT.Core as H
import qualified Text.XML.HXT.DOM.QualifiedName as QN
import qualified Text.XML.HXT.DOM.XmlNode as XN
import Data.Monoid
import qualified Text.XML.HXT.DOM.ShowXml as SX
import Data.UUID -- toString fromString
import Data.UUID.V4 -- nextRandom
import Data.Text(count, pack)
import Data.List(nub,delete)
--import qualified Text.XML.HXT.DOM.XmlTreeFilter as R
{-TODO
- [x] Функцию заменяющую тэг с атрибутом с *данным* именем, с текстом на *данный* текст
        тип :: XNode -> String -> String -> XNode
        арг node attrName newText
            - [x] сделаем тестовые данные, заменим текст тэга с атрибутом target 
                "<not notarget='f'>text</not>"
                "<tot target='s'>source</tot>" -> "<tot target='s'>dest</tot>"
        - [x] функцию проверки тэга :: attrnode tagName tagText :: XNode -> String -> String -> Bool
- [x] Функцию заменяющую тэг с атрибутом с *данным* именем и *данным* значением, с текстом на *данный* текст
- [x] промапить данной функцией всё дерево, вглубь
    - [x] надо лучше протестировать
- [ ] скопировать и почистить исходник от тестового хлама
 - [x] надо сделать замену не текста в этом теге а текста в определённом теге
        Функцию заменяющую содержание текста тегов содержащихся в тэге с атрибутом с *данным* именем и *данным* значением
- [ ] заменять UUID все на новые
    - [x] разобраться с генерацией UUID
    - [+] заменять не просто на текст, а передавать функцию принимающую предыдущее значения текста и возвр. новое
    - [+] хранить список пар заменённых
        - [-] сделать с помощью монады State
          - [-] понять Monad State
    - [.] заменять одинаковые на одинаковые
    - [ ] и в ссылках тоже
    - [ ] и в тексте тож
- [ ] опционально заменять versionFirst true/false
- [ ] заменять время versionStartTime на новое везде
    - [ ] узнать как получить текущее время
    - [ ] перевести его в нужный формат
- [ ] в конце в строке заменять старые уиды(мы же их ещё храним) на новые (в dataSourceRef - uuid)
- [ ] заменять имена ?
- [ ] специально обрабатывать первую строку
- [x] добавить комментарии пока я помню что тут творится
  - [ ] продолжать добавлять комментарии
-}
{-
tagTextReplace :: H.XNode -> String -> String -> H.XNode
--tagTextReplace (H.XTag name trees) attrName newText = 
tagTextReplace x _ _ = x
test1 = "<tot target='s'>source</tot>"
test1x = P.xread test1
test1xa = Tree.getNode $ head test1x
test1xatr = maybe [] id (XN.getAttrl test1xa)
testA = isThatAttr (head (fromMaybe $ getAttr $ head test1x)) "target" "s"
testrepltext1 = Tree.getChildren $ head test1x
testrepltext2 = fromMaybe $ XN.getText $ head  $ Tree.getChildren $ head test1x

test2 = P.xread "<tot otherattr='da' target='s'>source</tot>"
test2AttrsIs = or $ (fmap (\x-> isThatAttr x "target" "s") (getAttrf $ head test2))
test3 = replaceTextIn (head test1x) "NEWTEXT" "target" "s"
test3n = P.xread "<tot otherattr='da' targets='s'>source</tot>"
test3a = P.xread "<tot otherattr='da' target='a'>source</tot>"
test3nn = replaceTextIn (head test3n) "NEWTEXT" "targets" "s"
test3aa = replaceTextIn (head test3a) "NEWTEXT" "target" "s"
-}
eqQNameStr :: QN.QName -> String -> Bool
eqQNameStr q s = (QN.qualifiedName q) == s
-- тот ли это атрибут, проверяем по имени и значению
isThatAttr :: NTree H.XNode -> String -> String -> Bool
-- сопоставляем со структурой узла аттрибута и проверяем
isThatAttr (NTree (H.XAttr qname) [NTree (H.XText text) []]) tagName tagText | (QN.qualifiedName qname) == tagName && text == tagText = True
isThatAttr _ _ _ = False

-- заменяем текст в ноде с конкретным аттрибутом
replaceTextIn :: NTree H.XNode -> String -> String -> String -> NTree H.XNode
-- сопоставляем структуру узла
replaceTextIn n@(NTree (H.XTag tagName attrList) childWithText) newText attrName attrVal = 
-- если там есть хоть один такой аттрибут
    if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
    -- то заменяем текст в дочерних узлах
        (NTree (H.XTag tagName attrList) (replaceText childWithText newText))
        else (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextIn x newText attrName attrVal) childWithText)) 
replaceTextIn n _ _ _ = n

-- замена значений текстовых узлов 
replaceText :: H.XmlTrees -> String -> H.XmlTrees
-- сопоставляем и конструируем туже структуру но с новым значением
replaceText ((NTree (H.XText _) [])  : other) newText = ((NTree (H.XText newText) [])  : other)
replaceText n _ = n

-- заменяем текст в дочерних узлах с конкретным именем, в ноде с конкретным аттрибутом
replaceTextInChild :: NTree H.XNode -> String -> String -> String -> String -> NTree H.XNode
replaceTextInChild n@(NTree (H.XTag tagName attrList) childs) newText attrName attrVal inTag = 
-- аналогично, но применяем мап заменой
    if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
        (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextChild x newText inTag) childs ))
        else (NTree (H.XTag tagName attrList) (fmap (\x-> replaceTextInChild x newText attrName attrVal inTag ) childs)) 
replaceTextInChild n _ _ _ _ = n

-- замена текста в одном дочернем узле с определённым именем
replaceTextChild :: H.XmlTree -> String -> String -> H.XmlTree
replaceTextChild n@(NTree (H.XTag tagName a) childWithText) newText inTag | (QN.qualifiedName tagName) == inTag = 
    (NTree (H.XTag tagName a) (replaceText childWithText newText))
replaceTextChild n _ _ = n

-- применяет замену по всему дереву
replaceTextInChilds :: [NTree H.XNode] -> String -> String -> String -> String -> [NTree H.XNode]
replaceTextInChilds nodes t a v n = fmap (\x-> replaceTextInChild x t a v n) nodes

-- тип для списка уидов, найденных и на что заменённых
type OldUUIDs = [(String,UUID)]
-- список уидов и индекс последнего использованного
{-type NewUUIDs = ([UUID], Int)
 -- функции замены для UUID
--type TextNodeChgFun = String -> ReplaceState -> (String, ReplaceState)
type UUIDState = State UUIDchgState UUIDchgState
type TextNodeChgFun = UUIDState
--type ReplaceState = (NewUUIDs, OldUUIDs)
--type XmlTreeState = (H.XmlTrees, ReplaceState)
type UUIDchgState = (H.XmlTrees, NewUUIDs, OldUUIDs, NTree H.XNode)
four (_,_,_,x)=x

f :: TextNodeChgFun
f = get >>= \all@(a,nu,ou, node) -> case node of
        ((NTree (H.XText t) [])  : o) -> return (a,nu,ou,((NTree (H.XText t) [])  : o))
        _ -> all

replaceUUIDInChild :: TextNodeChgFun -> String -> String -> String -> UUIDState
replaceUUIDInChild newUuidFun attrName attrVal inTag = 
    get >>= \allstate@(xt, nu, ou, node)-> case node of
        n@(NTree (H.XTag tagName attrList) childs)) -> 
            if (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) then 
                (NTree (H.XTag tagName attrList) (sequence (modify (\x-> replaceUUIDChild newUuidFun inTag ) childs )) 
            else (NTree (H.XTag tagName attrList) (sequence (replaceUUIDInChild newUuidFun attrName attrVal inTag rs) childs)) 
        otherwise -> allstate
   


replaceUUIDChild :: TextNodeChgFun -> String  -> UUIDState
replaceUUIDChild f inTag =
    get >>= \all@(a,b,c, node) -> case node of
        n@(NTree (H.XTag tagName a) childWithText)
            | (QN.qualifiedName tagName) == inTag ->
                replaceUUID f
                    ( (NTree (H.XTag tagName a) xtree) , state)
        _ -> all

replaceUUID :: TextNodeChgFun -> UUIDState
replaceUUID f = 
    get >>= \all@(_,_,_, node) -> case node of
        ((NTree (H.XText _) [])  : _) -> f all
        _ -> all

replaceUUIDInChilds :: [NTree H.XNode] -> TextNodeChgFun -> String -> String -> String  -> UUIDState -> [NTree H.XNode]
replaceUUIDInChilds nodes t a v n rs = fmap (replaceUUIDInChild t a v n rs) nodes

может обойдёмся без состояния? можно например сделать двухпроходно:
сначала пройтись и собрать (результат не дерево а только список) все уиды(уникальные только)
подсчитать их, сгенерить нужное количество новых, собрав в список замен их. и с этими данными
запустить другой обход, который и заменит соответственным образом.
получится?
- [ ] попробовать данным образом сделать
  - [x] первый проход. сбор значений в список\множество nub
    - [x] сделать нормальный общий обход fold и саккумулировать уже что надо. как только его сделать условным? это уже есть и зипер тож
       есть фмап. фолд. можно ещё больше декомпозировать:
        [x] обойти и собрать нужные узлы (с атрибутом требуемым)
        [x] извлечь из них нужные данные
  - [x] сделать список замен
  - [ ] обход использующий список замен
    - [x] фун - взять нужный уид для замены

mapXml :: H.XmlTrees -> (H.XNode -> a) -> [NTree a]
mapXml t f = fmap (\x->fmap f x) t -- mapXml f = fmap . fmap f
filterXml :: H.XmlTrees -> (H.XNode -> Bool) -> H.XmlTrees
filterXml t f = mapXml t (\x-> if (f x) then x else H.XCmt "")

getThatAttrNode :: H.XmlTrees -> String -> String -> H.XmlTrees
getThatAttrNode t attrName attrVal = filterXml t (\x-> isThatAttr x attrName attrVal)
-- а вот надо обойти не ноды а все деревья и поддеревья в XTag
-}
mapXMLtags :: H.XmlTrees -> (H.XmlTree -> H.XmlTrees) -> H.XmlTrees
mapXMLtags (h:t) f = (everyNTree h f) ++ (mapXMLtags t f)
mapXMLtags [] _ = []

everyNTree :: NTree H.XNode -> (H.XmlTree -> H.XmlTrees) -> H.XmlTrees
everyNTree t@(NTree (H.XTag qname attrs) other) f = (f t) ++ (mapXMLtags other f) ++ (mapXMLtags attrs f) 
everyNTree t@(NTree (H.XAttr qname) text) f = (f t) 
everyNTree x f = []

-- TODO и с проверкой имени
testNodeWithAttr :: NTree H.XNode -> (NTree H.XNode -> String -> String -> Bool) -> String -> String -> [NTree H.XNode]
testNodeWithAttr t@(NTree (H.XTag qname attrList) other) f  attrName attrVal
	| (or (fmap (\x-> isThatAttr x attrName attrVal) attrList)) = [t]
	| otherwise = []
testNodeWithAttr _ _ _ _ = []

testMapXml a b = mapXMLtags testXML (\x->testNodeWithAttr x isThatAttr a b)

r = testMapXml "x" "X"
y = mapXMLtags testXML (\x->[x])
tf a b = (\x->if (isThatAttr x a b) then [NTree (H.XText "**YES**") []] else [])

mapXML tagName tagVal xml = mapXMLtags xml (\x->testNodeWithAttr x isThatAttr tagName tagVal)
t = mapXML "y" "uuid" testXML
testCount = length (mapXML "y" "uuid" testXML)

extractUUIDs :: H.XmlTrees -> [String]
extractUUIDs nodes = delete "" $ nub $ concat (fmap getXText nodes)

extractUUIDv nodes tagName = delete "" $ nub $ concat (fmap (getSubTagXText tagName) nodes )

getSubTagXText :: String -> NTree H.XNode -> [String]
getSubTagXText tagName (NTree (H.XTag _ _) tags) = concat $ fmap getXText (filter (\x->case x of (NTree (H.XTag qname _) _) -> eqQNameStr qname tagName; _ -> False) tags)
getSubTagXText _ _ = []


getXText :: NTree H.XNode -> [String]
getXText (NTree (H.XTag _ _) texts) = fmap extractText texts
getXText _ = []
extractText :: NTree H.XNode -> String
extractText (NTree (H.XText text) _) = text
extractText _ = ""
ex = extractUUIDs t

-- ---
countUUIDs :: String -> Int
countUUIDs input = count (pack "uuid") (pack input)

genEnoghUUIDs :: String -> IO [UUID]
genEnoghUUIDs xml = mapM (\_->nextRandom) [1..(countUUIDs xml)]

makeUUIDmap :: [String] -> IO OldUUIDs
makeUUIDmap us = mapM (\x-> nextRandom >>= \new-> return (x, new)) us

takeUUID :: String -> OldUUIDs -> String
takeUUID s u = (toString . snd . head) (filter (\(x,y)->s==x) u)

{- стандартная фун замены uuid. должна: 
    - [ ] поискать в сохранённых уидах текущий. если есть взять тот на который его надо заменить.
    - [ ] иначе взять следующий уид. изменить состояние
    - [ ] выдать полученный uuid и новое состояние.
-}
--uuidChgFun :: TextNodeChgFun
--uuidChgFun t (u,s) = 

{-
getAttr :: H.XmlTree -> Maybe H.XmlTrees
getAttr = XN.getAttrl . Tree.getNode 

getAttrf :: H.XmlTree -> H.XmlTrees
getAttrf = fromMaybe . XN.getAttrl . Tree.getNode 

fromMaybe :: (Monoid a) => Maybe a -> a
fromMaybe a = maybe mempty id a

replaceInTree :: H.XmlTrees -> String -> String -> String -> H.XmlTrees
replaceInTree tree text attrName attrVal = fmap (\x-> replaceTextIn x text attrName attrVal ) tree
-}
{-NTree (XTag "tot" 
                [NTree (XAttr "target") 
                       [NTree (XText "s") []]])
      [NTree (XText "source") []] -}
--то есть надо у тэга проверить атрибут и если он подходит то найти текст и если он есть заменить его
-- всякие тесты
testXML = P.xread "<a><A y='uuid'>tx</A></a><b z='Z'>ss</b><c x='X' xx='_'><e:e><f:f y='uuid'><v>val</v><v:v>val2</v:v></f:f></e:e></c>"
b = F.formatXmlTree $ head testXML
c = putStrLn b

d = fmap F.formatXmlTree testXML
e = mapM putStrLn d
showx x = mapM putStrLn (fmap F.formatXmlTree x)

f = head testXML
g (H.XText x) = H.XText $ "new" ++ x
g x = x 
h = fmap g f
i = showx [h]
-- ============
ftest = fmap (\x-> replaceTextIn x "" "" "" ) testXML
ftesta a b c = fmap (\x-> replaceTextIn x a b c ) testXML
ptest a b c = showx (ftesta a b c)

rtest a b c d = fmap (\x-> replaceTextInChild x a b c d) 
rr a b c d e = showx (rtest a b c d e)

xmlheader = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" -- уже flatten должен быть
magicNumber = length xmlheader
--testUUIDreplace = replaceUUIDInChilds testXML (\_->nextRandom) "" "" ""
filetest = do 
			con <- readFile "d:\\Q\\2123\\test.xml"
			let cona = drop magicNumber con
			return $ P.xread cona
tgetsvuuid = filetest >>= \x-> return $ (mapXML "sv:name" "jcr:uuid" x)
tgetsvuuide = filetest >>= \x-> return $ extractUUIDs (mapXML "sv:name" "jcr:uuid" x)
textractUUIDv = tgetsvuuid >>= \x-> return $ extractUUIDv x "sv:value" -- !!
tmakeUUIDmap = textractUUIDv >>= makeUUIDmap
ttakeUUID = tmakeUUIDmap >>= \x-> return $ takeUUID "ada3d887-c693-4375-9c8e-b9a73cb80c69" x

extest = do 
    con <- readFile "d:\\Q\\2123\\test.xml"
    let res = extractUUIDs (mapXML "sv:name" "jcr:uuid" (P.xread con))  
    
    --writeFile "d:\\Q\\2123\\testout.xml" (SX.xshow res)
    print res
    print "ok"
    
mtest = do 
    con <- readFile "/home/ksi/dev/testweb/1.xml"
    let res = replaceTextInChilds (P.xread con) "NEWTEXT" "sv:name" "jcr:uuid" "sv:value"
    let res' = replaceTextInChilds res "NEWVERSION" "sv:name" "fm:versionName" "sv:value"
    
    writeFile "/home/ksi/dev/testweb/out.xml" (SX.xshow res')
    print "ok"

main = do 
    
    print "end."
