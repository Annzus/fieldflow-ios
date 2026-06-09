package app.fieldflow.backend.history;

import java.time.LocalDateTime;
import java.util.UUID;

public record ActivityHistoryResponse(
    UUID id,
    UUID workItemId,
    UUID actorId,
    ActivityAction action,
    String summary,
    LocalDateTime createdAt
) {
    public static ActivityHistoryResponse from(ActivityHistoryEntity entity) {
        return new ActivityHistoryResponse(
            entity.getId(),
            entity.getWorkItemId(),
            entity.getActorId(),
            entity.getAction(),
            entity.getSummary(),
            entity.getCreatedAt()
        );
    }
}
