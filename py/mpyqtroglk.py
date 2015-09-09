#TODO обработка ввода - процедура. персонаж. вещи. редактор.
# область вывода инфы с автопрокруткой, лог
import sys, random, pickle
from PyQt5.QtWidgets import QWidget, QApplication
from PyQt5.QtGui import QPainter, QColor, QFont, QPen
from PyQt5.QtCore import Qt, QRect
# функция создания двухмерного массива(списка списков) с начальным значением
def makeArray2D(w, h, initVal):
    return [[initVal for x in range(w)] for x in range(h)]
#У нас есть тайлы. Тайл - символ с цветом символа и цветом фона
class Tile(object):
    symbol = ' '
    fcolor = QColor(0, 0, 0)
    bcolor = QColor(0, 0, 0, 0)
    
    def __init__(self, s = ' ', f = QColor(0, 0, 0), b = QColor(100, 100, 0)):
        self.symbol = s
        self.fcolor = f
        self.bcolor = b
    
# подвижный тайл
class DynamicTile(Tile):
    x = 0
    y = 0
    
    def __init__(self, s = ' ', x = 0, y = 0, f = QColor(0, 0, 0)):
        self.symbol = s
        self.x = x
        self.y = y
        self.fcolor = f
    
class Player(DynamicTile):
    symbol = '@'
    
    def __init__(self, x = 0, y = 0):
        self.x = x
        self.y = y
        self.fcolor = QColor(200, 0, 0)
    
#из тайлов состоит поле прямоугольное. Поле - массив тайлов, параметры поля.
class Field(object):
    w = 10
    h = 10
    tileWidth = 20
    tileHeight = 20
    tiles = []
    dynamicTiles = []
    player = 0
    # создание изначального поля
    def __init__(self, w = 10,h = 10):
        self.w = w
        self.h = h
        blankTile = Tile()
        self.tiles = makeArray2D(w, h, blankTile)
        self.dynamicTiles.append(DynamicTile('q',1,4, QColor(0, 200, 90)))
        self.player = Player(4,5)
        
        # тестовые тайлы
        a = Tile('D', QColor(0, 0, 0), QColor(100, 100, 250))
        a.fcolor = QColor(0, 0, 220)
        self.tiles[1][1] = a
        b = Tile()
        b.symbol = 'B'
        b.fcolor = QColor(0, 0, 220)
        self.tiles[2][2] = b
        
        for x in range(10):
          n = Tile()
          n.symbol = str(x)
          n.color = QColor(random.randint(10,200), random.randint(10,200), random.randint(10,200))
          self.tiles[x][random.randint(0,self.h-1)] = n

# лог область        
class Log(object):
    log = [] # список строк
    maxLines = 4
    height = 200
    visible = True
    #вывод строк. добавление в лог.

#просто главный класс-окно-приложение
class Example(QWidget):

    width = 580
    height = 470
    #log = 0
    # настройка окна
    def __init__(self):
        super().__init__()
        self.setGeometry(100, 100, self.width, self.height)
        self.setWindowTitle('[]')
        self.log = Log()
        self.log.log.append('test line')
        self.log.log.append('second line')
        self.show()   
    
    def resizeEvent(self,resizeEvent):
        self.height = resizeEvent.size().height()
        self.width = resizeEvent.size().width()
    
    # а тут рисуем
    def paintEvent(self, event):
        # инициализация
        qp = QPainter()
        qp.begin(self)
        # тесты
        qp.setFont(QFont('Lucida Console', 14))
        #size = self.size()
        qp.setBrush(QColor(100, 100, 150))
        qp.setPen(QPen(Qt.black, 2, Qt.SolidLine))
        
        #drawTiles of field. Рисуем тайлы - Вынести в функции(какого класса?)
        for x in range(field.w):
            for y in range(field.h):
                self.drawTile(qp, field.tiles[x][y], x, y)
        # рисуем динамические объекты
        for x in field.dynamicTiles:
            self.drawTile(qp, x, x.x, x.y) 
        self.drawTile(qp, field.player, field.player.x, field.player.y)
        
        # лог
        if self.log.visible:
            qp.setBrush(QColor(50, 50, 100))
            qp.setPen(QPen(Qt.black, 0, Qt.SolidLine))
            qp.drawRect(QRect(0, self.height-self.log.height, self.width, self.log.height))
        
        # финализация
        qp.end()
        
    # функция рисования тайла
    def drawTile(self, qp, t, x, y):
        qp.setPen(t.fcolor)
        qp.setBrush(t.bcolor)
        r = QRect(field.tileWidth*x, field.tileHeight*y, field.tileWidth, field.tileHeight)
        qp.drawRect(r)
        qp.drawText(r, Qt.AlignCenter, t.symbol) 
    
    def keyPressEvent(self, e):
        if e.key() == Qt.Key_Escape:
            self.close()
        if e.key() == Qt.Key_W:
            field.player.y -= 1
        if e.key() == Qt.Key_1:
            self.safeMap()
        if e.key() == Qt.Key_2:
            self.loadMap()
            
        self.update()
        
    def safeMap(self):
        with open('mpytestmap.pmp', 'wb') as f:
            pickle.dump(field, f)
    def loadMap(self):
        with open('mpytestmap.pmp', 'rb') as f:
            global field
            field = pickle.load(f)
            
             
#main
random.seed()
field = Field()
app = QApplication(sys.argv)
ex = Example()
sys.exit(app.exec_())
