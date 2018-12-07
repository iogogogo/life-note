```java
package com.zz.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.Base64Utils;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.unit.DataSize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.MultipartConfigElement;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

/**
 * # 禁用 thymeleaf 缓存
 * spring.thymeleaf.cache=false
 * <p>
 * # 是否支持批量上传   (默认值 true)
 * spring.servlet.multipart.enabled=true
 * <p>
 * # 上传文件的临时目录 （一般情况下不用特意修改）
 * spring.servlet.multipart.location=
 * <p>
 * # 上传文件最大为 1M （默认值 1M 根据自身业务自行控制即可）
 * spring.servlet.multipart.max-file-size=1048576
 * <p>
 * # 上传请求最大为 10M（默认值10M 根据自身业务自行控制即可）
 * spring.servlet.multipart.max-request-size=10485760
 * <p>
 * # 文件大小阈值，当大于这个阈值时将写入到磁盘，否则存在内存中，（默认值0 一般情况下不用特意修改）
 * spring.servlet.multipart.file-size-threshold=0
 * <p>
 * # 判断是否要延迟解析文件（相当于懒加载，一般情况下不用特意修改）
 * spring.servlet.multipart.resolve-lazily=false
 * <p>
 * Created by tao.zeng on 2018/12/6.
 * http://localhost:8080/api/file/download2stream
 * http://localhost:8080/api/file/download
 */
@RestController
@RequestMapping("/api/file")
public class FileApi {

    private Logger logger = LoggerFactory.getLogger(FileApi.class);

    private final static String FILE_NAME = "main.csv";

    private final static String FILE_CONTENT = "key,value";

    private final static String FILE_PATH = System.getProperty("user.dir") + File.separator + "tmp";

    static {
        File file = new File(FILE_PATH);
        if (!file.exists()) {
            file.mkdirs();
        }
    }


    /**
     * 通过 OutputStream 每次往客户端写 buffer
     *
     * @param response
     */
    @GetMapping("/download")
    public void download(HttpServletResponse response) {
        InputStream inStream = new ByteArrayInputStream(FILE_CONTENT.getBytes());
        // 设置强制下载不打开
        response.setContentType("application/force-download");
        // 设置content-type
        response.setHeader(HttpHeaders.CONTENT_TYPE, "application/octet-stream");
        // 设置文件名
        response.addHeader(HttpHeaders.CONTENT_DISPOSITION, "attachment;fileName=" + FILE_NAME);
        byte[] buffer = new byte[1024];
        ServletOutputStream outStream = null;
        BufferedInputStream bufferStream = null;
        try {
            outStream = response.getOutputStream();
            bufferStream = new BufferedInputStream(inStream);
            int len;
            while ((len = bufferStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, len);
            }
            outStream.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            close(outStream, bufferStream);
        }
    }

    /**
     * 流式下载
     *
     * @return
     */
    @GetMapping("/download2stream")
    public ResponseEntity<Resource> download2stream() {
        InputStream inStream = null;
        try {
            inStream = new ByteArrayInputStream(FILE_CONTENT.getBytes());
            Resource resource = new InputStreamResource(inStream);
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("application/octet-stream;charset=UTF-8"))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;fileName=" + FILE_NAME)
                    .body(resource);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("下载异常:" + e);
        } finally {
            close(inStream);
        }

    }

    /**
     * multipart/form-data
     *
     * @param file
     * @return
     */
    @PostMapping("/upload")
    public Map<String, Object> upload(@RequestParam("file") MultipartFile file) {
        // 获取 resources 目录
        // String realPath = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest().getServletContext().getRealPath("");
        Map<String, Object> result = new HashMap<>(16);
        try {
            logger.info("[文件类型] - [{}]", file.getContentType());
            logger.info("[文件名称] - [{}]", file.getOriginalFilename());
            logger.info("[文件大小] - [{}]", file.getSize());
            byte[] bytes = file.getBytes();
            String fileName = FILE_PATH + File.separator + file.getOriginalFilename();
            Path path = Paths.get(fileName);
            Files.write(path, bytes);

            result.put("contentType", file.getContentType());
            result.put("fileName", file.getOriginalFilename());
            result.put("fileSize", file.getSize());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 多文件上传
     *
     * @param files
     * @return
     */
    @PostMapping("/multi-file-upload")
    public List<Map<String, Object>> multiFileUpload(@RequestParam("file") MultipartFile[] files) {
        if (files == null || files.length == 0) {
            return null;
        }
        List<Map<String, Object>> results = new ArrayList<>();
        Map<String, Object> map;
        try {
            for (MultipartFile file : files) {
                map = new HashMap<>(16);
                String fileName = FILE_PATH + File.separator + file.getOriginalFilename();
                file.transferTo(new File(fileName));
                map.put("contentType", file.getContentType());
                map.put("fileName", file.getOriginalFilename());
                map.put("fileSize", file.getSize());
                results.add(map);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return results;
    }


    /**
     * Base64文件上传
     * <p>
     * base64编码： http://base64.xpcha.com/pic.html
     *
     * @param base64
     * @return
     */
    @PostMapping("/base64-upload")
    public Map<String, Object> uploadBase64(String base64) {
        Map<String, Object> map = new HashMap<>(16);
        // 防止有的传了 data:image/png;base64, 有的没传的情况
        String[] d = base64.split("base64,");
        final byte[] bytes = Base64Utils.decodeFromString(d.length > 1 ? d[1] : d[0]);
        // BASE64 方式的 格式和名字需要自己控制（如 png 图片编码后前缀就会是 data:image/png;base64,）
        File tempFile = new File(FILE_PATH + File.separator + UUID.randomUUID() + ".jpg");
        try {
            FileCopyUtils.copy(bytes, tempFile);
            map.put("fileSize", tempFile.length());
            map.put("fileName", tempFile.getName());
            map.put("parent", tempFile.getParent());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return map;
    }

    private void close(Closeable... closeables) {
        try {
            if (closeables != null) {
                for (Closeable io : closeables) {
                    if (io != null) {
                        io.close();
                    }
                }
            }
        } catch (IOException e) {
            logger.warn("io close exception {}", e);
        }
    }

    @Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        // 最大支持文件大小
        factory.setMaxFileSize(DataSize.ofMegabytes(10));

        // 最大支持请求大小
        factory.setMaxRequestSize(DataSize.ofMegabytes(100));

        // 支持文件写入磁盘.
        // factory.setFileSizeThreshold();

        // Sets the directory location where files will be stored.
        // factory.setLocation("上传文件的临时目录");
        return factory.createMultipartConfig();
    }
}

```

