package com.wb.domain.common;

import lombok.extern.slf4j.Slf4j;

/**
 * Example:<br>
 * <code>
 * 1. Catcher.unSafeCall(() -> { do something... })<br>
 * 2. Object o = Catcher.unSafeCall(() -> { return anything... })<br>
 * </code>
 *
 */
@Slf4j
public abstract class Catcher {
    private Catcher() {
    }

    public interface ThrowableRunner {
        void run() throws Throwable;
    }

    public interface ThrowableSupplier<T> {
        T get() throws Throwable;
    }

    /**
     * Only throw RuntimeException for any unSafeCall.
     * <br>
     * <code>
     * Example:<br>
     * unSafeCall(() -> { do something... })
     * </code>
     *
     * @param caller ThrowableRunner
     */
    public static void unSafeCall(ThrowableRunner caller) {
        try {
            caller.run();
        } catch (Throwable e) {
        	e.printStackTrace();
            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            } else {
                throw new RuntimeException(e);
            }
        }
    }

    /**
     * Never throw any exception
     * <br>
     * <code>
     * Example:<br>
     * safeCall(() -> { do something... })
     * </code>
     *
     * @param caller ThrowableRunner
     */
    public static void safeCall(ThrowableRunner caller) {
        try {
            caller.run();
        } catch (Throwable e) {
            // catch it safeCall
        }
    }

	public static void safeCall(ThrowableRunner caller, boolean logError) {
		try {
			caller.run();
		} catch (Throwable e) {
			if (logError) {
				log.error(e.getMessage(), e);
			}
		}
	}

    /**
     * Only throw RuntimeException for any unSafeCall.
     * <br>
     * <code>
     * Example:<br>
     * unSafeGet(() -> { return anything... })
     * </code>
     *
     * @param supplier ThrowableSupplier<T></>
     * @return <T></>
     */
    public static <T> T unSafeGet(ThrowableSupplier<T> supplier) {
        try {
            return supplier.get();
        } catch (Throwable e) {
            if (e instanceof RuntimeException) {
                throw (RuntimeException) e;
            } else {
                throw new RuntimeException(e);
            }
        }
    }

    /**
     * Never throw any exception
     * <br>
     * <code>
     * Example:<br>
     * safeGet(() -> { return anything... })
     * </code>
     *
     * @param supplier ThrowableSupplier<T>
     * @param defaultValue default value
     * @return default value if exception happen
     */
    public static <T> T safeGet(ThrowableSupplier<T> supplier, T defaultValue) {
        return safeGet(supplier, defaultValue, false);
    }

    /**
     * Never throw any exception
     * <br>
     * <code>
     * Example:<br>
     * safeGet(() -> { return anything... })
     * </code>
     *
     * @param supplier ThrowableSupplier<T>
     * @param defaultValue default value
     * @return default value if exception happen
     */
    public static <T> T safeGet(ThrowableSupplier<T> supplier, T defaultValue, boolean logError) {
        try {
            return supplier.get();
        } catch (Throwable e) {
            if (logError) {
                log.error(e.getMessage(), e);
            }
            return defaultValue;
        }
    }
}
