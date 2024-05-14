import com.yunsheng.utils.GetFileName;
import org.springframework.core.io.Resource;

import java.io.BufferedReader;
import java.io.File;

import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

public class TableChangeJava {

    /**
     * 针对数仓迁移表名替换
     * @param args
     */
    public static void main(String[] args) throws Exception {


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

//        for (String string : map.keySet()) {
//            System.out.println(string+","+map.get(string));
//        }

        // 读取文件进行比对






    }
}
