import java.util.Scanner;

public class integration {//集成调度
    private PCB head;
    private int n;//进程数目
    private Memory memory;
    public Memory getMemory() {
        return memory;
    }
    public void setMemory(Memory memory) {
        this.memory = memory;
    }
    Scanner in=new Scanner(System.in);
    public void create(){//创建循环链表并分配内存
        this.memory=new Memory();
        this.memory.inch();//创建主存区域
        this.memory.printMem();
        System.out.print("请输入进程个数:");
        this.n=in.nextInt();
        PCB pcb1=new PCB();
        String name= String.format("Q%s", 1);
        pcb1.setName(name);
        System.out.print("请输入第1个进程运行时间:");
        pcb1.setReqtime(in.nextInt());
        System.out.print("请输入第1个进程所需内存大小:");
        pcb1.setReqmem(in.nextInt());
        pcb1.setExetime(0);
        pcb1.setState('R');
        int avelength=this.memory.getMemorysize()/n;
        pcb1.setPagelenth(avelength);
        this.memory.Allocation(pcb1);
        this.head=pcb1;//头指针
        for (int i=2;i<=n;i++){
            PCB p=new PCB();
            name= String.format("Q%s", i);
            p.setName(name);
            System.out.print("请输入第"+i+"个进程运行时间:");
            p.setReqtime(in.nextInt());
            System.out.print("请输入第"+i+"个进程所需内存:");
            p.setReqmem(in.nextInt());
            p.setExetime(0);
            p.setState('R');
            p.setPagelenth(avelength);
            this.memory.Allocation(p);
            this.head.setNext(p);
            this.head=p;//让head指向队尾
        }
        this.head.setNext(pcb1);//收尾相连
        this.head=pcb1;
        this.memory.printMem();
    }
    public void work(){
        System.out.println("-------------初始信息---------------");
        printPCB();
        int time=1;
        while (head.getNext()!=head||head.getExetime()!=head.getReqtime()){
            System.out.println("这是第"+time+"次执行：");
            head.setExetime(head.getExetime()+1);//队首运行时间+1
            time++;
            if (head.getExetime()==head.getReqtime()){
                //运行结束
                head.setState('E');
                printPCB();
                System.out.println("进程"+head.getName()+"执行完毕");
                this.memory.recyleram(head);//回收内存
                this.memory.printMem();
                System.out.println("进程"+head.getName()+"页面访问结束");
                head.getSequence();
                PCB another=head;
                while (another.getNext()!=head){
                    another=another.getNext();
                }
                head=head.getNext();
                another.setNext(head);
                n--;
            }else{
                printPCB();
                head=head.getNext();
            }
        }
    }
    public void printPCB(){
        System.out.println("进程名   需要运行时间   已运行时间   状态");
        for (int i=1;i<=n;i++){
            System.out.println(head.getName()+"   "+head.getReqtime()+"   "+head.getExetime()+"   "+head.getState());
            head=head.getNext();
        }
    }
}
