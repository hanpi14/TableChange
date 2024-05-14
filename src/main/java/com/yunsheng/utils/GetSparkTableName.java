package com.yunsheng.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GetSparkTableName {

    public static void getSparkTableName(String value){

        String regex = "ods_(.*?)_\\d{8}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(value);

        if (matcher.find()) {
            // 获取第一个捕获组的内容
            String result = matcher.group(1);
            System.out.println("Matched: " + result);
        } else {
            System.out.println("No match found.");
        }


    }
}
