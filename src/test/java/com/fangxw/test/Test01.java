package com.fangxw.test;

import org.junit.Test;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Test01 {

    @Test
    public void Test01(){

        // 输入字符串
        String input = "DATE_FORMAT(Q.confirm_time, '%Y%m') = '202203' OR (P.tax_months = DATE_FORMAT(DATE_SUB(STR_TO_DATE(CONCAT('202204', '01'), '%Y%m%d'), INTERVAL 1 MONTH))";

        // 正则表达式和替换 '%Y%m' 为 'yyyyMM'
        input = replaceDateFormat(input, "%Y%m", "yyyyMM");

        // 正则表达式和替换 '%Y%m%d' 为 'yyyyMMdd'
        input = replaceDateFormat(input, "%Y%m%d", "yyyyMMdd");

        // 正则表达式和替换 '202204' 为 '202405', 这里'202204'是模糊匹配，可以为任何六位数字
        input = replaceDate(input);

        // 输出更新后的字符串
        System.out.println("Updated String: " + input);

    }



    private static String replaceDateFormat(String input, String oldFormat, String newFormat) {
        return input.replaceAll(Pattern.quote(oldFormat), newFormat);
    }

    private static String replaceDate(String input) {
        // 使用正则表达式匹配 'YYYYMM' 格式的日期并替换为 '202405'
        Pattern datePattern = Pattern.compile("'\\d{6}'");
        Matcher dateMatcher = datePattern.matcher(input);
        StringBuffer sb = new StringBuffer();
        while (dateMatcher.find()) {
            String matchedDate = dateMatcher.group();
            String newDate = incrementMonth(matchedDate.replaceAll("'", ""));
            dateMatcher.appendReplacement(sb, "'" + newDate + "'");
        }
        dateMatcher.appendTail(sb);
        return sb.toString();
    }
    private static String incrementMonth(String date) {
        // 增加逻辑来确定新日期，这里为简单起见，假设每个找到的日期都变为 '202405'
        return "202405";
    }
}
