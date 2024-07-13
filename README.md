# Notes App

A feature-rich Flutter application for managing and organizing your tasks and notes.

![Presentaion](/screenshots/cover.png?raw=true)

## Features

- Create, edit, and delete tasks/notes
- Rich text editing with AppFlowy Editor
- Redux state management for efficient data handling
- Customizable task widgets
- User-friendly interface

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/yourusername/notes_app.git
   ```

2. Navigate to the project directory:

   ```
   cd notes_app
   ```

3. Install dependencies:

   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/`: Contains the main source code
  - `model/`: Data models
  - `pages/`: Screen layouts
  - `utils/`: Utility functions and Redux setup
  - `widget/`: Reusable UI components

## Dependencies

- [redux](https://pub.dev/packages/redux) & [flutter_redux](https://pub.dev/packages/flutter_redux) : State management
- [sqflite](https://pub.dev/packages/sqflite): Local Database
- [appflowy_editor](https://pub.dev/packages/appflowy_editor): Rich text editing
- [table_calendar](https://pub.dev/packages/table_calendar): Calendar widget
- [toastification](https://pub.dev/packages/toastification): Toast notifications

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
