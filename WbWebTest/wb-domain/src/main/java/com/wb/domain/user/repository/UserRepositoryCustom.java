package com.wb.domain.user.repository;

import com.wb.domain.user.entity.User;

import java.util.List;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete

public interface UserRepositoryCustom {

    List<User> findByName(String name);

    List<User> querydslTest(String name);

}
