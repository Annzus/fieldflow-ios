package app.fieldflow.backend.workitem;

import app.fieldflow.backend.history.ActivityHistoryRepository;
import app.fieldflow.backend.history.ActivityHistoryResponse;
import app.fieldflow.backend.workitem.WorkItemDtos.CreateWorkItemRequest;
import app.fieldflow.backend.workitem.WorkItemDtos.UpdateWorkItemRequest;
import app.fieldflow.backend.workitem.WorkItemDtos.WorkItemResponse;
import jakarta.validation.Valid;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/work-items")
class WorkItemController {
    private final WorkItemRepository workItemRepository;
    private final ActivityHistoryRepository historyRepository;
    private final WorkItemService workItemService;

    WorkItemController(
        WorkItemRepository workItemRepository,
        ActivityHistoryRepository historyRepository,
        WorkItemService workItemService
    ) {
        this.workItemRepository = workItemRepository;
        this.historyRepository = historyRepository;
        this.workItemService = workItemService;
    }

    @GetMapping
    List<WorkItemResponse> list() {
        return workItemRepository.findAll().stream()
            .sorted(Comparator.comparing(WorkItemEntity::getUpdatedAt).reversed())
            .map(WorkItemResponse::from)
            .toList();
    }

    @GetMapping("/{id}")
    WorkItemResponse detail(@PathVariable UUID id) {
        return workItemRepository.findById(id)
            .map(WorkItemResponse::from)
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    WorkItemResponse create(@Valid @RequestBody CreateWorkItemRequest request) {
        return WorkItemResponse.from(workItemService.create(request));
    }

    @PutMapping("/{id}")
    WorkItemResponse update(
        @PathVariable UUID id,
        @Valid @RequestBody UpdateWorkItemRequest request
    ) {
        return WorkItemResponse.from(workItemService.update(id, request));
    }

    @GetMapping("/{id}/history")
    List<ActivityHistoryResponse> history(@PathVariable UUID id) {
        if (!workItemRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }

        return historyRepository.findByWorkItemIdOrderByCreatedAtDesc(id).stream()
            .map(ActivityHistoryResponse::from)
            .toList();
    }
}
