package cards;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Deck {
	List<Card> aDeckOfCards = new ArrayList<Card>();

	public Deck() {
		for (CardType cardType : CardType.values()) {
			for (CardNumber cardNumber : CardNumber.values()) {
				aDeckOfCards.add(new Card(cardType, cardNumber));
			}
		}
	}

	public void shuffle() {
		Collections.shuffle(aDeckOfCards);
	}

	public void deal() {
		aDeckOfCards.forEach(card -> System.out.println(card));
	}

}
