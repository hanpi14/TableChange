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



    @org.junit.Test
    public void testOO(){

        String input = "SELECT * FROM ods.sbt_prod.oprt_boss_organization WHERE ...";
        String regex = "(?i)ods\\.([a-zA-Z0-9_]+)\\.([a-zA-Z0-9_]+)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);

        StringBuffer output = new StringBuffer();
        while (matcher.find()) {
            int i = matcher.groupCount();

            System.out.println(i);
            String group = matcher.group(0);
            System.out.println(group);
            String schema = matcher.group(1); // 匹配到的schema名
            System.out.println(schema);
            String tableName = matcher.group(2); // 匹配到的表名
            System.out.println(tableName);


            String result = "(" + group + "FOR SYSTEM_TIME AS OF '$\\{snap_date\\}')";
            System.out.println(result);
            // 这里可以根据需要对 schema 和 tableName 进行处理，例如替换成其他值
            matcher.appendReplacement(output,"\\("+group+"FOR SYSTEM_TIME AS OF \\'\\${snap_date\\}\\' )");
        }
        matcher.appendTail(output);

        System.out.println("替换后的字符串: " + output.toString());


    }



    @org.junit.Test
    public void testII(){

        String input = "SELECT * FROM dwd_online_mi WHERE ...";
        String regex = "\\b([a-zA-Z0-9_]+)mi\\b";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);

        StringBuffer output = new StringBuffer();
        while (matcher.find()) {

            System.out.println(matcher.group(0));
            String tableName = matcher.group(1); // 匹配到的表名
//            String tableName2 = matcher.group(2); // 匹配到的表名
            System.out.println(tableName);
//            System.out.println(tableName2);
            // 这里可以根据需要对 tableName 进行处理，例如替换成其他值
            matcher.appendReplacement(output, "dw.dwd."+tableName+"!{load_freq}i");
        }
        matcher.appendTail(output);

        System.out.println("替换后的字符串: " + output.toString());



    }
}
