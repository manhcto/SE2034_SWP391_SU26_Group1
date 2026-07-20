package vn.edu.fpt.DAO;

import vn.edu.fpt.common.DBConnection;
import vn.edu.fpt.model.VatRate;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class VatRateDAO {
    private static final int FALLBACK_VAT = 8;

    public List<VatRate> getAllRates() {
        ensureVatTable();
        List<VatRate> rates = new ArrayList<>();
        String sql = """
                SELECT vr.*, LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))) AS createdByName
                FROM VAT_Rate vr
                LEFT JOIN [User] u ON u.userID = vr.createdByUserID
                ORDER BY vr.effectiveFrom DESC, vr.vatRateID DESC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rates.add(mapRate(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rates;
    }

    public List<VatRate> getActiveRates() {
        ensureVatTable();
        List<VatRate> rates = new ArrayList<>();
        String sql = """
                SELECT vr.*, LTRIM(RTRIM(ISNULL(u.firstName, N'') + N' ' + ISNULL(u.lastName, N''))) AS createdByName
                FROM VAT_Rate vr
                LEFT JOIN [User] u ON u.userID = vr.createdByUserID
                WHERE vr.[status] = N'Active'
                ORDER BY vr.effectiveFrom ASC, vr.vatRateID ASC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rates.add(mapRate(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rates;
    }

    public int getVatPercentForDate(LocalDate effectiveDate) {
        ensureVatTable();
        LocalDate safeDate = effectiveDate == null ? LocalDate.now() : effectiveDate;
        String sql = """
                SELECT TOP 1 vatPercent
                FROM VAT_Rate
                WHERE [status] = N'Active'
                  AND ? BETWEEN effectiveFrom AND effectiveTo
                ORDER BY effectiveFrom DESC, vatRateID DESC
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(safeDate));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("vatPercent");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return FALLBACK_VAT;
    }

    public boolean hasOverlap(LocalDate effectiveFrom, LocalDate effectiveTo) {
        ensureVatTable();
        String sql = """
                SELECT COUNT(*) AS total
                FROM VAT_Rate
                WHERE [status] = N'Active'
                  AND NOT (effectiveTo < ? OR effectiveFrom > ?)
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(effectiveFrom));
            ps.setDate(2, Date.valueOf(effectiveTo));
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt("total") > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return true;
    }

    public boolean insertRate(VatRate rate) {
        ensureVatTable();
        String sql = """
                INSERT INTO VAT_Rate (vatPercent, effectiveFrom, effectiveTo, legalDocument, [description], [status], createdByUserID)
                VALUES (?, ?, ?, ?, ?, N'Active', ?)
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rate.getVatPercent());
            ps.setDate(2, rate.getEffectiveFrom());
            ps.setDate(3, rate.getEffectiveTo());
            ps.setString(4, rate.getLegalDocument());
            ps.setString(5, rate.getDescription());
            if (rate.getCreatedByUserID() == null) {
                ps.setNull(6, java.sql.Types.INTEGER);
            } else {
                ps.setInt(6, rate.getCreatedByUserID());
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deactivateFutureRate(int vatRateID) {
        ensureVatTable();
        String sql = """
                UPDATE VAT_Rate
                SET [status] = N'Inactive', updatedAt = GETDATE()
                WHERE vatRateID = ?
                  AND [status] = N'Active'
                  AND effectiveFrom > CAST(GETDATE() AS date)
                """;

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vatRateID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void ensureVatTable() {
        String createSql = """
                IF OBJECT_ID(N'dbo.VAT_Rate', N'U') IS NULL
                BEGIN
                    CREATE TABLE dbo.VAT_Rate (
                        vatRateID INT IDENTITY(1,1) PRIMARY KEY,
                        vatPercent INT NOT NULL,
                        effectiveFrom DATE NOT NULL,
                        effectiveTo DATE NOT NULL,
                        legalDocument NVARCHAR(255) NOT NULL,
                        [description] NVARCHAR(1000) NULL,
                        [status] NVARCHAR(20) NOT NULL CONSTRAINT DF_VATRate_Status DEFAULT N'Active',
                        createdByUserID INT NULL,
                        createdAt DATETIME NOT NULL CONSTRAINT DF_VATRate_CreatedAt DEFAULT GETDATE(),
                        updatedAt DATETIME NULL,
                        CONSTRAINT CK_VATRate_Percent CHECK (vatPercent >= 0 AND vatPercent <= 10),
                        CONSTRAINT CK_VATRate_Date CHECK (effectiveTo >= effectiveFrom),
                        CONSTRAINT CK_VATRate_Status CHECK ([status] IN (N'Active', N'Inactive'))
                    )
                END
                """;

        String seedSql = """
                IF NOT EXISTS (SELECT 1 FROM dbo.VAT_Rate)
                BEGIN
                    INSERT INTO dbo.VAT_Rate (vatPercent, effectiveFrom, effectiveTo, legalDocument, [description], [status])
                    VALUES (8, '2025-07-01', '2026-12-31', N'Nghị quyết 204/2025/QH15 và Nghị định 174/2025/NĐ-CP', N'Bản ghi khởi tạo theo chính sách giảm VAT 2% cho nhóm dịch vụ đủ điều kiện trong giai đoạn 01-07-2025 đến 31-12-2026. Admin cần cập nhật theo văn bản pháp luật thực tế khi có thay đổi.', N'Active')
                END
                """;

        try (Connection conn = new DBConnection().getConnection();
             Statement st = conn.createStatement()) {
            st.execute(createSql);
            st.execute("""
                    IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_VATRate_Percent' AND parent_object_id = OBJECT_ID(N'dbo.VAT_Rate'))
                    BEGIN
                        ALTER TABLE dbo.VAT_Rate DROP CONSTRAINT CK_VATRate_Percent
                    END
                    ALTER TABLE dbo.VAT_Rate WITH CHECK ADD CONSTRAINT CK_VATRate_Percent CHECK (vatPercent >= 0 AND vatPercent <= 10)
                    """);
            st.execute("""
                    IF OBJECT_ID(N'dbo.TR_VATRate_NoDelete', N'TR') IS NULL
                    EXEC(N'
                        CREATE TRIGGER dbo.TR_VATRate_NoDelete
                        ON dbo.VAT_Rate
                        INSTEAD OF DELETE
                        AS
                        BEGIN
                            RAISERROR(N''Không được xóa lịch sử VAT.'', 16, 1);
                            ROLLBACK TRANSACTION;
                        END
                    ')
                    """);
            st.execute("""
                    IF OBJECT_ID(N'dbo.TR_VATRate_BlockCoreUpdate', N'TR') IS NULL
                    EXEC(N'
                        CREATE TRIGGER dbo.TR_VATRate_BlockCoreUpdate
                        ON dbo.VAT_Rate
                        AFTER UPDATE
                        AS
                        BEGIN
                            IF UPDATE(vatPercent) OR UPDATE(effectiveFrom) OR UPDATE(effectiveTo)
                               OR UPDATE(legalDocument) OR UPDATE(createdByUserID) OR UPDATE(createdAt)
                            BEGIN
                                RAISERROR(N''Không được sửa dữ liệu lõi của VAT. Hãy tạo kỳ VAT mới để thay đổi.'', 16, 1);
                                ROLLBACK TRANSACTION;
                            END
                        END
                    ')
                    """);
            st.execute(seedSql);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private VatRate mapRate(ResultSet rs) throws Exception {
        VatRate rate = new VatRate();
        rate.setVatRateID(rs.getInt("vatRateID"));
        rate.setVatPercent(rs.getInt("vatPercent"));
        rate.setEffectiveFrom(rs.getDate("effectiveFrom"));
        rate.setEffectiveTo(rs.getDate("effectiveTo"));
        rate.setLegalDocument(rs.getString("legalDocument"));
        rate.setDescription(rs.getString("description"));
        rate.setStatus(rs.getString("status"));
        int createdBy = rs.getInt("createdByUserID");
        rate.setCreatedByUserID(rs.wasNull() ? null : createdBy);
        rate.setCreatedByName(getOptionalString(rs, "createdByName"));
        Timestamp createdAt = rs.getTimestamp("createdAt");
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        rate.setCreatedAt(createdAt);
        rate.setUpdatedAt(updatedAt);
        return rate;
    }

    private String getOptionalString(ResultSet rs, String column) {
        try {
            return rs.getString(column);
        } catch (Exception e) {
            return "";
        }
    }
}
