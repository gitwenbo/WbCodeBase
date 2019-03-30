package RestfulTest;

import GuavaCache.GuavaCacheManager;
import GuavaCache.Main;
import com.google.common.cache.CacheBuilder;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.TimeUnit;

@Configuration
@EnableCaching
@ComponentScan(basePackageClasses = {Main.class})
public class ContextConfig {

    private static final String PROJECT_NAME = "ProductMatching";
    private static final int MAXIMUM_SIZE = 200_000;
    private static final int DURATION = 60;

    public static final String CACHE_KEY_GARBAGE_FILTER = "productmatching_garbage_filter";
    public static final String CACHE_KEY_GARBAGE_FILTER2 = "productmatching_garbage_filter2";

    @Bean
    public CacheManager guavaCacheManager() {
        GuavaCacheManager guavaCacheManager = new GuavaCacheManager();
        guavaCacheManager.setCacheBuilder(CacheBuilder.newBuilder()
                                                      .maximumSize(MAXIMUM_SIZE)
                                                      .recordStats()
                                                      .expireAfterAccess(DURATION, TimeUnit.MINUTES));

        guavaCacheManager.addCache(CACHE_KEY_GARBAGE_FILTER);
        guavaCacheManager.addCache(CACHE_KEY_GARBAGE_FILTER2);

        return guavaCacheManager;
    }
}
