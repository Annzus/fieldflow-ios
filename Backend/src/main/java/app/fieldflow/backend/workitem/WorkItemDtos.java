package app.fieldflow.backend.workitem;

import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public final class WorkItemDtos {
    private WorkItemDtos() {
    }

    public record WorkItemResponse(
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
        public static WorkItemResponse from(WorkItemEntity entity) {
            return new WorkItemResponse(
                entity.getId(),
                entity.getTitle(),
                entity.getDetail(),
                entity.getStatus(),
                entity.getPriority(),
                entity.getAssigneeId(),
                entity.getCreatedBy(),
                entity.getVersion(),
                entity.getCreatedAt(),
                entity.getUpdatedAt()
            );
        }
    }

    public record CreateWorkItemRequest(
        @NotBlank String title,
        @NotBlank String detail,
        @NotNull WorkItemPriority priority,
        UUID assigneeId
    ) {
    }

    public record UpdateWorkItemRequest(
        @NotBlank String title,
        @NotBlank String detail,
        @NotNull WorkItemStatus status,
        @NotNull WorkItemPriority priority,
        UUID assigneeId,
        int baseVersion
    ) {
    }
}
