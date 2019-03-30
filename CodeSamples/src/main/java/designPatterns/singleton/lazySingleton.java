package designPatterns.singleton;

public class lazySingleton {
    private static volatile lazySingleton instance = null;

    private lazySingleton() {
    }

    public static synchronized lazySingleton getInstance() {
        if (instance == null) {

            instance = new lazySingleton();
        }

        return instance;
    }

    public static lazySingleton getInstance2() {
        if (instance == null) {
            synchronized (lazySingleton.class) {
                if (instance == null) {
                    instance = new lazySingleton();
                }
            }
        }

        return instance;
    }

    private static class SingletonInstance {
        private static final lazySingleton INSTANCE = new lazySingleton();
    }

    public static lazySingleton getInstance3() {
        return SingletonInstance.INSTANCE;
    }

}
