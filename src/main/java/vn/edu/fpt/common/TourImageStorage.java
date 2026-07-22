package vn.edu.fpt.common;

import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Set;

public final class TourImageStorage {

    public static final String PUBLIC_PATH_PREFIX = "tour-image/";

    private static final Set<String> ALLOWED_CONTENT_TYPES = Set.of(
            "image/jpeg",
            "image/png",
            "image/webp",
            "image/gif"
    );

    private TourImageStorage() {
    }

    public static boolean isAllowedContentType(String contentType) {
        return contentType != null && ALLOWED_CONTENT_TYPES.contains(contentType.toLowerCase());
    }

    public static String save(Part part, String fileName) throws IOException {
        Path uploadDir = getUploadDir();
        Files.createDirectories(uploadDir);

        String safeFileName = Path.of(fileName).getFileName().toString();
        Path target = uploadDir.resolve(safeFileName).normalize();
        if (!target.startsWith(uploadDir)) {
            throw new IOException("Invalid upload target.");
        }

        try (InputStream input = part.getInputStream()) {
            Files.copy(input, target);
        }

        return PUBLIC_PATH_PREFIX + safeFileName;
    }

    public static Path resolve(String requestedName) {
        if (requestedName == null || requestedName.trim().isEmpty()) {
            return null;
        }

        String safeFileName = Path.of(requestedName).getFileName().toString();
        Path uploadDir = getUploadDir();
        Path target = uploadDir.resolve(safeFileName).normalize();
        return target.startsWith(uploadDir) ? target : null;
    }

    private static Path getUploadDir() {
        String configured = System.getProperty("wondervn.upload.dir");
        if (configured == null || configured.trim().isEmpty()) {
            configured = System.getenv("WONDERVN_UPLOAD_DIR");
        }
        if (configured != null && !configured.trim().isEmpty()) {
            return Path.of(configured.trim(), "tours").toAbsolutePath().normalize();
        }
        return Path.of(System.getProperty("user.home"), ".wondervn", "uploads", "tours")
                .toAbsolutePath()
                .normalize();
    }
}
