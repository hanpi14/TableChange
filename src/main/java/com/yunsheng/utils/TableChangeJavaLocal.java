package com.yunsheng.utils;

import com.yunsheng.utils.GetChangeFormatAndDate;
import com.yunsheng.utils.GetFileName;
import com.yunsheng.utils.GetSparkSql;
import org.springframework.core.io.Resource;

import java.io.BufferedReader;

import java.io.FileReader;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.HashMap;

/**
 * 修改mysql,生成能在本地执行测试的sql
 */

public class TableChangeJavaLocal {

    /**
//     * 针对数仓迁移表名替换
//     * @param args
//     */
//
//    //原始mysql表名
//    private static String originalMysqlTable="original_mysql_table/薪资/订单明细.sql";
//
//    //catalog名称
//    private static String catalog="ods";
//
//    private static String changDate= "202405";
//    public static void main(String[] args) throws Exception {
//
//
//        //获取文件路径
//        Resource[] resources = GetFileName.getFileName();
//
//        BufferedReader br = null;
//
//        HashMap<String, String> map = new HashMap<>();
//
//        for (Resource resource : resources) {
//
//             br = new BufferedReader(new FileReader(resource.getFile()));
//
//            String line;
//
//            while ((line=br.readLine())!=null){
//
//                String[] split = line.trim().split(",");
//                map.put(split[2],split[1]);
//
//            }
//
//        }
//
//
//        // 读取文件进行比对
//
//        String sparkSql = GetSparkSql.getSparkSql(catalog,map, originalMysqlTable);
//
//
//        //替换 %Y%m,%Y%m%d,日期
//
//
//        String result = GetChangeFormatAndDate.getChangeFormatAndDate(sparkSql, changDate);
//
//
//        //本地测试sql语句
//        System.out.println(result);
//
////
////        System.out.println("======================================================================");
////        //生成ds模板文件使用
////
////        String replace = result.replace("dwd_order_emp_online_mi", "dw.dwd.dwd_order_emp_online_!{load_freq}i");
////
////        String template = GetChangeFormatAndDate.replaceDateTemplate(replace, "report_month");
////
////
////        System.out.println(template);
//    }



    public static String tableChangeJavaLocal(String originalMysqlTable,String catalog,String changDate) throws URISyntaxException, IOException {

        //获取文件路径
        Resource[] resources = GetFileName.getFileName();

        BufferedReader br = null;

        HashMap<String, String> map = new HashMap<>();

        for (Resource resource : resources) {

            br = new BufferedReader(new FileReader(resource.getFile()));

            String line;

            while ((line=br.readLine())!=null){

                String[] split = line.trim().split(",");
                map.put(split[2],split[1]);

            }

        }


        // 读取文件进行比对

        String sparkSql = GetSparkSql.getSparkSql(catalog,map, originalMysqlTable);


                //替换 %Y%m,%Y%m%d,日期


        String result = GetChangeFormatAndDate.getChangeFormatAndDate(sparkSql, changDate);


        return result;

    }
}
