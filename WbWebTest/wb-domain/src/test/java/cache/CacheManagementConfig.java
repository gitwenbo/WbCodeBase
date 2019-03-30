package cache;

import com.google.common.cache.CacheBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.guava.GuavaCache;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.context.annotation.Bean;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class CacheManagementConfig {

    public static final String HOTEL_POSTION = "hotel_position";  //cache key

    @Value("${cache.guavaCache.hotelPosition.maxSize}")
    private long hotelPositionMaxSize;

    @Value("${cache.guavaCache.hotelPosition.duration}")
    private long hotelPositionDuration;

    private GuavaCache buildHotelPositionCache() {
        return new GuavaCache(HOTEL_POSTION,
                              CacheBuilder.newBuilder()
                                          .recordStats()
                                          .maximumSize(hotelPositionMaxSize)
                                          .expireAfterWrite(hotelPositionDuration, TimeUnit.DAYS)
                                          .build());
    }

    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager manager = new SimpleCacheManager();
        List list = new ArrayList();
        list.add(buildHotelPositionCache());
        manager.setCaches(  list );

        return manager;
    }


    @Cacheable(value = CacheManagementConfig.HOTEL_POSTION, key = "{#hotelId}", condition = "", unless = "!#result.isSuccessful()")
    public BaseDomainResponse<HotelPosition> getHotelPosition(int hotelId, String apiToken) {
        //......
    }
}
