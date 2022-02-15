import pymysql


CONFIG = {   #配置信息字典 mysql
    "host": '127.0.0.1',
    "port":3306 , 
    "user": 'root',  
    "pwd": '0129mwhm',
    'db': 'library'
}

def init_view():
    try:
        conn=pymysql.connect(host= CONFIG['host'],user=CONFIG['user'],password=CONFIG['pwd'],port=CONFIG['port'],database=CONFIG['db']) 

        cursor=conn.cursor()
        conn.autocommit(False)

        # 对应database文件获取学生借书信息部分
        # database 文件636行

        cursor.execute(
            '''
            CREATE VIEW sel_borrowing_info as
            SELECT SID, book.BID, BNAME, BORROW_DATE, DEADLINE, PUNISH, NUM
            from borrowing_book,book
            where book.bid=borrowing_book.bid
            '''
        )

        cursor.execute(
            '''
            create view sel_add_book_info as
            select book.bid,book.bname,add_date,add_days
            from book,add_log
            where book.bid=add_log.bid
            order by add_date
            '''
        )
        conn.commit()
    except Exception as e:
        print("视图定义失败")
        print(e)
    finally:
        if conn:
            conn.close()

def init_procedure():
    try:
        conn=pymysql.connect(host= CONFIG['host'],user=CONFIG['user'],password=CONFIG['pwd'],port=CONFIG['port'],database=CONFIG['db'])
        cursor=conn.cursor()
        conn.autocommit(False)
        #对应database文件还书部分
        #第705行
        cursor.execute(
            '''
            create procedure return_book(
            in innum int,
            in inbid char(15),
            in insid char(15),
            in inborrow_date char(17),
            in inback_date char(17),
            in inpunish char(17)
            )
            begin
            update book
            set num=innum
            where bid=inbid;
            delete
            from borrowing_book
            where sid=insid and bid=inbid;
            insert
            into log
            values(inbid,insid,inborrow_date,inback_date,inpunish);
            end
            '''
        )

        conn.commit()
    except Exception as e:
        print('存储过程建立失败')
        print(e)
    finally:
        if conn:
            conn.close()
def init_trigger():
    
    try:
        conn=pymysql.connect(host= CONFIG['host'],user=CONFIG['user'],password=CONFIG['pwd'],port=CONFIG['port'],database=CONFIG['db'])
        cursor=conn.cursor()
        conn.autocommit(False)
        cursor.execute(
            '''
            drop trigger if exists add_his
            '''
        )
        cursor.execute(
            '''
                create trigger add_his after insert on book
                for each row
                begin
                    insert 
                    into add_log
                    values(new.bid,new.bname,CurDate(),0);
                end

            '''
        )
    except Exception as e:
        print('触发器创建失败')
        print(e)

    finally:
        if conn:
            conn.close()
            

def init_event():
    try:
        conn=pymysql.connect(host= CONFIG['host'],user=CONFIG['user'],password=CONFIG['pwd'],port=CONFIG['port'],database=CONFIG['db'])
        cursor=conn.cursor()
        '''
        定义与时间有关的存储过程实现添加天数的自动更新,使用MySQL event即'时间触发器'
        '''
        #开启event_scheduler 
        cursor.execute(
            '''
            set global event_scheduler = ON
            '''
        )
        cursor.execute(
            '''
            create procedure update_add_days()
            begin
                declare add_da date ;
                declare now_date date;
                declare diff_days int;
                select add_date into add_da from sel_add_book_info;
                select CurDate() into now_date;
                select DateDiff(now_date,add_da) into diff_days ;
                if(diff_days = 1)
                then
                    update add_log 
                    set add_days=add_days+1 
                    where add_log.bid in
                    (select book.bid from book);
                end if;
            end
            '''
        )
        #创建定时器，每隔一天调用一次存储过程
        cursor.execute(
            '''
            create event event_remind_add_books_days
            ON SCHEDULE EVERY 1 day do
            begin
            call update_add_days();
            end
            '''
        )
        cursor.execute(
            '''
            ALTER EVENT event_remind_add_books_days ON    
            COMPLETION PRESERVE ENABLE; 
            '''
        )
    except Exception as e:
        print('时间触发器创建失败')
        print(e)

    finally:
        if conn:
            conn.close()    

if __name__ == '__main__':
    # init_view()
    # init_procedure()
    # init_trigger()
    # init_event()
    print('结束')
