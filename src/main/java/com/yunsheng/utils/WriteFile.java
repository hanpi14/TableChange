package com.yunsheng.utils;

import sun.applet.Main;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class WriteFile {


    public static void writeFileLocal(String input,String path) throws IOException, URISyntaxException {

        String resourceDirectory  = Paths.get(WriteFile.class.getResource("/").toURI()).toString();
        System.out.println(resourceDirectory);

        String paths = resourceDirectory + File.separator + "New_20240520"+File.separator+"Local"+File.separator+"薪资";

        System.out.println(paths);



        Files.createDirectories(Paths.get(paths));
//        File file = new File("New_20240520/Local"+path);
//        File file = new File("New_20240520\\Local\\original_mysql_table\\薪资\\");
//
//        if (!file.exists()){
//
//            boolean created = file.mkdirs();
//
//
//        }


//        BufferedWriter bw = new BufferedWriter(new FileWriter(file));
//
//
//        bw.write(input);
//        bw.flush();
//        bw.close();


    }


    public static void main(String[] args) throws IOException, URISyntaxException {

        writeFileLocal("nihao","original_mysql_table/薪资/订单明细.sql");

    }
}
