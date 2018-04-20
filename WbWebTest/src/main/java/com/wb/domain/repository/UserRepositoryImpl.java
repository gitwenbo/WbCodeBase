package com.wb.domain.repository;

import com.wb.domain.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.CrudRepository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete

public class UserRepositoryImpl implements UserRepositoryCustom {

//    @Autowired
//    @PersistenceContext(unitName = "productmatching")
//    private EntityManager entityManager;

    @Override
    public List<User> findByName(String name) {
        return null;
    }
}
