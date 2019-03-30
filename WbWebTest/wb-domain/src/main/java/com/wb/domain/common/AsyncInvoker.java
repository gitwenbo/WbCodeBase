package com.wb.domain.common;

import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.AsyncResult;
import org.springframework.stereotype.Component;

import java.util.concurrent.Callable;
import java.util.concurrent.Future;

@Component
public class AsyncInvoker {

	@Async
	public <T> Future<T> invoke(Callable<T> callable) {
		return Catcher.unSafeGet(() -> new AsyncResult<>(callable.call()));
	}

	@Async
	public Future<Boolean> invoke(Runnable runnable) {
		return Catcher.unSafeGet(() -> {
			runnable.run();
			return new AsyncResult<>(true);
		});
	}

}
