package app.fieldflow.backend;

import static org.hamcrest.Matchers.greaterThan;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import app.fieldflow.backend.auth.SecurityConfig;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class FieldFlowBackendApplicationTests {
    private static final String AUTH_HEADER = "Bearer " + SecurityConfig.DEMO_TOKEN;

    @Autowired
    private MockMvc mockMvc;

    @Test
    void loginReturnsDemoToken() throws Exception {
        mockMvc.perform(post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "email": "demo@fieldflow.app",
                      "password": "password"
                    }
                    """))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.accessToken").value(SecurityConfig.DEMO_TOKEN))
            .andExpect(jsonPath("$.tokenType").value("Bearer"));
    }

    @Test
    void protectedEndpointRequiresToken() throws Exception {
        mockMvc.perform(get("/api/work-items"))
            .andExpect(status().isForbidden());
    }

    @Test
    void listWorkItemsReturnsSeedData() throws Exception {
        mockMvc.perform(get("/api/work-items")
                .header(HttpHeaders.AUTHORIZATION, AUTH_HEADER))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$", hasSize(greaterThan(0))))
            .andExpect(jsonPath("$[0].title").exists());
    }

    @Test
    void createWorkItemReturnsCreatedItem() throws Exception {
        mockMvc.perform(post("/api/work-items")
                .header(HttpHeaders.AUTHORIZATION, AUTH_HEADER)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "title": "現地確認",
                      "detail": "端末状態を確認する",
                      "priority": "high",
                      "assigneeId": "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
                    }
                    """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.title").value("現地確認"))
            .andExpect(jsonPath("$.status").value("pending"))
            .andExpect(jsonPath("$.version").value(1));
    }

    @Test
    void updateWorkItemDetectsVersionConflict() throws Exception {
        mockMvc.perform(put("/api/work-items/11111111-1111-1111-1111-111111111111")
                .header(HttpHeaders.AUTHORIZATION, AUTH_HEADER)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                    {
                      "title": "配送遅延の確認",
                      "detail": "顧客から配送予定時刻の問い合わせ。物流チームへ状況確認が必要。",
                      "status": "completed",
                      "priority": "high",
                      "assigneeId": "cccccccc-cccc-cccc-cccc-cccccccccccc",
                      "baseVersion": 999
                    }
                    """))
            .andExpect(status().isConflict());
    }

    @Test
    void historyReturnsWorkItemActivities() throws Exception {
        mockMvc.perform(get("/api/work-items/11111111-1111-1111-1111-111111111111/history")
                .header(HttpHeaders.AUTHORIZATION, AUTH_HEADER))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$", hasSize(greaterThan(0))))
            .andExpect(jsonPath("$[0].summary").exists());
    }
}
