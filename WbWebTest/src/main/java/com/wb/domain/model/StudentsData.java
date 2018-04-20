package com.wb.domain.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

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
