package com.wb;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by huangwenbo on 4/20/18.
 */
@RestController
public class HelloController {

    @RequestMapping(value="hello", method= RequestMethod.GET)
    public String say() {
        return "hello shity!";
    }
}
