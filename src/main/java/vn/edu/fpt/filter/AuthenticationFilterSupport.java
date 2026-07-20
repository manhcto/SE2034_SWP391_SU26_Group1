package vn.edu.fpt.filter;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.Locale;

abstract class AuthenticationFilterSupport {
    protected User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object user = session == null ? null : session.getAttribute("user");
        return user instanceof User ? (User) user : null;
    }

    protected boolean hasRole(User user, int roleID, String... roleNames) {
        if (user == null) {
            return false;
        }

        String normalizedRole = normalizeRole(user.getRoleName());

        if (!normalizedRole.isEmpty()) {
            for (String roleName : roleNames) {
                if (normalizedRole.equals(normalizeRole(roleName))) {
                    return true;
                }
            }

            return false;
        }

        return user.getRoleID() == roleID;
    }

    protected void redirectToLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String redirect = toAppRelativePath(request, request.getRequestURI());
        String query = request.getQueryString();
        if (query != null && !query.isBlank()) {
            redirect += "?" + query;
        }

        request.getSession().setAttribute("redirectAfterLogin", redirect);
        response.sendRedirect(request.getContextPath() + "/login");
    }

    protected void deny(HttpServletResponse response) throws IOException {
        response.sendError(HttpServletResponse.SC_FORBIDDEN);
    }

    private String normalizeRole(String roleName) {
        if (roleName == null) {
            return "";
        }
        return roleName.toLowerCase(Locale.ROOT)
                .replaceAll("[\\s_-]+", "")
                .trim();
    }

    private String toAppRelativePath(HttpServletRequest request, String path) {
        if (path == null || path.isBlank()) {
            return "/home";
        }

        String contextPath = request.getContextPath();
        if (!contextPath.isEmpty() && path.startsWith(contextPath)) {
            String relativePath = path.substring(contextPath.length());
            return relativePath.isEmpty() ? "/" : relativePath;
        }

        return path;
    }
}
