package designPatterns.singleton;

public class hungrySingleton {

    private final static hungrySingleton instance = new hungrySingleton();

    private hungrySingleton() {
    }

    public static hungrySingleton getInstance() {

        return instance;
    }



}
