package app.fieldflow.backend.workitem;

import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WorkItemRepository extends JpaRepository<WorkItemEntity, UUID> {
}
