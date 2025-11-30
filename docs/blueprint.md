# Project Blueprint

## Overview

This document outlines the design, features, and implementation of a password generator application. The application provides a simple and intuitive interface for generating, copying, and managing passwords. It is designed to be responsive, accessible, and easily extensible.

## Style and Design

- **Theme:** The application uses a Material 3 theme with a teal-based color scheme. It supports both light and dark modes, and the theme can be manually selected by the user or set to follow the system theme.
- **Layout:** The application features a clean and modern single-column layout. On larger screens, the theme selection options are displayed as a row of icon buttons, while on smaller screens, they are consolidated into a pop-up menu.
- **Typography:** The application uses the default Material Design typography.
- **Iconography:** The application uses standard Material Design icons for all interactive elements.

## Features

- **Password Generation:** The application generates a random password and displays it in a read-only text field.
- **Password Copy:** Users can copy the generated password to the clipboard with a single tap.
- **Password Refresh:** Users can generate a new password by tapping the refresh icon.
- **Internationalization:** The application supports both English and Japanese languages. The default language is set to Japanese, and users can switch between languages using a dedicated menu.
- **Theme Selection:** Users can switch between light, dark, and system theme modes.
- **Responsive Design:** The application's layout adapts to different screen sizes, providing an optimal user experience on both mobile and desktop devices.
- **Footer:** The application includes a professional footer with a copyright notice.

## Implementation Plan

### Current Task: Add Language Selection and Footer

- **Change Default Locale:** Modify the `localeProvider` to set the default locale to Japanese (`ja`).
- **Combine Menus:**
    - **Mobile:** Create a single, combined pop-up menu that includes options for both language and theme.
    - **Desktop:** Display a dedicated language selection menu alongside the existing row of theme selection buttons.
- **Add Footer:** Add a `Spacer` and a `Padding` widget to the body of the `Scaffold` to create a professional footer with a copyright notice.
