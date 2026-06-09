package app.fieldflow.backend.workitem;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum WorkItemStatus {
    PENDING("pending"),
    IN_PROGRESS("inProgress"),
    COMPLETED("completed"),
    ON_HOLD("onHold");

    private final String value;

    WorkItemStatus(String value) {
        this.value = value;
    }

    @JsonValue
    public String value() {
        return value;
    }

    @JsonCreator
    public static WorkItemStatus fromValue(String value) {
        for (WorkItemStatus status : values()) {
            if (status.value.equals(value)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown WorkItemStatus: " + value);
    }
}
