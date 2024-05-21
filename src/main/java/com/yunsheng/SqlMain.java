package com.yunsheng;

import com.yunsheng.utils.GetChangeFormatAndDate;
import com.yunsheng.utils.TableChangeJavaLocal;
import com.yunsheng.utils.WriteFile;

public class SqlMain {


        //原始mysql表名
    private static String originalMysqlTable= "original_mysql_table/手工订单/全球雇手工订单.sql";

    //catalog名称
    private static String catalog="ods";

    private static String changeDate= "202405";

    private static String snapDate="2024-05-18 03:00:00";

    public static void main(String[] args) throws Exception {

        // TODO: 2024/5/20  通过mysql获取本地运行的sparksql



        String localSparkSql = TableChangeJavaLocal.tableChangeJavaLocal(originalMysqlTable, catalog, changeDate);

        String snapSqlLocal_ods = GetChangeFormatAndDate.snapSqlLocal(localSparkSql, snapDate);

        // TODO: 2024/5/21 此处需要针对替换完catalog和数据库名称的sql进行匹配,添加快照时间,针对dwd层的表
        String snapSqlLocal_dwd = GetChangeFormatAndDate.snapSqlLocalDwd(snapSqlLocal_ods, snapDate);




//        WriteFile.writeFileLocal(snapSqlLocal_dwd);



//        System.out.println(snapSqlLocal);




        // TODO: 2024/5/20 将本地sparksql转化为模板sql，用于构建模板文件
        String localResult = WriteFile.readFileLocal();

        String template = GetChangeFormatAndDate.replaceDateTemplate(localResult, "report_month");

        String result = GetChangeFormatAndDate.snapSqlChange(template);
        String dwdTableNameChange = GetChangeFormatAndDate.dwdTableNameChange(result);

        WriteFile.writeFileDs(dwdTableNameChange);

//        System.out.println(dwdTableNameChange);




    }
}
