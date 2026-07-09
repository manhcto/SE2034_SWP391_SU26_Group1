package vn.edu.fpt.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebFilter("/guide/*")
public class GuideAuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        Object user = session == null ? null : session.getAttribute("user");

        if (user instanceof User currentUser && isTourGuide(currentUser)) {
            chain.doFilter(request, response);
            return;
        }

        if (user == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN);
    }

    private boolean isTourGuide(User user) {
        String roleName = user.getRoleName();

        if (roleName != null) {
            String normalizedRoleName = roleName.trim().toLowerCase();
            if ("tour guide".equals(normalizedRoleName)
                    || "tourguide".equals(normalizedRoleName)
                    || "tour-guide".equals(normalizedRoleName)
                    || "guide".equals(normalizedRoleName)) {
                return true;
            }
        }

        return user.getRoleID() == 3;
    }
}
