package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.common.TourImageStorage;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@WebServlet(name = "TourImageController", urlPatterns = {"/tour-image/*"})
public class TourImageController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String fileName = pathInfo == null ? "" : pathInfo.replaceFirst("^/+", "");
        Path imagePath = TourImageStorage.resolve(fileName);

        if (imagePath == null || !Files.isRegularFile(imagePath)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType = getServletContext().getMimeType(imagePath.getFileName().toString());
        response.setContentType(contentType == null ? "application/octet-stream" : contentType);
        response.setHeader("Cache-Control", "public, max-age=604800");
        Files.copy(imagePath, response.getOutputStream());
    }
}
