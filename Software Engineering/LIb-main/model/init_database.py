import pymysql

CONFIG = {   #配置信息字典 mysql
    "host": '127.0.0.1',
    "port":3306 , 
    "user": 'root',  
    "pwd": '0129mwhm',
    'db': 'library'
}

conn=pymysql.connect(host= CONFIG['host'],user=CONFIG['user'],password=CONFIG['pwd'],port=CONFIG['port'])

cursor = conn.cursor()
conn.autocommit(True)
# cursor.execute('''DROP DATABASE IF EXISTS library''')
conn.commit()
# cursor.execute('''CREATE DATABASE library''')
conn.autocommit(False)
cursor.execute('''use library''')
cursor.execute(
        '''
        drop table if exists add_log
        '''
)
# cursor.execute('''
#         CREATE TABLE log(
#             BID char(15),
#             SID char(15),
#             BORROW_DATE char(17),
#             BACK_DATE char(17),
#             PUNISHED int,
#             PRIMARY KEY(BID, SID,BORROW_DATE,BACK_DATE)
#         )
# ''')
# cursor.execute('''
#         alter table log
#         Add constraint FK_log
#         foreign key (BORROW_DATE) references borrowing_book(BORROW_DATE)
        
# ''')

# cursor.execute('''
#         alter table log
#         Add constraint FK_log_book
#         foreign key (BID) references book(BID)
# ''')

# cursor.execute('''
#         alter table log
#         Add constraint FK_log_student
#         foreign key (SID) references student(SID)
# ''')


# cursor.execute('''
#         alter table borrowing_book
#         Add constraint FK_borrowing_book_student
#         foreign key (SID) references student(SID)
# ''')

# cursor.execute('''
#         alter table borrowing_book
#         Add constraint FK_borrowing_book_book
#         foreign key (BID) references book(BID)
# ''')

# cursor.execute('''
#         alter table classification
#         Add constraint FK_classification_book
#         foreign key (BID) references book(BID)
# ''')

cursor.execute(
        '''
        create table add_log(
                bid char(15),
                bname text,
                add_date date,
                add_days int,
                primary key(bid,add_date)
        )
        '''
)
cursor.execute(
        '''
        alter table add_log
        add constraint FK_add_log
        foreign key(bid) references book(bid)
        '''
)

conn.commit()
# if __name__ == '__main__':
#     init_database()