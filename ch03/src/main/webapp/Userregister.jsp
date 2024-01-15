<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter,com.google.gson.Gson , java.util.*,웹프기말_포켓몬.UserEntity,웹프기말_포켓몬.PocketmonDBCP"%>
<jsp:useBean id="DBCP" class="웹프기말_포켓몬.PocketmonDBCP" scope="page" />
<%
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	boolean overlapId = DBCP.checkID(id,pw);
	// id가 중복이면 true, 등록실패
	
	if (overlapId){ //중복된 아이디가 있으니까 실패
		System.out.println("등록 실패");
		response.sendRedirect("loginpage.html");
	} else{
		// id, pw 데이터베이스에 등록
		System.out.println("등록 성공");
		DBCP.insertUser(id,pw);
		response.sendRedirect("loginpage.html");
	}
%>