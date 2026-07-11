package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.BlogPost;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO {
    private static final String AUTHOR_NAME_SQL =
            "COALESCE(NULLIF(LTRIM(RTRIM(CONCAT(u.firstName, N' ', u.lastName))), N''), N'WonderVN Team') AS authorName";

    // Lấy danh sách bài viết đã publish cho trang khách với bộ lọc tìm kiếm và category.
    public List<BlogPost> getPublishedPosts(String searchKeyword, String category) {
        List<BlogPost> posts = new ArrayList<>();
        String search = trimValue(searchKeyword);
        String selectedCategory = trimValue(category);

        String sql = "SELECT p.*, " + AUTHOR_NAME_SQL + " " +
                "FROM Blog p " +
                "LEFT JOIN [User] u ON p.authorID = u.userID " +
                "WHERE p.[status] = N'Published' " +
                "AND (? = N'' OR p.title LIKE ? OR p.summary LIKE ? OR p.category LIKE ?) " +
                "AND (? = N'' OR p.category = ?) " +
                "ORDER BY p.publishedAt DESC, p.createAt DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String keywordPattern = "%" + search + "%";
            ps.setNString(1, search);
            ps.setNString(2, keywordPattern);
            ps.setNString(3, keywordPattern);
            ps.setNString(4, keywordPattern);
            ps.setNString(5, selectedCategory);
            ps.setNString(6, selectedCategory);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    posts.add(mapBlogPost(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }

    // Đếm số bài viết đã publish theo bộ lọc trang khách.
    public int countPublishedPosts(String searchKeyword, String category) {
        String search = trimValue(searchKeyword);
        String selectedCategory = trimValue(category);
        String sql = "SELECT COUNT(*) " +
                "FROM Blog " +
                "WHERE [status] = N'Published' " +
                "AND (? = N'' OR title LIKE ? OR summary LIKE ? OR category LIKE ?) " +
                "AND (? = N'' OR category = ?)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String keywordPattern = "%" + search + "%";
            ps.setNString(1, search);
            ps.setNString(2, keywordPattern);
            ps.setNString(3, keywordPattern);
            ps.setNString(4, keywordPattern);
            ps.setNString(5, selectedCategory);
            ps.setNString(6, selectedCategory);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy chi tiết một bài viết đã publish theo blogID.
    public BlogPost getPublishedPostById(int blogID) {
        String sql = "SELECT p.*, " + AUTHOR_NAME_SQL + " " +
                "FROM Blog p " +
                "LEFT JOIN [User] u ON p.authorID = u.userID " +
                "WHERE p.blogID = ? AND p.[status] = N'Published'";
        return getSinglePost(sql, blogID);
    }

    // Lấy chi tiết một bài viết đã publish theo slug.
    public BlogPost getPublishedPostBySlug(String slug) {
        String sql = "SELECT p.*, " + AUTHOR_NAME_SQL + " " +
                "FROM Blog p " +
                "LEFT JOIN [User] u ON p.authorID = u.userID " +
                "WHERE p.slug = ? AND p.[status] = N'Published'";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBlogPost(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy các bài viết liên quan cùng category và loại trừ bài hiện tại.
    public List<BlogPost> getRelatedPublishedPosts(String category, int excludeBlogID, int limit) {
        List<BlogPost> posts = new ArrayList<>();
        String selectedCategory = trimValue(category);
        String sql = "SELECT TOP (?) p.*, " + AUTHOR_NAME_SQL + " " +
                "FROM Blog p " +
                "LEFT JOIN [User] u ON p.authorID = u.userID " +
                "WHERE p.[status] = N'Published' " +
                "AND p.blogID <> ? " +
                "AND (? = N'' OR p.category = ?) " +
                "ORDER BY p.publishedAt DESC, p.createAt DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Math.max(limit, 1));
            ps.setInt(2, excludeBlogID);
            ps.setNString(3, selectedCategory);
            ps.setNString(4, selectedCategory);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    posts.add(mapBlogPost(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }

    // Lấy danh sách category đang có trên các bài viết đã publish.
    public List<String> getPublishedCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM Blog " +
                "WHERE [status] = N'Published' AND category IS NOT NULL AND LTRIM(RTRIM(category)) <> N'' " +
                "ORDER BY category";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getNString("category"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    // Lấy toàn bộ bài viết cho staff không áp bộ lọc.
    public List<BlogPost> getAllPostsForStaff() {
        return getPostsForStaff("", "", "");
    }

    // Lấy danh sách bài viết cho staff theo từ khóa và category.
    public List<BlogPost> getPostsForStaff(String searchKeyword, String category) {
        return getPostsForStaff(searchKeyword, category, "");
    }

    // Lấy danh sách bài viết cho staff theo từ khóa, category và trạng thái.
    public List<BlogPost> getPostsForStaff(String searchKeyword, String category, String status) {
        List<BlogPost> posts = new ArrayList<>();
        String search = trimValue(searchKeyword);
        String selectedCategory = trimValue(category);
        String selectedStatus = trimValue(status);
        String sql = "SELECT p.*, " + AUTHOR_NAME_SQL + " " +
                "FROM Blog p " +
                "LEFT JOIN [User] u ON p.authorID = u.userID " +
                "WHERE (? = N'' OR p.title LIKE ?) " +
                "AND (? = N'' OR p.category = ?) " +
                "AND (? = N'' OR p.[status] = ?) " +
                "ORDER BY p.createAt DESC, p.blogID DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String keywordPattern = "%" + search + "%";
            ps.setNString(1, search);
            ps.setNString(2, keywordPattern);
            ps.setNString(3, selectedCategory);
            ps.setNString(4, selectedCategory);
            ps.setNString(5, selectedStatus);
            ps.setNString(6, selectedStatus);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    posts.add(mapBlogPost(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }

    // Lấy toàn bộ category để staff dùng khi lọc hoặc nhập bài viết.
    public List<String> getStaffCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM Blog " +
                "WHERE category IS NOT NULL AND LTRIM(RTRIM(category)) <> N'' " +
                "ORDER BY category";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(rs.getNString("category"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    // Lấy chi tiết bài viết bất kể trạng thái theo blogID.
    public BlogPost getPostById(int blogID) {
        String sql = "SELECT p.*, " + AUTHOR_NAME_SQL + " " +
                "FROM Blog p " +
                "LEFT JOIN [User] u ON p.authorID = u.userID " +
                "WHERE p.blogID = ?";
        return getSinglePost(sql, blogID);
    }

    // Thêm mới một bài viết blog.
    public boolean insertPost(BlogPost post) {
        String sql = "INSERT INTO Blog " +
                "(title, slug, summary, content, image, category, [status], authorID, publishedAt) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CASE WHEN ? = N'Published' THEN GETDATE() ELSE NULL END)";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            fillPostStatement(ps, post);
            ps.setNString(9, post.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật nội dung và trạng thái của một bài viết.
    public boolean updatePost(BlogPost post) {
        String sql = "UPDATE Blog SET " +
                "title = ?, slug = ?, summary = ?, content = ?, image = ?, category = ?, [status] = ?, " +
                "authorID = COALESCE(?, authorID), " +
                "publishedAt = CASE " +
                "WHEN ? = N'Published' AND publishedAt IS NULL THEN GETDATE() " +
                "WHEN ? = N'Published' THEN publishedAt " +
                "ELSE NULL END, " +
                "updateAt = GETDATE() " +
                "WHERE blogID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            fillPostStatement(ps, post);
            ps.setNString(9, post.getStatus());
            ps.setNString(10, post.getStatus());
            ps.setInt(11, post.getBlogID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật riêng trạng thái publish/draft của bài viết.
    public boolean updatePostStatus(int blogID, String status) {
        String sql = "UPDATE Blog SET " +
                "[status] = ?, " +
                "publishedAt = CASE " +
                "WHEN ? = N'Published' AND publishedAt IS NULL THEN GETDATE() " +
                "WHEN ? = N'Published' THEN publishedAt " +
                "ELSE NULL END, " +
                "updateAt = GETDATE() " +
                "WHERE blogID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, status);
            ps.setNString(2, status);
            ps.setNString(3, status);
            ps.setInt(4, blogID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa hẳn một bài viết khỏi bảng Blog.
    public boolean deletePost(int blogID) {
        String sql = "DELETE FROM Blog WHERE blogID = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tạo slug duy nhất từ slug gốc và tự tăng hậu tố nếu bị trùng.
    public String createUniqueSlug(String baseSlug, int excludeBlogID) {
        String cleanSlug = trimValue(baseSlug);
        if (cleanSlug.isEmpty()) {
            cleanSlug = "blog-post";
        }

        String candidate = cleanSlug;
        int suffix = 2;
        while (slugExists(candidate, excludeBlogID)) {
            candidate = cleanSlug + "-" + suffix;
            suffix++;
        }
        return candidate;
    }

    // Chạy query lấy một bài viết theo blogID.
    private BlogPost getSinglePost(String sql, int blogID) {
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBlogPost(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Kiểm tra slug đã tồn tại ở bài viết khác hay chưa.
    private boolean slugExists(String slug, int excludeBlogID) {
        String sql = "SELECT COUNT(*) FROM Blog WHERE slug = ? AND blogID <> ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, slug);
            ps.setInt(2, excludeBlogID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Gán dữ liệu của BlogPost vào PreparedStatement cho insert/update.
    private void fillPostStatement(PreparedStatement ps, BlogPost post) throws Exception {
        ps.setNString(1, post.getTitle());
        ps.setString(2, post.getSlug());
        setNullableNString(ps, 3, post.getSummary());
        ps.setNString(4, post.getContent());
        setNullableNString(ps, 5, post.getImage());
        setNullableNString(ps, 6, post.getCategory());
        ps.setNString(7, post.getStatus());
        if (post.getAuthorID() == null) {
            ps.setNull(8, Types.INTEGER);
        } else {
            ps.setInt(8, post.getAuthorID());
        }
    }

    // Gán chuỗi NVARCHAR, nếu rỗng thì set NULL.
    private void setNullableNString(PreparedStatement ps, int index, String value) throws Exception {
        if (value == null || value.trim().isEmpty()) {
            ps.setNull(index, Types.NVARCHAR);
        } else {
            ps.setNString(index, value.trim());
        }
    }

    // Map một dòng ResultSet thành đối tượng BlogPost.
    private BlogPost mapBlogPost(ResultSet rs) throws Exception {
        BlogPost post = new BlogPost();
        post.setBlogID(rs.getInt("blogID"));
        post.setTitle(rs.getNString("title"));
        post.setSlug(rs.getString("slug"));
        post.setSummary(rs.getNString("summary"));
        post.setContent(rs.getNString("content"));
        post.setImage(rs.getNString("image"));
        post.setCategory(rs.getNString("category"));
        post.setStatus(rs.getNString("status"));

        int authorID = rs.getInt("authorID");
        post.setAuthorID(rs.wasNull() ? null : authorID);
        post.setAuthorName(rs.getNString("authorName"));
        post.setPublishedAt(rs.getTimestamp("publishedAt"));
        post.setCreateAt(rs.getTimestamp("createAt"));
        post.setUpdateAt(rs.getTimestamp("updateAt"));
        return post;
    }

    // Cắt khoảng trắng đầu cuối, null thì đổi thành chuỗi rỗng.
    private String trimValue(String value) {
        return value == null ? "" : value.trim();
    }
}
