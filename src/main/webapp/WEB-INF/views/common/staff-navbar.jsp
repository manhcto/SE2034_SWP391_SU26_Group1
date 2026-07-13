<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%
    String ctx = request.getContextPath();
    String uri = request.getRequestURI();
    boolean tourListActive = uri.contains("/staff/tour/list") || uri.contains("/staff/tour/view") || uri.contains("/staff/tour/edit") || uri.contains("/staff/tour-schedule/");
    boolean tourAddActive = uri.contains("/staff/tour/add");
    boolean assignmentActive = uri.contains("/staff/tour-assignment/");
    boolean privateActive = uri.contains("/staff/private-request/");
%>
<aside class="staff-sidebar">
    <div class="sidebar-brand">
        <span class="brand-mark">VN</span>
        <span>WonderVN Staff</span>
    </div>
    <nav class="sidebar-menu">
        <a class="<%= tourListActive ? "active" : "" %>" href="<%= ctx %>/staff/tour/list">▦ Quản lý tour</a>
        <a class="<%= tourAddActive ? "active" : "" %>" href="<%= ctx %>/staff/tour/add">＋ Tạo tour mới</a>
        <a href="<%= ctx %>/staff/tour/list">▣ Lịch khởi hành</a>
        <a class="<%= assignmentActive ? "active" : "" %>" href="<%= ctx %>/staff/tour-assignment/list">⚭ Phân bổ tài nguyên</a>
        <a class="<%= privateActive ? "active" : "" %>" href="<%= ctx %>/staff/private-request/list">◌ Yêu cầu tour riêng</a>
        <a href="#">▥ Báo cáo</a>
    </nav>
</aside>
