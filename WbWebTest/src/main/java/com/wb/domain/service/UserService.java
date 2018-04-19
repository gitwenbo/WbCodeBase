package com.wb.domain.service;

import com.wb.domain.model.User;
import com.wb.domain.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
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

    public Iterable<User> getAllUsers() {
        return userRepository.findAll();
    }
}
