package concurrent;

import java.util.concurrent.TimeUnit;

public class ThreadLocalTest1 {

    public static class MyRunnable implements Runnable {

        private ThreadLocal<Integer> threadLocal = new ThreadLocal<Integer>();
//        private int ordinaryObj;

        public MyRunnable(){
            threadLocal.set((int) (Math.random() * 100D));
            System.out.println(Thread.currentThread().getName() + ":" + threadLocal.get());
        }

        @Override
        public void run() {
//            int ordinaryObj = (int) (Math.random() * 100D);
//            threadLocal.set(ordinaryObj);
//
//            try {
//                TimeUnit.SECONDS.sleep(2);
//            } catch (InterruptedException e) {
//                e.printStackTrace();
//            }

            System.out.println(Thread.currentThread().getName() + ": ThreadLocal " + threadLocal.get());
//            System.out.println(Thread.currentThread().getName() + ": ordinaryObj" + ordinaryObj);
        }
    }


    public static void main(String[] args) {
        Thread t1 = new Thread(new MyRunnable(), "A");
        Thread t2 = new Thread(new MyRunnable(), "B");
        t1.start();
        t2.start();
    }
}
