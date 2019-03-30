package GuavaCache;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheStats;
import org.springframework.cache.support.SimpleValueWrapper;

public class GuavaCache implements org.springframework.cache.Cache {

	private Cache<Object, Object> cache;
	private String name;

	public GuavaCache(String name, Cache<Object, Object> cache) {
		this.name = name;
		this.cache = cache;
	}

	@Override public String getName() {
		return name;
	}

	@Override public Object getNativeCache() {
		return cache;
	}

	@Override public ValueWrapper get(final Object key) {
		final Object value;
		value = cache.getIfPresent(key);
		if (value == null) {
            return null;
        }

		return new SimpleValueWrapper(value);
	}

	@Override public void put(Object key, Object value) {
		this.cache.put(key, value);
	}

	@Override public void evict(Object key) {
		cache.invalidate(key);
	}

	@Override public void clear() {
		cache.invalidateAll();
	}

	public CacheStats getStats(){
		return cache.stats();
	}
}
