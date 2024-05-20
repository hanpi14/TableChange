package com.fangxw.test;

import com.yunsheng.utils.GetChangeFormatAndDate;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class ChangeDateToFormat {


    @Test
    public void getTemplate() throws IOException {

        File file = new File("E:\\桌面\\src_code\\TableChange\\src\\main\\resources\\spark_table_localTest\\退费订单\\退费薪资订单逻辑.sql");

        BufferedReader br = new BufferedReader(new FileReader(file));


        String line;

        StringBuffer stringBuffer = new StringBuffer();

        while ((line=br.readLine())!=null){


           stringBuffer.append(line.trim()).append("\n");


        }



        String replace = stringBuffer.toString().trim().replace("dwd_order_emp_online_mi", "dw.dwd.dwd_order_emp_online_!{load_freq}i");

        String template = GetChangeFormatAndDate.replaceDateTemplate(replace, "report_month");


        System.out.println(template);


    }
}
