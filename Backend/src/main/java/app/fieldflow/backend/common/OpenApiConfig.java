package app.fieldflow.backend.common;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {
    @Bean
    OpenAPI fieldFlowOpenApi() {
        return new OpenAPI()
            .info(new Info()
                .title("FieldFlow API")
                .version("0.1.0")
                .description("Backend API for the FieldFlow portfolio app."));
    }
}
