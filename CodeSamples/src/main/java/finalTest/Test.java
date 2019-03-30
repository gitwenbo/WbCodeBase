package finalTest;

public class Test {

    public static void changeValue(MyObject myObject) {
        myObject = new MyObject();
        myObject.value++;
        System.out.println("after change " + myObject.value);
    }

    public static void main(String[] args) {
//        MyObject myObject = new MyObject();
//        changeValue(myObject);
//        System.out.println(myObject.value);

        int a = 0x111;
        int b = 0b101;
        int c = 027;

        System.out.println(a + "\n" + b + "\n" + c);

    }



}
