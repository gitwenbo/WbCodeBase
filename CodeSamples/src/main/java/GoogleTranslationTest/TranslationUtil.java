package GoogleTranslationTest;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

public class TranslationUtil {

    public String translate(String text, final String targetLang) throws Exception {
        Document document = Jsoup.connect("https://translate.google.com/m")
                                 .data("hl", targetLang)
                                 .data("sl", "auto")
                                 .data("ie", "UTF-8")
                                 .data("q", text)
                                 .userAgent("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36")
                                 .timeout(2000).get();

        return document.body().childNode(4).childNode(0).toString();
    }

    public static void main(String[] args) {
        TranslationUtil translationUtil = new TranslationUtil();
        try {
            String srcText = "휴대폰케이스/액세서리";
            String translatedText = translationUtil.translate(srcText, "en");
            System.out.println(translatedText);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
