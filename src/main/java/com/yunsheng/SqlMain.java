package com.yunsheng;

import com.yunsheng.utils.TableChangeJavaLocal;

import java.io.IOException;
import java.net.URISyntaxException;

public class SqlMain {


        //原始mysql表名
    private static String originalMysqlTable="original_mysql_table/薪资/订单明细.sql";

    //catalog名称
    private static String catalog="ods";

    private static String changeDate= "202405";

    public static void main(String[] args) throws URISyntaxException, IOException {

        //通过mysql获取本地运行的sparksql

        String localSparkSql = TableChangeJavaLocal.tableChangeJavaLocal(originalMysqlTable, catalog, changeDate);


        System.out.println(localSparkSql);

    }
}
