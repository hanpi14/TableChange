package com.yunsheng.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Locale;

import static com.yunsheng.utils.GetSparkTableName.getSparkTableName;

/**
 *  mysql 结构转化为 sparkSql
 */

public class GetSparkSql {



    public static void getSparkSql(HashMap<String,String> map,String fileName) throws IOException {

        InputStream stream = ClassLoader.getSystemResourceAsStream("original_mysql_table/"+fileName);

        BufferedReader br = new BufferedReader(new InputStreamReader(stream));

        String line;

        while ((line = br.readLine())!= null){
//            System.out.println(line.trim());
            String[] split = line.trim().split("\\s+");

            StringBuffer sb = new StringBuffer();

            for (String string : split) {

                if (string.trim().toLowerCase(Locale.ROOT).startsWith("ods_")){
                    getSparkTableName(string);
                }

                sb.append(string.trim()).append(" ");

            }


        }




    }


    public static void main(String[] args) throws IOException {

        getSparkSql(new HashMap<>(),"HRO项目管理费.sql");
    }
}
