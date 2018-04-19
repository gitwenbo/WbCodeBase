package com.wb.interfaces;

import com.google.common.collect.Lists;
import com.wb.domain.model.Student;
import com.wb.domain.model.StudentsData;
import com.wb.domain.model.User;
import com.wb.domain.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by Administrator on 2016/10/2 0002.
 */
@Slf4j
@Controller
public class HomeController {

    @Autowired
    private UserRepository userRepository;

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(Locale locale, Model model) {
        log.info("Welcome home, Holy Wb! The client locale is {}.", locale);

        Date date = new Date();
        DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);

        String formattedDate = dateFormat.format(date);

        model.addAttribute("serverTime", formattedDate);

        return "home";
    }

    @RequestMapping(value = "/students", method = RequestMethod.POST)
    @ResponseBody
    public StudentsData getStudents() {
        Iterable<User> users = userRepository.findAll();

        Student stu1 = new Student(11, "James", 18);
        Student stu2 = new Student(11, "Kobe", 17);
        List<Student> studentList = Lists.newArrayList(stu1, stu2);
        StudentsData StudentsData = new StudentsData(stu2, users);

        return StudentsData;
    }

}