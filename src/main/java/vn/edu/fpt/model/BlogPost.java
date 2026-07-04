package vn.edu.fpt.model;

import java.sql.Timestamp;

public class BlogPost {
    private int blogID;
    private String title;
    private String slug;
    private String summary;
    private String content;
    private String thumbnailUrl;
    private String category;
    private String status;
    private Integer authorID;
    private String authorName;
    private Timestamp publishedAt;
    private Timestamp createAt;
    private Timestamp updateAt;

    public BlogPost() {
    }

    public BlogPost(int blogID, String title, String slug, String summary, String content,
                    String thumbnailUrl, String category, String status, Integer authorID,
                    Timestamp publishedAt, Timestamp createAt, Timestamp updateAt) {
        this.blogID = blogID;
        this.title = title;
        this.slug = slug;
        this.summary = summary;
        this.content = content;
        this.thumbnailUrl = thumbnailUrl;
        this.category = category;
        this.status = status;
        this.authorID = authorID;
        this.publishedAt = publishedAt;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }

    public int getBlogID() {
        return blogID;
    }

    public void setBlogID(int blogID) {
        this.blogID = blogID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getAuthorID() {
        return authorID;
    }

    public void setAuthorID(Integer authorID) {
        this.authorID = authorID;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public Timestamp getPublishedAt() {
        return publishedAt;
    }

    public void setPublishedAt(Timestamp publishedAt) {
        this.publishedAt = publishedAt;
    }

    public Timestamp getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Timestamp createAt) {
        this.createAt = createAt;
    }

    public Timestamp getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(Timestamp updateAt) {
        this.updateAt = updateAt;
    }
}
