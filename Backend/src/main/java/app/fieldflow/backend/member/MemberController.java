package app.fieldflow.backend.member;

import app.fieldflow.backend.auth.UserEntity;
import app.fieldflow.backend.auth.UserRepository;
import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/members")
class MemberController {
    private final UserRepository userRepository;

    MemberController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @GetMapping
    List<MemberResponse> members() {
        return userRepository.findAll().stream()
            .map(MemberResponse::from)
            .toList();
    }

    record MemberResponse(
        UUID id,
        String name,
        String role
    ) {
        static MemberResponse from(UserEntity user) {
            return new MemberResponse(
                user.getId(),
                user.getName(),
                user.getRole().name().toLowerCase()
            );
        }
    }
}
