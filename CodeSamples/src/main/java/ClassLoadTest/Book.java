package ClassLoadTest;

public class Book {
    public static void main(String[] args)
    {
        staticFunction();
    }

    static Book book = new Book();
    static int amount = 112;
    static
    {
        System.out.println("书的静态代码块 " +  amount);
    }
    {
        System.out.println("书的普通代码块");
    }
    Book()
    {
        System.out.println("书的构造方法");
        System.out.println("price=" + price +",amount=" + amount);
    }
    public static void staticFunction(){
        System.out.println("书的静态方法");
    }
    int price = 110;

}

