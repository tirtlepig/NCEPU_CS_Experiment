
public class Page {
    private int memoryblock;//主存块号
    private int pagenum;//页号
    private int visitedtime;
    public Page(){
        super();
    }
    public int getMemoryblock() {
        return memoryblock;
    }
    public void setMemoryblock(int memoryblock) {
        this.memoryblock = memoryblock;
    }
    public int getPagenum() {
        return pagenum;
    }
    public void setPagenum(int pagenum) {
        this.pagenum = pagenum;
    }
    public int getVisitedtime() {
        return visitedtime;
    }
    public void setVisitedtime(int visitedtime) {
        this.visitedtime = visitedtime;
    }

}
