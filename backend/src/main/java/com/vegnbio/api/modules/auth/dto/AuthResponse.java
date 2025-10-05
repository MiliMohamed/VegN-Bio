package com.vegnbio.api.modules.auth.dto;

import com.vegnbio.api.modules.auth.entity.User;

public record AuthResponse(
    String accessToken,
    Long expiresIn,
    User.Role role,
    String fullName
) {}
