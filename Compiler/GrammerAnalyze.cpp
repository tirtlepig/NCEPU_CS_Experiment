/*
 * @Date: 2022-06-05 10:09:52
 * @LastEditors: turtlepig
 * @LastEditTime: 2022-06-07 11:25:33
 */

/*
递归下降分析法的思想：
1.为每一个非终结符构造一个子程序
2.每个子程序按照非终结符的候选式分情况展开，终结符直接匹配，非终结符继续调用子程序
3.直到所有非终结符都展开为终结符为止
*/

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
    string name;
}symble;

ifstream infile_1;//读token
ifstream infile_2;//读symble
ofstream ofile;//输出语法成分

stack<string> Gramnames;
vector<token> token1(200);
int tokennum=0;
vector<symble> symble1(200);
int symblenum=0;

bool success=false;

void gettokentxt();
void getsymbletxt();
void getnexttoken();
void Program();
void ProBody();
void GroSta();
void Stmt();
void Sg();
void DecSta();
void Asssta();
void Ifsta();
void WhileSta();
void BType();
void ListVar();
void V();
void Exp();
void BoolExp();
void Block();
void Else();
void Item();
void E();
void Fac();
void I();
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
        infile_2 >> symble1[symblenum].seq >> symble1[symblenum].name;
        symblenum++;
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
    ofile << "Program" << endl;
}

void ProBody()
{   
    // Gramnames.push("ProBody");
    GroSta();
    ofile << "ProBody" << endl;
}

void GroSta()
{
    int tempcode=token1[tokennum].code;
    // Gramnames.push("GroSta");
    if(tempcode == 2||tempcode == 3||tempcode ==10||tempcode ==4||tempcode ==6)
    {
        Stmt();
        Sg();
    }
    ofile << "GroSta" << endl;
}

void Sg()//修改文法所产生 不记录名称
{
    int tempcode=token1[tokennum].code;
    //GroSta的first集合 int float id if while
    if(tempcode == 2||tempcode == 3||tempcode ==10||tempcode ==4||tempcode ==6)
    {
        GroSta();
    }
    else if(tempcode == 29) //寻找Sg的follow集
    {
        //啥也不写 自动匹配
    }
}

void Stmt()
{
    // Gramnames.push("Stmt");
    int tempcode=token1[tokennum].code;
    if(tempcode ==2 || tempcode ==3)
    {
        DecSta();
    }
    else if(tempcode == 10)
    {
        Asssta();
    }
    else if(tempcode == 6)
    {
        WhileSta();
    }
    else if(tempcode == 4)
    {
        Ifsta();
    }
    ofile << "Stmt" << endl;
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

void Asssta()
{
    // Gramnames.push("Asssta");
    if(token1[tokennum].code == 10)
    {
        getnexttoken();
        if(token1[tokennum].code == 13)
        {
            getnexttoken();
            int tempcode = token1[tokennum].code;
            if(tempcode == 10 || tempcode == 26 || tempcode == 11 || tempcode == 12)
            {
                Exp();
                if(token1[tokennum].code == 24)
                {
                    getnexttoken();
                }
            }
        }
    }
    ofile << "AssSta" << endl;
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

void Exp()
{
    // Gramnames.push("Exp");
    Item();
    E();
    ofile << "Exp" << endl;
}

void E()
{
    if(token1[tokennum].code == 14)
    {
        getnexttoken();
        Exp();
    }
    else if(token1[tokennum].code == 15)
    {
        getnexttoken();
        Exp();
    }
    else if(token1[tokennum].code == 27 || token1[tokennum].code == 24)
    {
        //空
    }
}

void Item()
{
    // Gramnames.push("Item");
    int tempcode = token1[tokennum].code;
    if(tempcode == 10 || tempcode == 26 || tempcode == 11 || tempcode == 12)
    {
        Fac();
        I();
    }
    ofile << "Item" << endl;
}

void I()
{   
    int tempcode = token1[tokennum].code;
    if(tempcode == 16)
    {
        getnexttoken();
        Item();
    }
    else if(tempcode == 17)
    {
        getnexttoken();
        Item();
    }
    else if(tempcode == 14 || tempcode == 15 || tempcode == 27 || tempcode == 24)
    {
        //空
    }
}

void Fac()
{
    // Gramnames.push("Fac");
    if(token1[tokennum].code == 10)
    {
        getnexttoken();
    }
    else if(token1[tokennum].code == 26)
    {
        getnexttoken();
        Exp();
        if(token1[tokennum].code == 27)
        {
            getnexttoken();
        }
    }
    else if(token1[tokennum].code == 11 || token1[tokennum].code == 12)
    {
        getnexttoken();
    }
    ofile << "Fac" << endl;
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

    ofile.open("output");

    gettokentxt();
    getsymbletxt();
    Program();
    
    infile_1.close();
    infile_2.close();
    ofile.close();
}