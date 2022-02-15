import sys
from PyQt5.QtWidgets import QApplication
from model import main_widget ,database


def main():
    # database.init_database()
    app = QApplication(sys.argv)  ##每一pyqt5应用程序必须创建一个应用程序对象。sys.argv参数是一个列表，从命令行输入参数。
    #QWidget部件是pyqt5所有用户界面对象的基类。他为QWidget提供默认构造函数。默认构造函数没有父类。
    ex = main_widget.MainWindow()#QWidget类型
    ex.show()
    sys.exit(app.exec_())
    #系统exit()方法确保应用程序干净的退出
    #的exec_()方法有下划线。因为执行是一个Python关键词。因此，exec_()代替

if __name__ == '__main__':
    main()
