package com.wb.domain.user.repository;

import com.wb.domain.user.entity.QUser;
import com.wb.domain.user.entity.User;
import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.EntityManager;
import java.util.List;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete

public class UserRepositoryImpl implements UserRepositoryCustom {

    @Autowired
//    @PersistenceContext(unitName = "productmatching")
    private EntityManager entityManager;

    private static final QUser qImageMatchingCandidate = QUser.user;


    @Override
    public List<User> findByName(String name) {
        return null;
    }

    @Override
    public List<User> querydslTest(String Id) {
        return null;
    }
}
