import pymysql
 
 
CONFIG = {   #配置信息字典 mysql
    "host":'127.0.0.1',
    "port":3306, 
    "user": 'root',  
    "pwd": '0129mwhm',
    'db': 'library'
}

# 打开数据库连接
db = pymysql.connect(host= CONFIG['host'],user=CONFIG['user'],password=CONFIG['pwd'],port=CONFIG['port'],database=CONFIG['db'])
 
# 使用 cursor() 方法创建一个游标对象 cursor
cursor = db.cursor()
sql=""" 
        CREATE TABLE student(
        SID char(15) PRIMARY KEY,
        PASSWORD char(70),
        SNAME text,
        DEPARTMENT nchar(20),
        MAJOR char(20))"""
cursor.execute(sql)

# 使用 execute()  方法执行 SQL 查询 
cursor.execute("SELECT VERSION()")
 
# 使用 fetchone() 方法获取单条数据.
data = cursor.fetchone()
 
print ("Database version : %s " % data)
 
# 关闭数据库连接
db.close()