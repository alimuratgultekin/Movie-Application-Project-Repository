# Authentication & User Access – Phase 2.2 / Phase 3 Preparation

This document outlines my responsibility and design considerations regarding authentication and user access for the MovieSU project.

## Authentication Responsibility
I am responsible for designing and planning the authentication flow of the application, ensuring that access is restricted to university students only.

## Student-Only Access (.edu Emails)
- Users are required to register using a valid `.edu` email address.
- Email format validation is handled on the client side during login and sign-up.
- This restriction ensures a secure and student-exclusive environment.

## Planned Authentication Flow
- User sign-up with email and password
- User login with credential validation
- Logout functionality
- Basic session handling (logged-in vs logged-out states)

## Firebase Authentication (Phase 3)
- Firebase Authentication will be used for secure user management.
- Email/password authentication method will be enabled.
- Authentication state will control access to protected screens.
- Unauthorized users will be redirected to the login screen.

Contributor: Melisa Yagmur Karakurt
