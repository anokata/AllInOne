from PyQt5.QtGui import QColor, QBrush, QPen, QPainter
from PyQt5.QtWidgets import QWidget, QApplication
from PyQt5.QtCore import QEventLoop, QTime, Qt
import sys, math, random

class W(QWidget):
    def __init__(self):
        super().__init__()
        self.setGeometry(100,100, fieldCellWH*fieldWidht, fieldCellWH*fieldHeight)
        self.setWindowTitle('')
        self.show()
    def paintEvent(self, event):
        qp = QPainter()
        qp.begin(self)
        qp.setBrush(QColor(0, 0, 200))
        #qp.drawRect(10, 10, 60, 60)
        
        for x in range(len(field)):
            for y in range(len(field[x])):
                #qp.setBrush(QColor(0, 0, random.randint(100,200)))
                #qp.setBrush(QColor(0, 0, field[x][y] * 23 ))
                qp.setBrush(colors[field[x][y]] )
                qp.drawRect(x*fieldCellWH, y*fieldCellWH, fieldCellWH, fieldCellWH)
                
        qp.end()
        
    def mousePressEvent(self, e):
        cx, cy = e.x() // fieldCellWH, e.y() // fieldCellWH
        #print(cx, cy, field[cx][cy])
        field[cx][cy] = 0
        #print(dir(self))
        #dropAll3seq(field, findFieldCells(field))
        dropAll(field)
        downFieldCellsAll(field)
        dropAll(field)
        #print(field)
        self.repaint()
        

def findFieldCells(field):
#find all 3+ seq
    same = []
    all3seq = [] #(x,y)
    lastCell = 0
    lastXY = 0
    for x in range(len(field)):
        for y in range(len(field[x])):
            #print("cmp:", field[x][y], lastCell)
            if field[x][y] != 0 and field[x][y] == lastCell and same == []:
                #same.append((x, y))
                same.append((x, y-1))
                lastCell = field[x][y]
                #print("fnd same ", x,y)
            elif field[x][y] != 0 and field[x][y] == lastCell and same != []:
                same.append((x, y))
                lastCell = field[x][y]
            elif field[x][y] == 0:
                lastCell = field[x][y]
            else:
                #print (same)
                same.append((x, y-1))
                if same != []:
                    all3seq.append(same)
                    same = []
                lastCell = field[x][y]
                #print("other ", x,y)
    same = []
    lastCell = 0
    for y in range(len(field)):
        for x in range(len(field[x])):
            #print("cmp:", field[x][y], lastCell)
            if field[x][y] != 0 and field[x][y] == lastCell and same == []:
                #same.append((x, y))
                same.append((x-1, y))
                lastCell = field[x][y]
                #print("fnd same ", x,y)
            elif field[x][y] != 0 and field[x][y] == lastCell and same != []:
                same.append((x, y))
                lastCell = field[x][y]
            elif field[x][y] == 0:
                lastCell = field[x][y]
            else:
                #print (same)
                same.append((x-1, y))
                if same != []:
                    all3seq.append(same)
                    same = []
                lastCell = field[x][y]
                #print("other ", x,y)
    #clear all 2-
    #for x in range(len(all3seq)):
    #    if len(all3seq[x]) < 3:
    #        del all3seq[x]
    all3seq = list(filter(lambda x: len(x) > 2, all3seq))
    return all3seq

def dropAll3seq(field, seq3):
    for s in range(len(seq3)):
        for i in range(len(seq3[s])):
            #print("droped: ", seq3[s][i])
            field[seq3[s][i][0]] [seq3[s][i][1]] = 0
            

def downFieldCells(f):
#find cells than down on 0
    changed = False
    for x in range(len(f)):
        for y in range(len(f[x]) - 1):
            if f[x][y+1] == 0 and f[x][y] != 0:
                f[x][y], field[x][y+1] = 0, f[x][y]
                changed = True
    return changed

def downFieldCellsAll(f):
    while downFieldCells(f):
        pass

def dropAll(field):
    downFieldCellsAll(field)
    s = findFieldCells(field)
    print("S", s)
    dropAll3seq(field, s)
    while s != []:
        print(s)
        dropAll3seq(field, s)
        downFieldCellsAll(field)
        s = findFieldCells(field)
        print(s)

app = QApplication(sys.argv)
random.seed()

colors = [QColor(0,0,0), QColor(100,0,200), QColor(200, 0, 100)]
fieldWidht, fieldHeight = 10, 10
fieldCellWH = 20
#field = [[random.randint(0,2) for x in range(fieldWidht)] for x in range(fieldHeight)]
field = [[0 for x in range(fieldWidht)] for x in range(fieldHeight)]
for x in range(1, len(field) - 1):
    for y in range(1, len(field[x]) - 1):
        field[x][y] = random.randint(1,1)

print(field)
#print(findFieldCells(field))
dropAll(field)
print(field)

w = W()
sys.exit(app.exec_())

#todo: drop-find, while not change; find for vert! and not trou bounds