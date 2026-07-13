package vn.edu.fpt.controller.authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.UserDAO;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final String REMEMBER_EMAIL_COOKIE = "wondervn_remember_email";
    private static final int REMEMBER_EMAIL_MAX_AGE = 30 * 24 * 60 * 60;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = trimToEmpty(request.getParameter("email"));
        String password = valueOrEmpty(request.getParameter("password"));
        boolean remember = "on".equals(request.getParameter("remember"));
        request.setAttribute("email", email);
        request.setAttribute("remember", remember);

        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession oldSession = request.getSession(false);
            String redirectAfterLogin = getRedirectAfterLogin(request, oldSession);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            updateRememberEmailCookie(request, response, remember ? email : null);

            session.removeAttribute("redirectAfterLogin");

            redirectByRole(request, response, user, redirectAfterLogin);
            return;
        }

        clearLoggedInUser(request);

        User existingUser = userDAO.getUserByEmail(email);

        if (existingUser == null) {
            request.setAttribute("error", "Email không tồn tại!");
        } else {
            String status = existingUser.getStatus();

            if ("Inactive".equalsIgnoreCase(status)) {
                request.setAttribute("error", "Tài khoản đã xóa!");
            } else {
                request.setAttribute("error", "Sai mật khẩu!");
            }
        }

        request.getRequestDispatcher("/views/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String rememberedEmail = readRememberedEmail(request);
        if (!rememberedEmail.isEmpty()) {
            request.setAttribute("rememberedEmail", rememberedEmail);
            request.setAttribute("remember", true);
        }

        String redirect = normalizeRedirect(request, request.getParameter("redirect"));
        HttpSession session = isSafeRedirect(redirect)
                ? request.getSession()
                : request.getSession(false);

        if (session != null) {
            if (isSafeRedirect(redirect)) {
                session.setAttribute("redirectAfterLogin", redirect);
                request.setAttribute("redirectAfterLogin", redirect);
            } else {
                String redirectAfterLogin = normalizeRedirect(
                        request,
                        (String) session.getAttribute("redirectAfterLogin")
                );

                if (isSafeRedirect(redirectAfterLogin)) {
                    session.setAttribute("redirectAfterLogin", redirectAfterLogin);
                    request.setAttribute("redirectAfterLogin", redirectAfterLogin);
                }
            }

            String successMsg = (String) session.getAttribute("successMsg");

            if (successMsg != null) {
                request.setAttribute("successMsg", successMsg);
                session.removeAttribute("successMsg");
            }
        }

        request.getRequestDispatcher("/views/login.jsp")
                .forward(request, response);
    }

    private void redirectByRole(HttpServletRequest request,
                                HttpServletResponse response,
                                User user,
                                String redirectAfterLogin)
            throws IOException {

        String roleName = normalizeRoleName(user.getRoleName());

        if ("admin".equals(roleName) || user.getRoleID() == 1) {
            response.sendRedirect(request.getContextPath() + "/admin/home");
            return;
        }

        if (isTourGuide(user, roleName)) {
            response.sendRedirect(request.getContextPath() + "/guide/home");
            return;
        }

        if (isStaff(user, roleName)) {
            response.sendRedirect(request.getContextPath() + "/staff/home");
            return;
        }

        response.sendRedirect(request.getContextPath() + redirectAfterLogin);
    }

    private String getRedirectAfterLogin(HttpServletRequest request, HttpSession session) {
        String redirect = normalizeRedirect(request, request.getParameter("redirect"));

        if (!isSafeRedirect(redirect) && session != null) {
            redirect = normalizeRedirect(
                    request,
                    (String) session.getAttribute("redirectAfterLogin")
            );
        }

        return isSafeRedirect(redirect) ? redirect : "/home";
    }

    private boolean isSafeRedirect(String redirect) {
        if (redirect == null || redirect.trim().isEmpty()) {
            return false;
        }

        String value = redirect.trim();
        return value.startsWith("/")
                && !value.startsWith("//")
                && !value.contains("\\")
                && !value.toLowerCase().contains("%5c");
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private String valueOrEmpty(String value) {
        return value == null ? "" : value;
    }

    private void clearLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("user");
        }
    }

    private String normalizeRedirect(HttpServletRequest request, String redirect) {
        if (redirect == null) {
            return null;
        }

        String value = redirect.trim();
        if (value.isEmpty()) {
            return null;
        }

        String contextPath = request.getContextPath();
        if (!contextPath.isEmpty() && value.startsWith(contextPath + "/")) {
            return value.substring(contextPath.length());
        }

        return value;
    }

    private String normalizeRoleName(String roleName) {
        return roleName == null ? "" : roleName.trim().toLowerCase();
    }

    private boolean isTourGuide(User user, String roleName) {
        String compactRoleName = roleName.replace(" ", "").replace("-", "");

        if (!compactRoleName.isEmpty()) {
            return "tourguide".equals(compactRoleName)
                    || "guide".equals(compactRoleName);
        }

        return user.getRoleID() == 3;
    }

    private boolean isStaff(User user, String roleName) {
        if (!roleName.isEmpty()) {
            return "staff".equals(roleName);
        }

        return user.getRoleID() == 2;
    }

    private String readRememberedEmail(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return "";
        }

        for (Cookie cookie : cookies) {
            if (REMEMBER_EMAIL_COOKIE.equals(cookie.getName())) {
                try {
                    return URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8);
                } catch (IllegalArgumentException ignored) {
                    return "";
                }
            }
        }
        return "";
    }

    private void updateRememberEmailCookie(HttpServletRequest request,
                                           HttpServletResponse response,
                                           String email) {
        String value = email == null
                ? ""
                : URLEncoder.encode(email, StandardCharsets.UTF_8);
        Cookie cookie = new Cookie(REMEMBER_EMAIL_COOKIE, value);
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        cookie.setMaxAge(email == null ? 0 : REMEMBER_EMAIL_MAX_AGE);
        response.addCookie(cookie);
    }
}
