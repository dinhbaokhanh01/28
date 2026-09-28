Nội dung báo cáo chi tiết cho bài tập "Ứng dụng tra cứu Từ điển Anh - Việt" (JSP/Servlet, Jakarta EE, Tomcat 10+) đã được chuẩn hóa đầy đủ. Bạn có thể sao chép nội dung bên dưới dán trực tiếp vào file Word/Text để làm tài liệu nộp bài.

BÁO CÁO BÀI TẬP: ỨNG DỤNG TRA CỨU TỪ ĐIỂN ANH - VIỆT
1. Cấu trúc thư mục dự án (Maven Webapp)
Plaintext
jsp-servlet-dictionary/
├── pom.xml                                      # File cấu hình quản lý thư viện Maven
└── src/
    └── main/
        ├── java/                                # Nơi chứa mã nguồn Java Servlets
        │   └── com/
        │       └── codegym/
        │           └── DictionaryServlet.java   # Xử lý logic tra cứu từ vựng
        └── webapp/                              # Nơi chứa trang giao diện HTML/JSP
            ├── index.jsp                        # Trang chủ chứa Form tra cứu từ
            └── WEB-INF/
                └── web.xml                      # File cấu hình ứng dụng Web
2. Mã nguồn chi tiết các file
File 1: pom.xml (Cấu hình Maven - Chuẩn Jakarta EE cho Tomcat 10+)
XML
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.codegym</groupId>
    <artifactId>jsp-servlet-dictionary</artifactId>
    <packaging>war</packaging>
    <version>1.0-SNAPSHOT</version>
    <name>Dictionary Maven Webapp</name>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <!-- Jakarta Servlet API tương thích Tomcat 10+ -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
        </dependency>
        
        <!-- Jakarta JSP API -->
        <dependency>
            <groupId>jakarta.servlet.jsp</groupId>
            <artifactId>jakarta.servlet.jsp-api</artifactId>
            <version>3.1.1</version>
            <scope>provided</scope>
        </dependency>
    </dependencies>

    <build>
        <finalName>jsp-servlet-dictionary</finalName>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.4.0</version>
            </plugin>
        </plugins>
    </build>
</project>
File 2: index.jsp (Giao diện Form tra cứu)
Đường dẫn tệp: src/main/webapp/index.jsp

Java
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Từ điển Anh - Việt</title>
        <style>
            body { font-family: 'Arial', sans-serif; display: flex; justify-content: center; margin-top: 100px; background-color: #f8fafc; }
            .dictionary-container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); text-align: center; width: 350px; }
            input { padding: 12px; margin: 15px 0; width: 90%; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 16px;}
            button { background-color: #1b2a7a; color: white; padding: 12px 20px; border: none; border-radius: 4px; cursor: pointer; width: 90%; font-weight: bold; font-size: 16px;}
            button:hover { background-color: #121c54; }
        </style>
    </head>
    <body>
        <div class="dictionary-container">
            <h2 style="color: #1b2a7a;">Từ Điển Anh - Việt</h2>
            <!-- Form gửi dữ liệu bằng phương thức POST tới đường dẫn /translate -->
            <form action="translate" method="POST">
                <input type="text" name="word" placeholder="Nhập từ tiếng Anh..." required autofocus />
                <button type="submit">Tìm kiếm</button>
            </form>
        </div>
    </body>
</html>
File 3: DictionaryServlet.java (Tầng xử lý logic tra cứu từ vựng)
Đường dẫn tệp: src/main/java/com/codegym/DictionaryServlet.java

Java
package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Khai báo định tuyến URL: Khi gõ "/translate", trình duyệt sẽ kích hoạt Servlet này
@WebServlet(name = "DictionaryServlet", urlPatterns = {"/translate"})
public class DictionaryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Cấu hình phản hồi hiển thị HTML và hỗ trợ hiển thị Tiếng Việt
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        // Khởi tạo danh sách từ vựng (Từ điển cơ bản)
        Map<String, String> dictionary = new HashMap<>();
        dictionary.put("hello", "Xin chào");
        dictionary.put("how", "Thế nào");
        dictionary.put("book", "Quyển sách");
        dictionary.put("computer", "Máy tính");
        dictionary.put("student", "Sinh viên");

        // Nhận tham số 'word' từ Form
        String searchWord = request.getParameter("word");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head><title>Kết quả tra cứu</title></head>");
            out.println("<body style='font-family: Arial, sans-serif; text-align: center; margin-top: 100px;'>");
            
            if (searchWord != null && !searchWord.trim().isEmpty()) {
                // Chuyển từ khóa về chữ thường để tra cứu không phân biệt hoa/thường
                String result = dictionary.get(searchWord.trim().toLowerCase());
                
                if (result != null) {
                    out.println("<h2 style='color: #1b2a7a;'>Từ khóa: " + searchWord + "</h2>");
                    out.println("<h3 style='color: #27ae60;'>Nghĩa tiếng Việt: " + result + "</h3>");
                } else {
                    out.println("<h2 style='color: red;'>Không tìm thấy từ: " + searchWord + "</h2>");
                }
            } else {
                out.println("<h2 style='color: orange;'>Vui lòng nhập từ khóa hợp lệ!</h2>");
            }
            
            out.println("<br><a href='index.jsp' style='text-decoration: none; padding: 10px 20px; background-color: #1b2a7a; color: white; border-radius: 4px;'>Quay lại</a>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
