package com.wb.domain.user.service;

import com.wb.domain.user.entity.User;
import com.wb.domain.user.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.function.Supplier;

@Service
@Slf4j
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User addNewUser(String name, String email) {
        User n = new User();
        n.setName(name);
        n.setEmail(email);
        userRepository.save(n);

        return n;
    }

    public void addNewUsers(List<User> users) {
        userRepository.save(users);
    }

    public Iterable<User> getAllUsers() {
        return userRepository.findAll();
    }

    public List<User> getUser(String email) {
        return userRepository.findByEmailStartingWith(email);
    }

    /**
     * Java 8 lambda calculus
     * Function, Supplier, Consumer, Predicate
     * @param supplier
     * @param flag
     */
    private void deletePieceByPiece(Supplier supplier, String flag) {
        log.info("start deleting {}... ", flag);
        int deletedCount;

        do {
            deletedCount = (Integer) supplier.get();
            log.info("{} {} were deleted! ", deletedCount, flag);
        } while (deletedCount > 0);

        log.info("deleting completed for {}... ", flag);
    }

}
