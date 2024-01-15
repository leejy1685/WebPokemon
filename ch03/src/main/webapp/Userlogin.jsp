<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter,com.google.gson.Gson , java.util.*,웹프기말_포켓몬.UserEntity,웹프기말_포켓몬.PocketmonDBCP"%>
<jsp:useBean id="DBCP" class="웹프기말_포켓몬.PocketmonDBCP" scope="page" />
<%
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String message = "";

    boolean isValidUser = DBCP.checkID(id, pw); // 사용자 인증

    // 테이블에서 id 검색 후 pw 비교

    if (isValidUser) {
        System.out.println("로그인 성공");
        response.sendRedirect("PocketMon_Select.html");
        return;
    } else {
        // 로그인 실패 시 메시지 설정 후 로그인 페이지로 리디렉션
        System.out.println("로그인 실패");
        session.setAttribute("message", "Invalid credentials. Please try again.");
        response.sendRedirect("loginpage.html"); // 로그인 페이지로 리디렉션
        return; // 리디렉션 후 코드 실행 중단
    }
%>