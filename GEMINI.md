# Gemini Code Assistant Context

## Project Overview

This project, "try", is a command-line utility written in Ruby for managing and navigating experimental project directories. It provides an interactive, fuzzy-searchable terminal user interface (TUI) to quickly find existing "try" directories or create new ones. New directories are automatically prefixed with the current date (e.g., `2025-08-21-my-new-idea`).

The core logic is self-contained in a single Ruby script, `try.rb`, which has no external gem dependencies. The project also includes a `flake.nix` file, indicating that it is packaged and managed using the Nix package manager, with support for Home Manager for easy integration into a user's environment.

## Key Files

*   `try.rb`: The main and only Ruby source file. It contains all the logic for the TUI, fuzzy search, and directory management.
*   `flake.nix`: The Nix flake that defines the project's dependencies (just Ruby), how to build it, and provides a Home Manager module for easy installation and configuration.
*   `README.md`: The project's documentation, explaining its purpose, features, and how to use it.

## Building and Running

The intended use of this tool is not to be run directly, but to be integrated into the user's shell.

### With Nix

The easiest way to use `try` is with Nix:

*   **Run ad-hoc:**
    ```bash
    nix run github:tobi/try
    ```
*   **With Home Manager:**
    Add the flake to your `home-manager` configuration to make the `try` command available in your shell.

### Manually

1.  **Source the script in your shell's configuration file** (e.g., `~/.bashrc`, `~/.zshrc`):
    ```bash
    eval "$(./try.rb init ~/path/to/your/tries)"
    ```
2.  **Run the `try` command:**
    ```bash
    try <search-term>
    ```

## Development Conventions

*   **Language:** Ruby (no external gems).
*   **Packaging:** Nix flakes are used for packaging and dependency management.
*   **Style:** The Ruby code is self-contained in a single file. It includes a hand-rolled TUI using ANSI escape codes.
*   **Testing:** There are no automated tests in the project.
