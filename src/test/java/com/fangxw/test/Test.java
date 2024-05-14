package com.fangxw.test;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Test {
    @org.junit.Test
    public void testPP(){

//        String input = "ods_hro_bill_user_salary_20240417";
        String input = "20240417";

        // 定义正则表达式，匹配 "ods_" 后面的部分直到 "_20240415" 之前的部分
        String regex = "ods_(.*?)_\\d{8}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);

        if (matcher.find()) {
            // 获取第一个捕获组的内容
            String result = matcher.group(1);
            System.out.println("Matched: " + result);
        } else {
            System.out.println("No match found.");
        }


    }
}
