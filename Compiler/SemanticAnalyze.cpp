/*
 * @Date: 2022-06-08 19:41:21
 * @LastEditors: turtlepig
 * @LastEditTime: 2022-06-12 02:56:58
 */
//暂时只针对简单赋值语句的语法分析，测试用例不涉及其他类型的语义分析


#include <iostream>
#include <fstream>
#include <stack>
#include <vector>

using namespace std;

typedef struct {
    int code;//种别编码
    int value;//属性
}token;

typedef struct
{
    int seq;
    int address;
    string name;
}symble;

typedef struct 
{
    int op;
    int arg1;
    int arg2;
    int result;
}quadruple;//四元式结构体

typedef struct
{
    int place;
}node;//非终结符节点



ifstream infile_1;//读token
ifstream infile_2;//读symble
ofstream ofile;//输出语法成分

stack<string> Gramnames;
vector<token> token1(200);
int tokennum=0;//已读取的token数目
vector<symble> symble1(200);
int symblenum=0;
vector<quadruple> quadtable;//四元式表
int tempvarnum=0;//临时变量数目


void emit(int op, int arg1, int arg2, int result)
{
    quadruple q;
    q.op=op;
    q.arg1=arg1;
    q.arg2=arg2;
    q.result=result;
    quadtable.push_back(q);
}

int newtemp()
{
    tempvarnum++;
    return tempvarnum+200;//临时变量编码从201开始    
}



bool success=false;

void gettokentxt();
void getsymbletxt();
void getnexttoken();
void Program();
void ProBody();
node GroSta();
node Stmt();
node Sg(node s);
void DecSta();
node Asssta();
void Ifsta();
void WhileSta();
void BType();
void ListVar();
void V();
node Exp();
void BoolExp();
void Block();
void Else();
node Item();
node E(node e);
node Fac();
node I(node i);
void BoolItem();
void Be();
void BoolFac();
void Bi();
void RelExp();
void Rel();
void error();

void gettokentxt()
{
    int tempnum=0;
    infile_1.open("token");
    while(!infile_1.eof() && tempnum<200)
    {
        infile_1 >> token1[tempnum].code >> token1[tempnum].value;
        tempnum++;
    }
}

void getsymbletxt()
{
    int tempnum=0;
    infile_2.open("symble");
    while(!infile_2.eof() && tempnum<200)
    {
        infile_2 >> symble1[tempnum].seq >> symble1[tempnum].name;
        tempnum++;
    }
}

void getnexttoken()
{
    tokennum++;
}

void error()//预留，暂不使用
{
    cout << "error" <<endl;
}

void Program()
{
    // Gramnames.push("Program");
    if(token1[tokennum].code == 1)
    {
        getnexttoken();
        if(token1[tokennum].code == 26)
        {
            getnexttoken();
            if(token1[tokennum].code == 27)
            {
                getnexttoken();
                if(token1[tokennum].code == 28)
                {
                    getnexttoken();
                    ProBody();
                    if(token1[tokennum].code == 29)
                    {
                        success=true;
                        emit(88,0,0,0);
                    }
                }
                else
                {
                    error();
                }
            }
            else
            {
                error();
            }
        }
        else
        {
            error();
        }
    }
    else
    {
        error();//预留错误接口
        // Gramnames.pop();
    }
    // ofile << "Program" << endl;
}

void ProBody()
{   
    // Gramnames.push("ProBody");
    GroSta();
    // ofile << "ProBody" << endl;
}

node GroSta()
{   
    node s;
    int tempcode=token1[tokennum].code;
    // Gramnames.push("GroSta");
    if(tempcode == 2||tempcode == 3||tempcode ==10||tempcode ==4||tempcode ==6)
    {
        s=Stmt();
        s=Sg(s);
    }
    // ofile << "GroSta" << endl;
    return s;
}

node Sg(node s)//修改文法所产生 不记录名称
{
    node sg=s;
    int tempcode=token1[tokennum].code;
    //GroSta的first集合 int float id if while
    if(tempcode == 2||tempcode == 3||tempcode ==10||tempcode ==4||tempcode ==6)
    {
        sg=GroSta();
    }
    else if(tempcode == 29) //寻找Sg的follow集
    {
        //啥也不写 自动匹配
    }
    return sg;
}

node Stmt()
{
    // Gramnames.push("Stmt");
    node s;
    int tempcode=token1[tokennum].code;
    if(tempcode ==2 || tempcode ==3)
    {
        DecSta();
    }
    else if(tempcode == 10)
    {
        s=Asssta();
    }
    else if(tempcode == 6)
    {
        WhileSta();
    }
    else if(tempcode == 4)
    {
        Ifsta();
    }
    // ofile << "Stmt" << endl;
    return s;
}



void DecSta()
{
    // Gramnames.push("DecSta");
    BType();
    ListVar();
    if(token1[tokennum].code == 24)
    {
        getnexttoken();
    }
    ofile << "DecSta" << endl;
}
void BType()
{
    // Gramnames.push("BType");
    if(token1[tokennum].code == 2)
    {
        getnexttoken();
    }
    if(token1[tokennum].code == 3)
    {
        getnexttoken();    
    }
    ofile << "BType" << endl;
}
void ListVar()
{
    // Gramnames.push("ListVar");
    if(token1[tokennum].code == 10)
    {
        getnexttoken();
        V();
    }
    ofile << "ListVar" << endl;
}

void V() // 新文法生成的不记录名称
{
    if(token1[tokennum].code == 25)
    {
        getnexttoken();
        ListVar();
    }
    else if(token1[tokennum].code == 24)
    {
        //啥也不干
    }
}

node Asssta()
{
    // Gramnames.push("Asssta");
    node s;
    if(token1[tokennum].code == 10)
    {
        int assvalue=token1[tokennum].value;//
        getnexttoken();
        if(token1[tokennum].code == 13)
        {
            getnexttoken();
            int tempcode = token1[tokennum].code;
            if(tempcode == 10 || tempcode == 26 || tempcode == 11 || tempcode == 12)
            {
                s=Exp();
                if(token1[tokennum].code == 24)
                {
                    getnexttoken();
                }
            }
        }
        emit(13,s.place,0,assvalue);

    }
    // ofile << "AssSta" << endl;
}

void Ifsta()
{
    // Gramnames.push("Ifsta");
    if(token1[tokennum].code == 4)
    {
        getnexttoken();
        if(token1[tokennum].code == 26)
        {
            getnexttoken();
            if(token1[tokennum].code == 9 || token1[tokennum].code == 10)
            {
                BoolExp();
            }
            if(token1[tokennum].code == 27)
            {
                getnexttoken();
                int tempcode =token1[tokennum].code;
                if(tempcode == 28 || tempcode == 2 || tempcode == 3 || tempcode == 4 || tempcode == 6 || tempcode ==10)
                {
                    Block();
                    Else();
                }
            }
        }
    }
    ofile << "IfSta" << endl;
}

void Else()
{
    int tempcode = token1[tokennum].code;
    if(tempcode == 5)
    {
        getnexttoken();
        Block();
    }
    else if(tempcode == 10 || tempcode == 2 || tempcode == 3 || tempcode == 4 || tempcode == 5 || tempcode == 6 || tempcode == 29)
    {
        //啥也不干
    }
}

void WhileSta()
{
    // Gramnames.push("WhileSta");
    if(token1[tokennum].code == 6)
    {
        getnexttoken();
        if(token1[tokennum].code == 26)
        {
            getnexttoken();
            BoolExp();
            if(token1[tokennum].code == 27)
            {
                getnexttoken();
                Block();
            }
        }
    }
    ofile << " WhileSta" << endl;
}

void Block()
{
    // Gramnames.push("Block");
    int tempcode = token1[tokennum].code;
    if(tempcode == 2 || tempcode == 3 || tempcode == 4 || tempcode == 6 || tempcode == 10)
    {
        Stmt();
    }
    else if(tempcode == 28)
    {
        getnexttoken();
        GroSta();
        if(token1[tokennum].code == 29)
        {
            getnexttoken();
        }
    }
    ofile << "Block" << endl;
}

node Exp()
{
    // Gramnames.push("Exp");
    node s;
    s=Item();
    s=E(s);
    // ofile << "Exp" << endl;
    return s;

}

node E(node e)
{
    node s=e;
    if(token1[tokennum].code == 14)
    {
        getnexttoken();
        node i=Exp();
        s.place=newtemp();
        emit(14,e.place,i.place,s.place);
    }
    else if(token1[tokennum].code == 15)
    {
        getnexttoken();
        node i=Exp();
        s.place=newtemp();
        emit(15,e.place,i.place,s.place);
    }
    else if(token1[tokennum].code == 27 || token1[tokennum].code == 24)
    {
        //空
    }
    return s;
}

node Item()
{
    // Gramnames.push("Item");
    node s;
    int tempcode = token1[tokennum].code;
    if(tempcode == 10 || tempcode == 26 || tempcode == 11 || tempcode == 12)
    {
        s=Fac();
        s=I(s);
    }
    // ofile << "Item" << endl;
    return s;
}

node I(node i)
{   
    node s=i;
    int tempcode = token1[tokennum].code;
    if(tempcode == 16)
    {
        getnexttoken();
        node y=Item();
        s.place=newtemp();
        emit(16,i.place,y.place,s.place);
    }
    else if(tempcode == 17)
    {
        getnexttoken();
        node y=Item();
        s.place=newtemp();
        emit(17,i.place,y.place,s.place);
    }
    else if(tempcode == 14 || tempcode == 15 || tempcode == 27 || tempcode == 24)
    {
        //空
    }
    return s;
}

node Fac()
{
    // Gramnames.push("Fac");
    node s;
    if(token1[tokennum].code == 10)
    {
        s.place=token1[tokennum].value;
        getnexttoken();
    }
    else if(token1[tokennum].code == 26)
    {
        getnexttoken();
        s=Exp();
        if(token1[tokennum].code == 27)
        {
            getnexttoken();
        }
    }
    else if(token1[tokennum].code == 11 || token1[tokennum].code == 12)
    {
        s.place=token1[tokennum].value;
        getnexttoken();
    }
    // ofile << "Fac" << endl;
    return s;
}



void BoolExp()
{
    // Gramnames.push("BoolExp");
    if(token1[tokennum].code == 9 || token1[tokennum].code == 10)
    {
        BoolItem();
        Be();
    }
    ofile << "BoolExp" << endl;
}

void Be()
{
    if(token1[tokennum].code == 7)
    {
        getnexttoken();
        BoolExp();
    }
    else if(token1[tokennum].code == 27)
    {
        //空
    }
}

void BoolItem()
{
    // Gramnames.push("BoolItem");
    BoolFac();
    Bi();
    ofile << "BoolItem" << endl;
}

void Bi()
{
    if(token1[tokennum].code == 8)
    {
        getnexttoken();
        BoolItem();
    }
    else if(token1[tokennum].code == 7 || token1[tokennum].code == 27 )
    {
        //
    }
}

void BoolFac()
{   
    // Gramnames.push("BoolFac");
    int tempcode = token1[tokennum].code;
    if(tempcode == 9)
    {
        getnexttoken();
        RelExp();
    }
    else if(tempcode == 10 )
    {
        RelExp();
    }
    ofile << "BoolFac" << endl;
}

void RelExp()
{
    // Gramnames.push("RelExp");
    if(token1[tokennum].code == 10)
    {
        getnexttoken();
        Rel();
        if(token1[tokennum].code == 10)
        {
            getnexttoken();
        }
    }
    ofile << "RelExp" << endl;
}

void Rel()
{
    // Gramnames.push("Rel");
    int tempcode = token1[tokennum].code;
    if(tempcode == 18)
    {
        getnexttoken();
    }
    else if(tempcode == 19)
    {
        getnexttoken();
    }
    else if(tempcode == 20)
    {
        getnexttoken();
    }
    else if(tempcode == 21)
    {
        getnexttoken();
    }
    else if(tempcode == 22)
    {
        getnexttoken();
    }
    else if(tempcode == 23)
    {
        getnexttoken();
    }
    ofile << "Rel" << endl;
}

int main()
{

    ofile.open("quad");

    gettokentxt();
    getsymbletxt();
    Program();
    for(int i = 0; i < quadtable.size(); i++)
    {
        ofile << i+1 << " " << quadtable[i].op << " " << quadtable[i].arg1 << " " << quadtable[i].arg2<< " " << quadtable[i].result << endl;
    }
    
    infile_1.close();
    infile_2.close();
    ofile.close();
}