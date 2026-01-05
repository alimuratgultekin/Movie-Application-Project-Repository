# Authentication Flow – MovieSU

This document describes the planned authentication flow for the MovieSU application.

## Login Flow
1. User opens the application
2. User is redirected to the login screen if not authenticated
3. User enters email and password
4. Client-side validation checks:
   - Email format
   - `.edu` domain requirement
5. Credentials are sent for authentication
6. On success, user is redirected to the home screen

## Sign-Up Flow
1. User selects the sign-up option
2. User provides full name, email and password
3. Email must end with `.edu`
4. Password requirements are validated
5. Account is created
6. User is redirected to the home page screen

## Session Handling
- Authentication state determines accessible screens
- Unauthenticated users cannot access protected routes
- Logout clears the authentication session

Author: Melisa Yagmur Karakurt, Alper Canitez
