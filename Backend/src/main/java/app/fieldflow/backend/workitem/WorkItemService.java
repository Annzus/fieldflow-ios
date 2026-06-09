package app.fieldflow.backend.workitem;

import app.fieldflow.backend.history.ActivityAction;
import app.fieldflow.backend.history.ActivityHistoryEntity;
import app.fieldflow.backend.history.ActivityHistoryRepository;
import app.fieldflow.backend.workitem.WorkItemDtos.CreateWorkItemRequest;
import app.fieldflow.backend.workitem.WorkItemDtos.UpdateWorkItemRequest;
import java.time.LocalDateTime;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
class WorkItemService {
    static final UUID DEMO_USER_ID = UUID.fromString("aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa");

    private final WorkItemRepository workItemRepository;
    private final ActivityHistoryRepository historyRepository;

    WorkItemService(
        WorkItemRepository workItemRepository,
        ActivityHistoryRepository historyRepository
    ) {
        this.workItemRepository = workItemRepository;
        this.historyRepository = historyRepository;
    }

    @Transactional
    WorkItemEntity create(CreateWorkItemRequest request) {
        LocalDateTime now = LocalDateTime.now();
        WorkItemEntity item = new WorkItemEntity(
            UUID.randomUUID(),
            request.title().trim(),
            request.detail().trim(),
            WorkItemStatus.PENDING,
            request.priority(),
            request.assigneeId(),
            DEMO_USER_ID,
            1,
            now,
            now
        );

        WorkItemEntity saved = workItemRepository.save(item);
        historyRepository.save(new ActivityHistoryEntity(
            UUID.randomUUID(),
            saved.getId(),
            DEMO_USER_ID,
            ActivityAction.CREATED,
            "WorkItemを作成しました",
            now
        ));

        return saved;
    }

    @Transactional
    WorkItemEntity update(UUID id, UpdateWorkItemRequest request) {
        WorkItemEntity item = workItemRepository.findById(id)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        if (item.getVersion() != request.baseVersion()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "baseVersion does not match current version");
        }

        WorkItemEntity old = new WorkItemEntity(
            item.getId(),
            item.getTitle(),
            item.getDetail(),
            item.getStatus(),
            item.getPriority(),
            item.getAssigneeId(),
            item.getCreatedBy(),
            item.getVersion(),
            item.getCreatedAt(),
            item.getUpdatedAt()
        );

        LocalDateTime now = LocalDateTime.now();
        item.update(
            request.title().trim(),
            request.detail().trim(),
            request.status(),
            request.priority(),
            request.assigneeId(),
            now
        );

        insertHistories(old, item, now);
        return item;
    }

    private void insertHistories(WorkItemEntity old, WorkItemEntity updated, LocalDateTime createdAt) {
        if (!old.getTitle().equals(updated.getTitle())) {
            insertHistory(updated.getId(), ActivityAction.TITLE_UPDATED, "タイトルを更新しました", createdAt);
        }
        if (!old.getDetail().equals(updated.getDetail())) {
            insertHistory(updated.getId(), ActivityAction.DETAIL_UPDATED, "説明を更新しました", createdAt);
        }
        if (old.getStatus() != updated.getStatus()) {
            insertHistory(updated.getId(), ActivityAction.STATUS_UPDATED, "ステータスを更新しました", createdAt);
        }
        if (old.getPriority() != updated.getPriority()) {
            insertHistory(updated.getId(), ActivityAction.PRIORITY_UPDATED, "優先度を更新しました", createdAt);
        }
        if (!java.util.Objects.equals(old.getAssigneeId(), updated.getAssigneeId())) {
            insertHistory(updated.getId(), ActivityAction.ASSIGNEE_UPDATED, "担当者を更新しました", createdAt);
        }
    }

    private void insertHistory(UUID workItemId, ActivityAction action, String summary, LocalDateTime createdAt) {
        historyRepository.save(new ActivityHistoryEntity(
            UUID.randomUUID(),
            workItemId,
            DEMO_USER_ID,
            action,
            summary,
            createdAt
        ));
    }
}
