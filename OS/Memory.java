import java.util.Scanner;

public class Memory {
    private int memorysize;
    private int emptysize;
    private String[] allocated;
    public int getMemorysize() {
        return memorysize;
    }
    public void setMemorysize(int memorysize) {
        this.memorysize = memorysize;
    }
    public int getEmptysize() {
        return emptysize;
    }
    public void setEmptysize(int emptysize) {
        this.emptysize = emptysize;
    }
    public String[] getAllocated() {
        return allocated;
    }
    public void setAllocated(int i,String allocation) {
        this.allocated[i] = allocation;
    }

    Scanner in=new Scanner(System.in);
    public void inch() {//初始化主存
        System.out.println("请输入主存大小，即块数");
        int size=in.nextInt();
        this.memorysize=size;
        this.emptysize=size;
        this.allocated=new String[size];
        for (int i = 0; i < size; i++) {
            this.allocated[i]="未分配";//初始时并未分配
        }
    }
    public void Allocation(PCB p) {
        //分配主存各块
        int n=p.getPagelenth();//进程页数即块数
        if (n>this.emptysize) {
            System.out.println("内存空间不足");
        }
        else {
            Page []pages=new Page[n];
            int i=0;//主存块号
            int j=0;//页号
            while(n>0)
            {
                if (this.allocated[i].equals("未分配")) {
                    Page page=new Page();
                    page.setPagenum(-1);
                    page.setVisitedtime(0);
                    page.setMemoryblock(i);
                    pages[j]=page;
                    this.allocated[i]=p.getName();//分配到的进程名
                    this.emptysize--;
                    n--;
                    j++;
                }
                i++;
            }
            p.setPagetabe(pages);
        }
    }
    public void recyleram(PCB pcb) {//主存回收
        int n=pcb.getPagelenth();
        for (int i = 0; i < n; i++) {
            this.allocated[pcb.getPagetabe()[i].getMemoryblock()]="未分配";
            this.emptysize++;
        }
    }
    public void printMem() {
        System.out.println("如下是主存分配情况");
        System.out.println("块号           "+"分配情况       "+"块号            "+"分配情况"+"          "+"块号            "+"分配情况");
        for (int i = 0; i <this.memorysize; i++) {
            int j=0;
            while (i<this.memorysize&&j<3) {
                System.out.print(i+"            "+this.allocated[i]+"            ");
                j++;
                i++;
            }
            i--;
            System.out.println();
        }
    }
}
