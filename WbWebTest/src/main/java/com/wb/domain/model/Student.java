package com.wb.domain.model;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * Created by huangwenbo on 4/18/18.
 */
@Data
@AllArgsConstructor
public class Student {
    private Integer id;
    private String name;
    private Integer age;
}
