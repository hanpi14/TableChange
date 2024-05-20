package com.yunsheng.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class GetChangeFormatAndDate {


    public static String getChangeFormatAndDate(String input,String changDate){



        // 正则表达式和替换 '%Y%m%d' 为 'yyyyMMdd'
        input = replaceDateFormat(input, "%Y%m%d", "yyyyMMdd");

        // 正则表达式和替换 '%Y%m' 为 'yyyyMM'
        input = replaceDateFormat(input, "%Y%m", "yyyyMM");





        return  replaceDate(input,changDate);
    }


    private static String replaceDateFormat(String input, String oldFormat, String newFormat) {
        return input.replaceAll(Pattern.quote(oldFormat), newFormat);
    }


    private static String replaceDate(String input,String changeDate) {
        // 使用正则表达式匹配 'YYYYMM' 格式的日期并替换为 '202405'
        Pattern datePattern = Pattern.compile("'\\d{6}'");
        Matcher dateMatcher = datePattern.matcher(input);
        StringBuffer sb = new StringBuffer();
        while (dateMatcher.find()) {
            String matchedDate = dateMatcher.group();
            String newDate = incrementMonth(matchedDate.replaceAll("'", ""),changeDate);
            dateMatcher.appendReplacement(sb, "'" + newDate + "'");
        }
        dateMatcher.appendTail(sb);
        return sb.toString();
    }


    private static String incrementMonth(String date,String changeDate) {
        // 增加逻辑来确定新日期，这里为简单起见，假设每个找到的日期都变为 '202405'
        return changeDate;
    }



    public static String replaceDateTemplate(String input,String changeDate) {
        // 使用正则表达式匹配 'YYYYMM' 格式的日期并替换为 '202405'
        Pattern datePattern = Pattern.compile("'\\d{6}'");
        Matcher dateMatcher = datePattern.matcher(input);
        StringBuffer sb = new StringBuffer();
        while (dateMatcher.find()) {
            String matchedDate = dateMatcher.group();
            String newDate = incrementMonthTemplate(matchedDate.replaceAll("'", ""),changeDate);
//            System.out.println(newDate);
            dateMatcher.appendReplacement(sb, "'\\${" + newDate + "\\}'");
        }
        dateMatcher.appendTail(sb);
        return sb.toString();
    }


    private static String incrementMonthTemplate(String date,String changeDate) {
        // 增加逻辑来确定新日期，这里为简单起见，假设每个找到的日期都变为 '202405'
        return changeDate;
    }



}
