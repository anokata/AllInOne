#TODO 
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
        qp.setPen(QColor(1, 100, 200))
        qp.setFont(QFont('Lucida Console', 14))
        #qp.drawText(event.rect(), Qt.AlignLeft, "Score: ")   
        #qp.drawText(10,100, "Score: \nSecond line\n#..T..#\n##..#.#\n#TTT..#")   
        qp.setPen(Qt.red)
        #size = self.size()
        #qp.drawPoint(2, 2)
        qp.setBrush(QColor(200, 0, 0))
        #qp.drawRect(10, 15, 90, 60)
        pen = QPen(Qt.black, 2, Qt.SolidLine)
        qp.setPen(pen)
        #qp.drawLine(20, 40, 250, 40)
        
        #drawTiles of field. Рисуем тайлы - Вынести в функции(какого класса?)
        for x in range(field.w):
            for y in range(field.h):
                qp.setPen(field.tiles[x][y].fcolor)
                print(x, y)
                qp.drawText(QRect(field.tileWidth*x, field.tileHeight*y, field.tileWidth, field.tileHeight), Qt.AlignLeft, field.tiles[x][y].symbol) 
        
        #тест многострочного текста        
        qp.setBrush(QColor(0, 0, 0))
        qp.setPen(QColor(100,0,0))
        #qp.drawText(QRect(0,0,200,200), Qt.AlignLeft, "Score: \nSecond line\n#..T..#\n##..#.#\n#TTT..#")   
        
        # финализация
        qp.end()
        
    # функция рисования тайла
    def drawTile(t):
        pass
     
#main
field = Field()
app = QApplication(sys.argv)
ex = Example()
sys.exit(app.exec_())
