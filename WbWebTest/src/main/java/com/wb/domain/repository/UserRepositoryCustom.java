package com.wb.domain.repository;

import com.wb.domain.model.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete

public interface UserRepositoryCustom {

    List<User> findByName(String name);

}
