package com.yunsheng;

import com.yunsheng.utils.GetChangeFormatAndDate;
import com.yunsheng.utils.GetDataFormatAndDate;
import com.yunsheng.utils.TableChangeJavaLocal;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;

public class SqlMain {


        //原始mysql表名
    private static String originalMysqlTable="original_mysql_table/薪资/订单明细.sql";

    //catalog名称
    private static String catalog="ods";

    private static String changeDate= "202405";

    private static String snapDate="2024-05-18 03:00:00";

    public static void main(String[] args) throws URISyntaxException, IOException {

        // TODO: 2024/5/20  通过mysql获取本地运行的sparksql



        String localSparkSql = TableChangeJavaLocal.tableChangeJavaLocal(originalMysqlTable, catalog, changeDate);

        String snapSqlLocal = GetChangeFormatAndDate.snapSqlLocal(localSparkSql, snapDate);


        System.out.println(snapSqlLocal);


        // TODO: 2024/5/20 将本地sparksql转化为模板sql，用于构建模板文件
        String template = GetChangeFormatAndDate.replaceDateTemplate(localSparkSql, "report_month");

        String result = GetChangeFormatAndDate.snapSql(template);
        String dwdTableNameChange = GetChangeFormatAndDate.dwdTableNameChange(result);

//        System.out.println(dwdTableNameChange);




    }
}
