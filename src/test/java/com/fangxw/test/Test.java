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


    @org.junit.Test
    public void testUU(){

        // 待匹配的日期时间字符串
        String dateTimeString = "select * from t1 where date = '2024-05-18 03:00:00'";

        // 定义正则表达式匹配模式
        String patternString = "\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}";
        Pattern pattern = Pattern.compile(patternString);

        // 创建Matcher对象
        Matcher matcher = pattern.matcher(dateTimeString);

        // 进行匹配和替换
        String result = matcher.replaceAll("\\${snap_date\\}");

        // 输出结果
        System.out.println("原始字符串：" + dateTimeString);
        System.out.println("替换后的字符串：" + result);



    }


    @org.junit.Test
    public void testYY(){


        String sql = "DELETE \n" +
                "FROM dw.dwd.dwd_order_emp_online_mi \n" +
                "WHERE order_item = '退费扣手续费' \n" +
                "AND is_sup = 1 \n" +
                "AND order_type = 1; \n" +
                " \n" +
                "INSERT INTO dw.dwd.dwd_order_emp_online_mi(data_source, order_no, order_type, business_type, ar_no, order_month, \n" +
                "raw_order_month, fee_month, \n" +
                "member_code, member_name, \n" +
                "party_b, \n" +
                "emp_name, emp_id_no, mobile, region, raw_region, order_region,raw_order_region, order_item, \n" +
                "order_tax_rate, \n" +
                "reward_tax_rate, is_solo, \n" +
                "is_collect, is_cross, \n" +
                "is_refund, \n" +
                "is_extra, \n" +
                "is_sup, \n" +
                "is_cancel, \n" +
                "is_diff, \n" +
                "is_ignore, \n" +
                "is_discard, \n" +
                "income_type, \n" +
                "income_reward, raw_income_reward, income_order, raw_income_order, income_overdue, \n" +
                "income_disabled, \n" +
                "income_added_tax, \n" +
                "income_stable, income_indv_tax, serve_count, supplier_code, supplier_name, cost_type, \n" +
                "cost_reward, \n" +
                "sale_emp_name, \n" +
                "serve_emp_id, \n" +
                "sale_emp_id, serve_dept_id, sale_dept_id, order_parm, indv_net_pay, \n" +
                "indv_income_tax, \n" +
                "income_indv_order, \n" +
                "income_corp_order, corp_pension_amount, corp_pension_rate, indv_pension_amount, \n" +
                "indv_pension_rate, corp_illness_amount, corp_illness_rate, indv_illness_amount, \n" +
                "indv_illness_rate, corp_work_amount, corp_work_rate, indv_work_amount, indv_work_rate, \n" +
                "corp_unemployed_amount, corp_unemployed_rate, indv_unemployed_amount, \n" +
                "indv_unemployed_rate, \n" +
                "corp_birth_amount, corp_birth_rate, indv_birth_amount, indv_birth_rate, \n" +
                "corp_disabled_amount, \n" +
                "corp_disabled_rate, indv_disabled_amount, indv_disabled_rate, \n" +
                "corp_serious_illness_amount, \n" +
                "corp_serious_illness_rate, indv_serious_illness_amount, indv_serious_illness_rate, \n" +
                "corp_ext_illness_amount, corp_ext_illness_rate, indv_ext_illness_amount, \n" +
                "indv_ext_illness_rate, \n" +
                "corp_hospital_amount, corp_hospital_rate, indv_hospital_amount, indv_hospital_rate, \n" +
                "corp_fund_amount, corp_fund_rate, indv_fund_amount, indv_fund_rate, indv_union_amount, \n" +
                "indv_other_amount, debit_card_no, bank_name, bank_region, tax_corp, raw_create_time, \n" +
                "comment,raw_order_no,batch_no) \n" +
                "SELECT 1 AS data_source, \n" +
                "A.order_no AS order_no, \n" +
                "1 AS order_type, \n" +
                "IFNULL(B.business_type, -1) AS business_type, \n" +
                "A.ar_no AS ar_no, \n" +
                "A.order_month AS order_month, \n" +
                "A.order_month AS raw_order_month, \n" +
                "A.order_month AS fee_month, \n" +
                "A.member_code AS member_code, \n" +
                "A.member_name AS member_name, \n" +
                "A.party_b AS party_b, \n" +
                "REPLACE(UUID(), _utf8'-', _utf8'') AS emp_name, \n" +
                "REPLACE(UUID(), _utf8'-', _utf8'') AS emp_id_no, \n" +
                "'' AS mobile, \n" +
                "A.region AS region, \n" +
                "A.raw_region AS raw_region, \n" +
                "A.region AS order_region, \n" +
                "A.raw_region AS raw_order_region, \n" +
                "'退费扣手续费' AS order_item, \n" +
                "0 AS order_tax_rate, \n" +
                "A.reward_tax_rate AS reward_tax_rate, \n" +
                "0 AS is_solo, \n" +
                "1 AS is_collect, \n" +
                "0 AS is_cross, \n" +
                "0 AS is_refund, \n" +
                "0 AS is_extra, \n" +
                "1 AS is_sup, \n" +
                "0 AS is_cancel, \n" +
                "0 AS is_diff, \n" +
                "0 AS is_ignore, \n" +
                "0 AS is_discard, \n" +
                "A.income_type AS income_type, \n" +
                "A.income_reward AS income_reward, \n" +
                "A.income_reward AS raw_income_reward, \n" +
                "0 AS income_order, \n" +
                "0 AS raw_income_order, \n" +
                "0 AS income_overdue, \n" +
                "0 AS income_disabled, \n" +
                "0 AS income_added_tax, \n" +
                "0 AS income_stable, \n" +
                "0 AS income_indv_tax, \n" +
                "1 AS serve_count, \n" +
                "'' AS supplier_code, \n" +
                "'' AS supplier_name, \n" +
                "1 AS cost_type, \n" +
                "0 AS cost_reward, \n" +
                "'' AS sale_emp_name, \n" +
                "A.serve_emp_id AS serve_emp_id, \n" +
                "A.sale_emp_id AS sale_emp_id, \n" +
                "A.serve_dept_id AS serve_dept_id, \n" +
                "A.sale_dept_id AS sale_dept_id, \n" +
                "0 AS order_parm, \n" +
                "0 AS indv_net_pay, \n" +
                "0 AS indv_income_tax, \n" +
                "0 AS income_indv_order, \n" +
                "0 AS income_corp_order, \n" +
                "0 AS corp_pension_amount, \n" +
                "0 AS corp_pension_rate, \n" +
                "0 AS indv_pension_amount, \n" +
                "0 AS indv_pension_rate, \n" +
                "0 AS corp_illness_amount, \n" +
                "0 AS corp_illness_rate, \n" +
                "0 AS indv_illness_amount, \n" +
                "0 AS indv_illness_rate, \n" +
                "0 AS corp_work_amount, \n" +
                "0 AS corp_work_rate, \n" +
                "0 AS indv_work_amount, \n" +
                "0 AS indv_work_rate, \n" +
                "0 AS corp_unemployed_amount, \n" +
                "0 AS corp_unemployed_rate, \n" +
                "0 AS indv_unemployed_amount, \n" +
                "0 AS indv_unemployed_rate, \n" +
                "0 AS corp_birth_amount, \n" +
                "0 AS corp_birth_rate, \n" +
                "0 AS indv_birth_amount, \n" +
                "0 AS indv_birth_rate, \n" +
                "0 AS corp_disabled_amount, \n" +
                "0 AS corp_disabled_rate, \n" +
                "0 AS indv_disabled_amount, \n" +
                "0 AS indv_disabled_rate, \n" +
                "0 AS corp_serious_illness_amount, \n" +
                "0 AS corp_serious_illness_rate, \n" +
                "0 AS indv_serious_illness_amount, \n" +
                "0 AS indv_serious_illness_rate, \n" +
                "0 AS corp_ext_illness_amount, \n" +
                "0 AS corp_ext_illness_rate, \n" +
                "0 AS indv_ext_illness_amount, \n" +
                "0 AS indv_ext_illness_rate, \n" +
                "0 AS corp_hospital_amount, \n" +
                "0 AS corp_hospital_rate, \n" +
                "0 AS indv_hospital_amount, \n" +
                "0 AS indv_hospital_rate, \n" +
                "0 AS corp_fund_amount, \n" +
                "0 AS corp_fund_rate, \n" +
                "0 AS indv_fund_amount, \n" +
                "0 AS indv_fund_rate, \n" +
                "0 AS indv_union_amount, \n" +
                "0 AS indv_other_amount, \n" +
                "'' AS debit_card_no, \n" +
                "'' AS bank_name, \n" +
                "'' AS bank_region, \n" +
                "'' AS tax_corp, \n" +
                "A.raw_create_time AS raw_create_time, \n" +
                "'' AS comment, \n" +
                "'' AS raw_order_no, \n" +
                "REPLACE(UUID(), _utf8'-', _utf8'') AS batch_no \n" +
                "FROM dw.dwd.dwd_ar_mi A \n" +
                "LEFT JOIN dw.dwd.mid_product_business_mapping B ON A.product_name = B.product_name AND B.tag = 4 \n" +
                "WHERE A.data_source = -3 \n" +
                "AND A.is_discard = 0 \n" +
                "AND A.is_split = 0 \n";


        // 定义匹配 INSERT INTO 语句的正则表达式
        String insertRegex = "(?i)(INSERT\\s+INTO\\s+[a-zA-Z0-9_\\.]+)";
        Pattern insertPattern = Pattern.compile(insertRegex);
        Matcher insertMatcher = insertPattern.matcher(sql);

        // 用于保存保留 INSERT INTO 语句的结果
        StringBuffer sqlWithInsert = new StringBuffer();
        while (insertMatcher.find()) {
            String matchedPart = insertMatcher.group(1);
            insertMatcher.appendReplacement(sqlWithInsert, Matcher.quoteReplacement(matchedPart));
        }
        insertMatcher.appendTail(sqlWithInsert);

        // 替换 FROM 和 JOIN 语句中的表名
        String fromJoinRegex = "(?i)(FROM|LEFT JOIN|INNER JOIN)\\s+([a-zA-Z0-9_\\.]+)";
        Pattern fromJoinPattern = Pattern.compile(fromJoinRegex);
        Matcher fromJoinMatcher = fromJoinPattern.matcher(sqlWithInsert.toString());

        StringBuffer finalSql = new StringBuffer();
        while (fromJoinMatcher.find()) {
            String keyword = fromJoinMatcher.group(1);
            String tableName = fromJoinMatcher.group(2);

            // 替换表名
            String newTableName = tableName + "_replaced"; // 在这里定义你的替换逻辑

            fromJoinMatcher.appendReplacement(finalSql, keyword + " " + newTableName);
        }
        fromJoinMatcher.appendTail(finalSql);

        // 输出最终的 SQL 语句
        System.out.println("最终的 SQL 语句：");
        System.out.println(finalSql.toString());





    }




}
