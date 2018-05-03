package com.wb.domain.student.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import com.wb.domain.user.entity.User;

/**
 * Created by huangwenbo on 4/18/18.
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class StudentsData {
    Student stu;
    Iterable<User> stus;
//    List<Student> stus;
}
