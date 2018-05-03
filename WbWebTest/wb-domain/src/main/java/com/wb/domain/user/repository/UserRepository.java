package com.wb.domain.user.repository;

import com.wb.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

// This will be AUTO IMPLEMENTED by Spring into a Bean called userRepository
// CRUD refers Create, Read, Update, Delete

public interface UserRepository extends JpaRepository<User, Long>, UserRepositoryCustom {

    List<User> findById(Integer Id);

    List<User> findByEmailStartingWith(String email);

    @Query(value = "select * from User", nativeQuery = true)
    List<User> findAll();

    @Modifying(clearAutomatically = true)
    @Query(value = "select * from User", nativeQuery = true)
    List<User> modifyUser();

}
