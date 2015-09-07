#TODO чтение карты из файла. обработка ввода. персонаж. вещи. сохранение карты.
import sys, random
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
#из тайлов состоит поле прямоугольное. Поле - массив тайлов, параметры поля.
class Field(object):
    w = 10
    h = 10
    tileWidth = 20
    tileHeight = 20
    tiles = []
    # создание изначального поля
    def __init__(self, w = 10,h = 10):
        self.w = w
        self.h = h
        blankTile = Tile()
        self.tiles = makeArray2D(w, h, blankTile)
        # тестовые тайлы
        a = Tile()
        a.symbol = 'A'
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
        
        
#просто главный класс-окно-приложение
class Example(QWidget):
    # настройка окна
    def __init__(self):
        super().__init__()
        self.setGeometry(100, 100, 580, 470)
        self.setWindowTitle('[]')
        self.show()   
    
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
                qp.setPen(field.tiles[x][y].fcolor)
                r = QRect(field.tileWidth*x, field.tileHeight*y, field.tileWidth, field.tileHeight)
                qp.drawRect(r)
                qp.drawText(r, Qt.AlignCenter, field.tiles[x][y].symbol) 
        
        # финализация
        qp.end()
        
    # функция рисования тайла
    def drawTile(t):
        pass
     
#main
random.seed()
field = Field()
app = QApplication(sys.argv)
ex = Example()
sys.exit(app.exec_())
