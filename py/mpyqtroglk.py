import sys, random
from PyQt5.QtWidgets import QWidget, QApplication
from PyQt5.QtGui import QPainter, QColor, QFont, QPen
from PyQt5.QtCore import Qt, QRect

def makeArray2D(w, h, initVal):
    return [[initVal for x in range(w)] for x in range(h)]

class Tile(object):
    symbol = ' '
    fcolor = QColor(0, 0, 0)
    bcolor = QColor(0, 0, 0, 0)

class Field(object):
    w = 10
    h = 10
    tileWidth = 20
    tileHeight = 20
    tiles = []
    
    def __init__(self, w = 10,h = 10):
        self.w = w
        self.h = h
        blankTile = Tile()
        self.tiles = makeArray2D(w, h, blankTile)
        self.tiles[1][1].symbol = 'A'
        self.tiles[1][1].fcolor = QColor(0, 0, 220)
        

class Example(QWidget):
    
    def __init__(self):
        super().__init__()
        self.setGeometry(100, 100, 580, 470)
        self.setWindowTitle('[]')
        self.show()   
        
    def paintEvent(self, event):
        qp = QPainter()
        qp.begin(self)
        qp.setPen(QColor(1, 100, 200))
        qp.setFont(QFont('Lucida Console', 14))
        #qp.drawText(event.rect(), Qt.AlignLeft, "Score: ")   
        #qp.drawText(10,100, "Score: \nSecond line\n#..T..#\n##..#.#\n#TTT..#")   
        
        qp.setPen(Qt.red)
        #size = self.size()
        qp.drawPoint(2, 2)

        qp.setBrush(QColor(200, 0, 0))
        qp.drawRect(10, 15, 90, 60)
        
        pen = QPen(Qt.black, 2, Qt.SolidLine)

        qp.setPen(pen)
        qp.drawLine(20, 40, 250, 40)
        
        #drawTiles of field
        for x in range(field.w):
            for y in range(field.h):
                qp.setPen(field.tiles[x][y].fcolor)
                qp.drawText(event.rect(), Qt.AlignCenter, field.tiles[x][y].symbol) 
                
        qp.setBrush(QColor(0, 0, 0))
        qp.setPen(QColor(100,0,0))
        qp.drawText(QRect(0,0,200,200), Qt.AlignLeft, "Score: \nSecond line\n#..T..#\n##..#.#\n#TTT..#")   
        qp.end()
        
    def drawTile(t):
        pass
     
#main
field = Field()
app = QApplication(sys.argv)
ex = Example()
sys.exit(app.exec_())
