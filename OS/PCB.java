import java.util.Random;

public class PCB {
    private String name; //进程名字
    private PCB next; //下一个进程的PCB
    private int reqtime; //需要运行时间
    private int exetime; //已经运行时间
    private char state; //运行状态
    private int reqmem; //需要内存大小
    private int pagelenth; //分配的页表长度
    private Page[] pagetabe; //分配给进程的页表
    public PCB(){
        super();
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public PCB getNext() {
        return next;
    }
    public void setNext(PCB next) {
        this.next = next;
    }
    public int getReqtime() {
        return reqtime;
    }
    public void setReqtime(int reqtime) {
        this.reqtime = reqtime;
    }
    public int getExetime() {
        return exetime;
    }
    public void setExetime(int exetime) {
        this.exetime = exetime;
    }
    public char getState() {
        return state;
    }
    public void setState(char state) {
        this.state = state;
    }
    public int getReqmem() {
        return reqmem;
    }
    public void setReqmem(int reqmem) {
        this.reqmem = reqmem;
    }
    public int getPagelenth() {
        return pagelenth;
    }
    public void setPagelenth(int pagelenth) {
        this.pagelenth = pagelenth;
    }
    public Page[] getPagetabe() {
        return pagetabe;
    }
    public void setPagetabe(Page[] pagetabe) {
        this.pagetabe = pagetabe;
    }
    public void getSequence(){//获取访问的顺序
        int num=this.reqmem*10;
        int missingpage=0;//缺页次数
        for (int i=0;i<this.reqmem;i++){
            Random random=new Random();
            int m=random.nextInt(num-1);
            int pagenum=(m)/10;//页号
            for (int j=0;j<5;j++){
                pagenum=(m)%10;
                if (check(pagenum)==1){//缺页发生了置换
                    System.out.println(pagenum+"置换");
                    missingpage++;
                }else {
                    System.out.println(pagenum+"命中");
                }
                m=(m+1)%num;//百分之五十顺序执行，轮转
            }
            int s=m;
            for (int j=0;j<3;j++){
                m=random.nextInt(s+1);
                pagenum=m/10;
                if (check(pagenum)==1){
                    System.out.println(pagenum+"置换");
                    missingpage++;
                }else {
                    System.out.println(pagenum+"命中");
                }
            }
            for (int j=0;j<2;j++){
                pagenum=num-s;
                m=random.nextInt(pagenum);
                pagenum=(s+m)/10;
                if (check(pagenum)==1){
                    System.out.println(pagenum+"置换");
                    missingpage++;
                }else {
                    System.out.println(pagenum+"命中");
                }
            }
            System.out.println();
        }
        double radio=1-(double)missingpage/(num);
        System.out.println("置换次数为："+missingpage+"命中率为："+radio);
    }

    public int check(int m) {//检查是否处在页表中
        int change=0;//用check=0时表示置换
        int miss=0;//用miss=1时表示缺页
        for (int i=0;i<this.pagelenth;i++){
            if (this.pagetabe[i].getPagenum()==-1)
            {
                this.pagetabe[i].setVisitedtime(this.pagetabe[i].getVisitedtime()+1);
                this.pagetabe[i].setPagenum(m);
                change=1;
                miss=1;
                break;
            }
            else if (this.pagetabe[i].getPagenum()==m){
                this.pagetabe[i].setVisitedtime(this.pagetabe[i].getVisitedtime()+1);
                change=1;
                break;
            }
        }
        if (change==0)
        {
            miss=1;
            int min=this.pagetabe[0].getVisitedtime();
            int k=0;
            for (int i=1;i<this.pagelenth;i++){
                //找访问最少的页面——最近最少未使用
                if (min>this.pagetabe[i].getVisitedtime()){
                    min=this.pagetabe[i].getVisitedtime();
                    k=i;
                }
            }
            this.pagetabe[k].setPagenum(m);
            this.pagetabe[k].setVisitedtime(1);
        }
        return miss;//返回缺页数
    }
}
