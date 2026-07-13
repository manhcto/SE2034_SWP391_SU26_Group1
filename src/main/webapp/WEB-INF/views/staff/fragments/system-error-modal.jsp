<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:if test="${not empty systemError}">
    <div class="system-modal-backdrop">
        <div class="system-modal">
            <h3>Không thể xử lý yêu cầu</h3>
            <p><c:out value="${systemError}" /></p>
            <button type="button" class="btn btn-primary" onclick="this.closest('.system-modal-backdrop').remove()">
                Đã hiểu
            </button>
        </div>
    </div>
</c:if>
