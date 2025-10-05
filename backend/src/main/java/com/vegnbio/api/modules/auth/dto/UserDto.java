package com.vegnbio.api.modules.auth.dto;

import com.vegnbio.api.modules.auth.entity.User;

public record UserDto(
    Long id,
    String email,
    String fullName,
    User.Role role,
    String createdAt
) {}
