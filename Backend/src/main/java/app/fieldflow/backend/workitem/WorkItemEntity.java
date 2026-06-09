package app.fieldflow.backend.workitem;

import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "work_items")
public class WorkItemEntity {
    @Id
    private UUID id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String detail;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private WorkItemStatus status;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private WorkItemPriority priority;

    @Column(name = "assignee_id")
    private UUID assigneeId;

    @Column(name = "created_by", nullable = false)
    private UUID createdBy;

    @Column(nullable = false)
    private int version;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    protected WorkItemEntity() {
    }

    public WorkItemEntity(
        UUID id,
        String title,
        String detail,
        WorkItemStatus status,
        WorkItemPriority priority,
        UUID assigneeId,
        UUID createdBy,
        int version,
        LocalDateTime createdAt,
        LocalDateTime updatedAt
    ) {
        this.id = id;
        this.title = title;
        this.detail = detail;
        this.status = status;
        this.priority = priority;
        this.assigneeId = assigneeId;
        this.createdBy = createdBy;
        this.version = version;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public UUID getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDetail() {
        return detail;
    }

    public WorkItemStatus getStatus() {
        return status;
    }

    public WorkItemPriority getPriority() {
        return priority;
    }

    public UUID getAssigneeId() {
        return assigneeId;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public int getVersion() {
        return version;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void update(
        String title,
        String detail,
        WorkItemStatus status,
        WorkItemPriority priority,
        UUID assigneeId,
        LocalDateTime updatedAt
    ) {
        this.title = title;
        this.detail = detail;
        this.status = status;
        this.priority = priority;
        this.assigneeId = assigneeId;
        this.updatedAt = updatedAt;
        this.version += 1;
    }
}
