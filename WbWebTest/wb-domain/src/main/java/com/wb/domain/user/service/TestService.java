package com.wb.domain.user.service;

import com.google.common.base.Stopwatch;
import com.google.common.collect.Lists;
import com.wb.domain.common.AsyncInvoker;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

import static com.wb.domain.common.Catcher.unSafeGet;

@Service
@Slf4j
public class TestService {

    @Autowired
    private AsyncInvoker asyncInvoker;

    public String serialCalculate(List<Integer> nums) {
        Stopwatch watch = Stopwatch.createStarted();

        List<Integer> noFutures = Lists.newArrayList();
        nums.forEach(num -> noFutures.add(unSafeGet(() -> calculate(num))));

        Optional<Integer> maxNum = noFutures.stream().max(Integer::compareTo);
        log.info("max num is {} -- elapsed time: {}", maxNum, watch.elapsed());

        return "serialCalculate --\n max num is " + maxNum.get() + " -- elapsed time: " + watch.elapsed() + "ms\n";
    }

    public String concurrentAsyncCalculate(List<Integer> nums) {
        Stopwatch watch = Stopwatch.createStarted();

        List<Future<Integer>> futures = Lists.newArrayList();

        nums.forEach(num -> {
            futures.add(asyncInvoker.invoke(() -> calculate(num)));
        });

        Optional<Integer> maxNum = futures.stream().map(f -> unSafeGet(f::get)).max(Integer::compareTo);
        log.info("max num is {} -- elapsed time: {}", maxNum, watch.elapsed());

        return "concurrentAsyncCalculate --\n max num is " + maxNum.get() + " -- elapsed time: " + watch.elapsed() + "ms\n";
    }

    private Integer calculate(int num) throws InterruptedException {
        TimeUnit.MILLISECONDS.sleep(500);

        return num;
    }

}
