<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
<%
    // 요청에서 파라미터를 읽음
    String pokemon1 = request.getParameter("pokemon1");
    String pokemon2 = request.getParameter("pokemon2");
    String pokemon3 = request.getParameter("pokemon3");
	
    //선택된 포켓몬들을 섹션에 저장
    session.setAttribute("pokemon1", pokemon1);
    session.setAttribute("pokemon2", pokemon2);
    session.setAttribute("pokemon3", pokemon3);

    // 결과 페이지로 다시전송
    response.sendRedirect("battle.jsp");
%>
</body>
</html>