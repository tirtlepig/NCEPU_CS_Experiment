/*
 * @Date: 2022-06-03 16:01:50
 * @LastEditors: turtlepig
 * @LastEditTime: 2022-06-12 19:47:17
 */
#include <iostream>
#include <fstream>

using namespace std;

ifstream infile;//读文件
ofstream ofile;//写token文件
ofstream ofile_2;//写symble文件



typedef struct
{
    string name;//单词名称
    int code;//对应编码
} word;

typedef struct  //token 表数据结构
{
    int code;//种别编码（类型）
    string name;//值
    int add;//地址 词法分析阶段不用
} wordtoken;

typedef struct //symble 表数据结构
{
    int seq;//序号
    string value;//标识符值   
} wordsymble;

const int keywordnum=6;
const int delimiternum = 6;
const int unioperatornum = 8;//单字符运算符
const int binoperatornum = 6;//双字符运算符

word keywords[keywordnum]={{"main",1},{"int",2},{"float",3},{"if",4},{"else",5},{"while",6}};
word delimiters[delimiternum]={{";",24},{",",25},{"(",26},{")",27},{"{",28},{"}",29}};
word unioperators[unioperatornum]={{"!",9},{"=",13},{"+",14},{"-",15},{"*",16},{"/",17},{"<",18},{">",20}};
word binoperators[binoperatornum]={{"||",7},{"&&",8},{"<=",19},{">=",21},{"==",22},{"!=",23}};

wordsymble identifier[50];
int identnum=0;
wordsymble constant[50];
int constnum=0;

char ch;

bool isletter(char ch)
{
    if((ch>='a' && ch<='z')||(ch>='A' && ch<='Z'))
    {
        return true;    
    }
    return false;
}

bool isdigit(char ch)
{
    if(ch>='0' && ch<='9')
    {
        return true;
    }
    return false;
}

bool isdot(char ch)
{
    if(ch=='.')
    {
        return true;
    }
    return false;
}

bool isletterE(char ch)
{
    if (ch=='e'||ch=='E') 
    {
        return true;
    }
    return false;
}



int iskeyword(string str)
{
    for (int i=0; i<keywordnum; i++)
    {
        if(str == keywords[i].name)
        {
            return keywords[i].code;
        }
    }
    return 0;
}

int isdelimiter(char ch)
{
    string tempstring="";
    tempstring.append(1,ch);
    for (int i=0; i<delimiternum; i++)
    {
        if(tempstring == delimiters[i].name)
        {
            return delimiters[i].code;
        }
    }
    return 0;
}

int isunioperator(char ch)
{
    string tempstring="";
    tempstring.append(1,ch);
    for (int i=0; i<unioperatornum; i++) 
    {
        if(tempstring == unioperators[i].name)
        {
            return unioperators[i].code;
        }
    }
    return 0;
}

int isbinoperator(string str)
{
    for (int i=0; i<binoperatornum; i++)
    {
        if(str == binoperators[i].name)
        return binoperators[i].code;
    }
    return 0;
}

int judgeexist(wordsymble s[],string str,int len)
{
    for (int i = 0; i < len; i++)
    {
        if(s[i].value == str)
        {
            return i;
        }
    }
    return -1;
}


//识别关键词还是标识符
void judge_iden_or_key(char &ch)
//ch为当前读入的首字符，判断为字母执行关键字和标识符判别程序
{
    string tempstring="";
    tempstring.append(1,ch);
    infile >> ch;
    while(isdigit(ch)||isletter(ch))
    {
        tempstring.append(1,ch);
        infile >> ch;
    }
    int code=iskeyword(tempstring);
    if(code != 0)
    {
        ofile << code <<" " << 0 <<endl;
    }
    else
    {
        int k=judgeexist(identifier,tempstring,identnum);
        if (k==-1)//标识符表里尚不存在此标识符
        {
            identifier[identnum].seq=identnum+1;
            identifier[identnum].value=tempstring;
            ofile << 10 <<" " << identnum+1 << endl;
            ofile_2 << identnum+1 << " " << tempstring << endl;
            identnum++;
        }
        else//标识符已经存在，只需输出token表即可
        {
            ofile << 10 <<" " << identifier[k].seq << endl;
        }
    }
}

//判别是整数还是实数
void judge_int_or_float(char &ch)//首字符已经读入为数字
{
    bool dot=false;
    bool letterE=false;
    string tempstring="";
    tempstring.append(1,ch);
    infile >> ch;
    while(isdigit(ch))
    {
        tempstring.append(1,ch);
        infile >> ch;
    }
    if(isletterE(ch))
    {
        letterE=true;
        tempstring.append(1,ch);
        infile >> ch;
        if(ch== '-' || ch=='+')
        {
            tempstring.append(1,ch);
            infile >> ch;
        }
        if(isdigit(ch))
        {
            tempstring.append(1,ch);
            infile >> ch;
            while(isdigit(ch))
            {
                tempstring.append(1,ch);
                infile >> ch;
            }
        }
    }
    else if(isdot(ch))
    {
        dot=true;
        tempstring.append(1,ch);
        infile >> ch;
        while(isdigit(ch))
        {
            tempstring.append(1,ch);
            infile >> ch;
        }
    }
    int k=judgeexist(constant,tempstring,constnum);
    if(k==-1)//尚不存在
    {
        constant[constnum].seq=constnum+101;
        constant[constnum].value=tempstring;
        if(dot|| letterE)
        {
            ofile << 12 <<" " << constnum+101 << endl;
        }
        else
        {
            ofile << 11 <<" " << constnum+101 << endl;
        }
        ofile_2 << constnum+101 << " " << tempstring<<endl;
        constnum++;
    }
    else
    {
        if(dot || letterE)
        {
            ofile << 12 <<" "<< constant[k].seq<< endl;
        }
        else
        {
            ofile << 11 <<" "<< constant[k].seq<< endl;
        }
        ofile_2 << constant[k].seq << " " << constant[k].value << endl;
    }
}

//最长匹配运算符
void judgeoperator(char &ch)//以及识别到ch为单字符运算符
{
    string tempstring="";
    tempstring.append(1,ch);
    if(ch!='|'&& ch!='&')
    {
        char ch_2=ch;
        infile >> ch;
        if(ch == '=')
        {
            tempstring.append(1,ch);
            int code = isbinoperator(tempstring);
            if(code!=0)//是一个双字符运算符
            {
                ofile << code << " " << 0 << endl;
            }
            infile >> ch;
        }
        else
        {
            ofile << isunioperator(ch_2) << " " << 0 << endl;
        }
    }
    else
    {
        char ch_2;
        ch_2 = ch;
        infile >> ch;
        tempstring.append(1,ch);
        if(isbinoperator(tempstring)!=0)
        {
            ofile << isbinoperator(tempstring) << " " << 0 << endl;
            infile >> ch;
        }
        else
        {
            ofile<< isunioperator(ch_2) << " " << 0 << endl;//这里转换格式也可以继续用append
        }
    }
}

//最长匹配界符
void judgedelimiter(char &ch)//已经判断ch为界符了
{
    ofile<< isdelimiter(ch) << " " << 0 << endl;
}

int main()
{
    infile.open("source");
    ofile.open("token");
    ofile_2.open("symble");
    infile >> noskipws; //不跳过空白符

    
    infile >> ch;

    while(!infile.eof())
    {
        string tempstring="";
        while(ch==' ' || ch== '\t' || ch== '\n' || ch== '\r')
        {
            if(infile.eof())
                break;
            infile >> ch;//略过，覆盖
        }
        if(isletter(ch))
        {
            judge_iden_or_key(ch);
            continue;
        }
        else if(isdigit(ch))
        {
            judge_int_or_float(ch);
            continue;
        }
        else if((isunioperator(ch)!=0)||ch=='|'||ch=='&')
        {
            judgeoperator(ch);
            continue;
        }
        else if(isdelimiter(ch))
        {
            judgedelimiter(ch);
        }
        else if (ch == ' ' || ch == '\r' || ch == '\n' || ch == '\t')
        {
            continue;
        }
        else
        {
            cout << "error" << ch << endl;
        }
        infile >> ch;
        if(infile.eof())
        {
            break;
        }
    }
    infile.close();
    ofile.close();
    ofile_2.close();
    return 0;
}
