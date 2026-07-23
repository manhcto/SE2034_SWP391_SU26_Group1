package vn.edu.fpt.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/profile",
        "/edit-profile",
        "/delete-account",
        "/booking",
        "/booking-list",
        "/booking-edit",
        "/booking-summary",
        "/payment",
        "/payment/return",
        "/payment/cancel",
        "/booking/accommodation/form",
        "/booking/accommodation",
        "/feedback-list",
        "/feedback-detail",
        "/feedback-add",
        "/feedback-edit",
        "/my-vouchers",
        "/my-blogs",
        "/views/customer/*",
        "/views/edit-profile.jsp"
})
public class CustomerAuthenticationFilter extends AuthenticationFilterSupport implements Filter {
    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        User user = getCurrentUser(httpRequest);

        if (hasRole(user, 4, "Customer")) {
            chain.doFilter(request, response);
            return;
        }

        if (user == null) {
            redirectToLogin(httpRequest, httpResponse);
            return;
        }

        deny(httpResponse);
    }
}
