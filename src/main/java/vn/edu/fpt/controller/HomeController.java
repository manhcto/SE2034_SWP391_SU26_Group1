package vn.edu.fpt.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final TourDAO tourDAO = new TourDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        List<Tour> featuredTours = tourDAO.getFeaturedToursForHome(4);
        List<Tour> packageTours = tourDAO.getPublishedToursForCustomer(null, null, null, null, null, null, 10);

        request.setAttribute("featuredTours", featuredTours);
        request.setAttribute("packageTours", packageTours);
        request.setAttribute("northTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Bắc", 3));
        request.setAttribute("centralTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Trung", 3));
        request.setAttribute("southTours", tourDAO.getPublishedToursForHomeByRegionName("Miền Nam", 3));
        request.setAttribute("startPlaces", tourDAO.getPublishedStartPlaces());
        request.setAttribute("destinations", tourDAO.getPublishedDestinations());

        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}
