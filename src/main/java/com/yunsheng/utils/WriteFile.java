package com.yunsheng.utils;

import sun.applet.Main;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Paths;

public class WriteFile {


    public static void writeFileLocal(String input) throws IOException, URISyntaxException {

        File file = new File("E:\\桌面\\src_code\\TableChange\\src\\main\\resources\\TempDir\\Local.sql");
//        File file = new File("E:\\complie\\TableChange\\src\\main\\resources\\TempDir\\Local.sql");
        BufferedWriter bw = new BufferedWriter(new FileWriter(file));

        bw.write(input);
        bw.flush();
        bw.close();


    }



       public static String  readFileLocal() throws Exception {

           File file = new File("E:\\桌面\\src_code\\TableChange\\src\\main\\resources\\TempDir\\Local.sql");
//           File file = new File("E:\\complie\\TableChange\\src\\main\\resources\\TempDir\\Local.sql");

           BufferedReader br = new BufferedReader(new FileReader(file));


           String line;

           StringBuffer sb = new StringBuffer();

           while ((line=br.readLine())!= null){

               sb.append(line).append("\n");

           }


//           System.out.println();

           return sb.toString();
    }


    public static void writeFileDs(String input) throws IOException, URISyntaxException {

        File file = new File("E:\\桌面\\src_code\\TableChange\\src\\main\\resources\\TempDir\\Ds.sql");
//        File file = new File("E:\\complie\\TableChange\\src\\main\\resources\\TempDir\\Ds.sql");
        BufferedWriter bw = new BufferedWriter(new FileWriter(file));

        bw.write(input);
        bw.flush();
        bw.close();


    }


    public static void main(String[] args) throws Exception {


        readFileLocal();
    }
}
