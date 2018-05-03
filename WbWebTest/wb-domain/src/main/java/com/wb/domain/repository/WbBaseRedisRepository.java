package com.wb.domain.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class WbBaseRedisRepository {

    @Autowired
    protected StringRedisTemplate redisTemplate;

}
