package com.yunsheng.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GetSparkTableName {

    public static String getSparkTableName(String value){

        String regex = "ods_(.*?)_\\d{8}$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(value);
        String result = null;
        if (matcher.find()) {
            // 获取第一个捕获组的内容
            result = matcher.group(1);


//            System.out.println("Matched: " + result);
        }


        return  result;

    }
}
