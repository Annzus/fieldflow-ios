package app.fieldflow.backend.history;

import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "activity_histories")
public class ActivityHistoryEntity {
    @Id
    private UUID id;

    @Column(name = "work_item_id", nullable = false)
    private UUID workItemId;

    @Column(name = "actor_id", nullable = false)
    private UUID actorId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ActivityAction action;

    @Column(nullable = false)
    private String summary;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    protected ActivityHistoryEntity() {
    }

    public ActivityHistoryEntity(
        UUID id,
        UUID workItemId,
        UUID actorId,
        ActivityAction action,
        String summary,
        LocalDateTime createdAt
    ) {
        this.id = id;
        this.workItemId = workItemId;
        this.actorId = actorId;
        this.action = action;
        this.summary = summary;
        this.createdAt = createdAt;
    }

    public UUID getId() {
        return id;
    }

    public UUID getWorkItemId() {
        return workItemId;
    }

    public UUID getActorId() {
        return actorId;
    }

    public ActivityAction getAction() {
        return action;
    }

    public String getSummary() {
        return summary;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
}
