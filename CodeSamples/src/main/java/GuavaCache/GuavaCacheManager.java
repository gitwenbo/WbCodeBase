package GuavaCache;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.Setter;
import org.springframework.cache.support.AbstractCacheManager;

import java.util.Collection;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class GuavaCacheManager extends AbstractCacheManager {
	private List<org.springframework.cache.Cache> caches = Lists.newArrayList();

	@Getter
	@Setter
	private CacheBuilder cacheBuilder = CacheBuilder.newBuilder()
		.maximumSize(200_000)
		.recordStats()
		.expireAfterAccess(10, TimeUnit.MINUTES);

	public void addCache(String key) {
		caches.add(new GuavaCache(key, createNativeCache()));
	}

	protected Cache<Object, Object> createNativeCache() {
		return cacheBuilder.build();
	}

	@Override
	protected Collection<? extends org.springframework.cache.Cache> loadCaches() {
		return caches;
	}
}
