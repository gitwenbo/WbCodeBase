package com.wb.domain.user.service;

import com.wb.domain.user.entity.User;
import com.wb.domain.user.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

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

    public List<User> getUser(String email) {
        return userRepository.findByEmailStartingWith(email);
    }


}
