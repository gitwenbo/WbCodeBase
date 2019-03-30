package cards;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Card {
	private CardType cardType;
	private CardNumber cardNumber;

	@Override
	public String toString() {
		return cardType.name() + cardNumber.name();
	}

	@Override
	public boolean equals(Object o) {
		if (o != null || o instanceof Card) {
			Card otherCard = (Card) o;
			if (otherCard.cardType == null || otherCard.cardNumber == null) {
				return false;
			} else {
				return this.cardType == otherCard.cardType && this.cardNumber == otherCard.cardNumber;
			}
		}

		return false;
	}

	@Override
	public int hashCode() {
		return cardType.hashCode() + cardNumber.hashCode();
	}

}
