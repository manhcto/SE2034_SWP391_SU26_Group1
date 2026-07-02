package vn.edu.fpt.utils;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Set;
import java.util.UUID;

public final class FileUploadUtils {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of("jpg", "jpeg", "png", "webp");
    private static final long MAX_SIZE_BYTES = 5L * 1024 * 1024;
    private static final String TOUR_UPLOAD_DIR = "assets/uploads/tours";

    private FileUploadUtils() {
    }

    public static String saveTourImage(ServletContext servletContext, Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        if (part.getSize() > MAX_SIZE_BYTES) {
            throw new IOException("Ảnh không được vượt quá 5MB.");
        }

        String submittedFileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String extension = getExtension(submittedFileName).toLowerCase();

        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            throw new IOException("Ảnh chỉ được dùng định dạng JPG, JPEG, PNG hoặc WEBP.");
        }

        String realUploadPath = servletContext.getRealPath("/" + TOUR_UPLOAD_DIR);
        if (realUploadPath == null) {
            throw new IOException("Không xác định được thư mục upload. Hãy deploy project dạng exploded.");
        }

        File uploadFolder = new File(realUploadPath);
        if (!uploadFolder.exists() && !uploadFolder.mkdirs()) {
            throw new IOException("Không thể tạo thư mục upload ảnh.");
        }

        String storedName = "tour_" + UUID.randomUUID() + "." + extension;
        File targetFile = new File(uploadFolder, storedName);
        part.write(targetFile.getAbsolutePath());

        return TOUR_UPLOAD_DIR + "/" + storedName;
    }

    private static String getExtension(String fileName) {
        int index = fileName.lastIndexOf('.');
        return index >= 0 ? fileName.substring(index + 1) : "";
    }
}
