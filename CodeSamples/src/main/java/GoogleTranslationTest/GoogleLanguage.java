package GoogleTranslationTest;

/**
 * 谷歌支持的地区编码.
 */
public enum GoogleLanguage {
    /**
     * 地区编码及名称的枚举.
     */
    CHINESE_SIMPLIFIED("zh-CN","简体中文"),
    CHINESE_TRADITIONAL("zh-TW","繁体中文"),
    ENGLISH("en","英文"),
    JAPAN("ja","日语"),
    INDIA("in","印度"),
    RUSSIA("ru","俄文"),
    FRANCE("fr","法语"),
    SPAIN("es","西班牙语"),
    NETHERLANDS("nl","荷兰语"),
    SINGAPORE("sg","新加坡语"),
    THAI("th","泰语");


    /**
     * 当前语言的字符串表示形式.
     */
    private String languageCode;

    /**
     * 当前语言的名称.
     */
    private String languageName;

    /**
     * 构造函数
     *
     */
    private GoogleLanguage(final String languageCode) {
        this.languageCode = languageCode;
    }

    /**
     * 构造函数
     *
     */
    private GoogleLanguage(final String languageCode, final String languageName) {
        this.languageCode = languageCode;
        this.languageName = languageName;
    }


    public static GoogleLanguage getLuanguage(final String languageCode) {
        for (GoogleLanguage lang : values()) {
            if (languageCode.equals(lang.toString())) {
                return lang;
            }
        }
        return null;
    }

    public String getLanguageCode() {
        return languageCode;
    }

    public String getLanguageName() {
        return languageName;
    }

    public String toString(){
        return this.languageCode;
    }

}
