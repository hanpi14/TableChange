package com.yunsheng.utils;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.stream.Collectors;

public class GetFileName {


    public static Resource[] getFileName() throws URISyntaxException, IOException {



        // 创建资源解析器
        PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

        Resource[] resources = resolver.getResources("classpath*:table_schema_now/*");
//        for (Resource resource : resources) {
//            System.out.println("Found file: " + resource.getFilename()+" "+resource.getURI());
//
//
//        }
        return resources;
    }

    public static void main(String[] args) throws URISyntaxException, IOException {

        getFileName();


    }
}
