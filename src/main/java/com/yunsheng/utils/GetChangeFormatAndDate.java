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



    public static String snapSqlLocal(String input,String snapDate){

//        String input = "SELECT * FROM ods.sbt_prod.oprt_boss_organization WHERE ...";
        String regex = "(?i)ods\\.([a-zA-Z0-9_]+)\\.([a-zA-Z0-9_]+)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);

        StringBuffer output = new StringBuffer();
        while (matcher.find()) {
            String group = matcher.group(0);
            String schema = matcher.group(1); // 匹配到的schema名
            String tableName = matcher.group(2); // 匹配到的表名
            // 这里可以根据需要对 schema 和 tableName 进行处理，例如替换成其他值
            matcher.appendReplacement(output, "\\("+group+" FOR SYSTEM_TIME AS OF \\'"+snapDate+"\\' )");
        }
        matcher.appendTail(output);

//        System.out.println("替换后的字符串: " + output.toString());

        return output.toString();
    }




    public static String snapSql(String input){

//        String input = "SELECT * FROM ods.sbt_prod.oprt_boss_organization WHERE ...";
        String regex = "(?i)ods\\.([a-zA-Z0-9_]+)\\.([a-zA-Z0-9_]+)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);

        StringBuffer output = new StringBuffer();
        while (matcher.find()) {
            String group = matcher.group(0);
            String schema = matcher.group(1); // 匹配到的schema名
            String tableName = matcher.group(2); // 匹配到的表名
            // 这里可以根据需要对 schema 和 tableName 进行处理，例如替换成其他值
            matcher.appendReplacement(output, "\\("+group+" FOR SYSTEM_TIME AS OF \\'\\${snap_date\\}\\' )");
        }
        matcher.appendTail(output);

//        System.out.println("替换后的字符串: " + output.toString());

        return output.toString();
    }



    public static String dwdTableNameChange(String input){


//        String input = "SELECT * FROM dwd_online_mi WHERE ...";
        String regex = "\\b([a-zA-Z0-9_]+)mi\\b";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);

        StringBuffer output = new StringBuffer();
        while (matcher.find()) {

//            System.out.println(matcher.group(0));
            String tableName = matcher.group(1); // 匹配到的表名
//            String tableName2 = matcher.group(2); // 匹配到的表名
//            System.out.println(tableName);
//            System.out.println(tableName2);
            // 这里可以根据需要对 tableName 进行处理，例如替换成其他值
            matcher.appendReplacement(output, "dw.dwd."+tableName+"!{load_freq}i");
        }
        matcher.appendTail(output);

//        System.out.println("替换后的字符串: " + output.toString());


        return  output.toString();
    }


}
