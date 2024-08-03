# Social

**Social** is a social media application built with Flutter that allows users to sign up, sign in, reset their passwords, and post content. The application uses Firebase for authentication and Firestore for storing posts and user data.

## Features

- **Sign Up:** Users can create an account using their email and password.
- **Sign In:** Users can sign in to their account using their email and password.
- **Reset Password:** Users can reset their password if they forget it.
- **Post Content:** Users can upload posts with a title and content.
- **Delete Posts:** Users can delete their own posts.
- **View Posts:** Users can view posts created by others.

## Screenshots

<!-- Add screenshots here -->

## Getting Started

### Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed Flutter and Dart on your machine.
- You have a Firebase project set up.

### Installation

1. Clone the repository:

```bash
git clone https://github.com/DAVITtheDev7/Social.git
```

2. Navigate to the project directory:

```bash
cd Social
```

3. Install the dependencies:

```bash
flutter pub get
```

### Configuration

1. Set up Firebase in your Flutter project by following the [official guide](https://firebase.flutter.dev/docs/overview).
2. Ensure that you have enabled Email/Password authentication in your Firebase project.

### Running the App

Run the app on an emulator or a physical device:

```bash
flutter run
```

## Usage

1. **Sign Up:** Create a new account by providing an email and password.
2. **Sign In:** Log in to your account using the credentials you signed up with.
3. **Reset Password:** Use the "Forgot Password" feature to reset your password.
4. **Post Content:** Create and upload new posts from the home screen.
5. **Delete Posts:** Swipe on a post to delete it.

## Project Structure

```
lib/
├── main.dart
├── model/
│   └── post_model.dart
├── pages/
│   ├── home_page.dart
│   ├── sign



