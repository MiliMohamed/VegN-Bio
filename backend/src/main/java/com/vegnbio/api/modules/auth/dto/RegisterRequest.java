package com.vegnbio.api.modules.auth.dto;

import com.vegnbio.api.modules.auth.entity.User;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record RegisterRequest(
    @NotBlank @Email String email,
    @NotBlank @Size(min = 6) String password,
    @NotBlank String fullName,
    @NotNull User.Role role
) {}
