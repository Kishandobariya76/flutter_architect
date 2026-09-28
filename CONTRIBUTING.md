# Contributing to Flutter Architect

Thank you for your interest in contributing to `flutter_architect`! This document provides guidelines and instructions for contributing to the project.

---

## Code of Conduct

We are committed to providing a friendly, safe, and welcoming environment for all contributors. Please treat everyone with respect and empathy.

---

## How Can I Contribute?

### 1. Reporting Bugs
- Check existing issues before opening a new one.
- Provide a clear, reproducible example.
- Include your operating system (`macOS`, `Windows`, `Linux`), Dart SDK version, and Flutter version (`flutter-architect doctor`).

### 2. Suggesting Features
- Open an issue describing the feature, the problem it solves, and how it aligns with Clean Architecture.
- Provide CLI syntax proposals where appropriate.

### 3. Adding New Commands
See [DEVELOPMENT.md](DEVELOPMENT.md) for detailed instructions on adding new commands, generators, and templates.

---

## Development Workflow

1. **Fork the repository** on GitHub.
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/<your-username>/flutter_architect.git
   cd flutter_architect
   ```
3. **Create a branch**:
   ```bash
   git checkout -b feature/my-new-command
   ```
4. **Install dependencies**:
   ```bash
   dart pub get
   ```
5. **Make your changes** following [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.
6. **Add automated tests** in the `test/` directory.
7. **Verify static analysis and formatting**:
   ```bash
   dart format .
   dart analyze
   dart test
   ```
8. **Commit your changes**:
   Use descriptive commit messages following the Conventional Commits specification:
   ```bash
   git commit -m "feat: add service generator command"
   ```
9. **Push to your fork and submit a Pull Request**:
   ```bash
   git push origin feature/my-new-command
   ```

---

## Pull Request Guidelines

- Ensure all existing tests pass.
- Write tests for new functionality.
- Update `CHANGELOG.md` with a summary of your changes under `[Unreleased]`.
- Update `README.md` if CLI flags or commands were altered or added.
- Maintain backwards compatibility where possible.
