package cards;

public class Main {

	public static void main(String[] args) {
		Deck deck = new Deck();

		System.out.println("before shuffle...");
		deck.deal();

		deck.shuffle();

		System.out.println("\nshuffle...");
		deck.deal();

		deck.shuffle();

		System.out.println("\nshuffle again...");
		deck.deal();
	}

}
