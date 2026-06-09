package app.fieldflow.backend.history;

import java.util.List;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ActivityHistoryRepository extends JpaRepository<ActivityHistoryEntity, UUID> {
    List<ActivityHistoryEntity> findByWorkItemIdOrderByCreatedAtDesc(UUID workItemId);
}
