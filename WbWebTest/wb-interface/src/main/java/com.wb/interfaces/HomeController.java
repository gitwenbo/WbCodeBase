package com.wb.interfaces;

import com.google.common.collect.Lists;
import com.wb.domain.student.entity.Student;
import com.wb.domain.student.entity.StudentsData;
import com.wb.domain.user.entity.User;
import com.wb.domain.user.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
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
    private UserService userService;

    @Autowired
    protected StringRedisTemplate redisTemplate;

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
    public StudentsData getStudents(@RequestBody User user) {
        Iterable<User> users = userService.getUser(user.getEmail());

        Student stu1 = new Student(11, "James", 18);
        Student stu2 = new Student(11, "Kobe", 17);

        String kobeAge = redisTemplate.opsForValue().get("kobeAge");
        if(kobeAge != null) {
            stu2.setAge(Integer.parseInt(kobeAge));
        }

        List<Student> studentList = Lists.newArrayList(stu1, stu2);
        StudentsData StudentsData = new StudentsData(stu2, users);

        return StudentsData;
    }

}