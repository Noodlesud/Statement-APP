Flutter Firebase Opinion/Question App

📋 Project Description

This Flutter mobile application provides a platform for users to post their opinions or questions and engage with others through comments and likes. The app integrates Firebase as the backend to manage authentication, storage, and real-time data. Users can:

Sign up or log in to access the app.

View a feed of all posted statements.

Post their own statements.

Comment on and like other users' posts.

Delete their own statements and comments.

Customize the app appearance with light and dark themes.

View and manage their profile.

The unique user ID ensures that only the author of a statement or comment can delete it, maintaining user privacy and control.

🛠️ Build and Run Instructions

Prerequisites

Ensure you have the following installed and configured:

Flutter SDK (version 3.0 or later).

Dart SDK.

A Firebase project.

An IDE such as Visual Studio Code or Android Studio.

Android or iOS emulator, or a physical device.

Firebase Configuration

Create a Firebase project at Firebase Console.

Add your Flutter app to the Firebase project.

Download the google-services.json (for Android) and GoogleService-Info.plist (for iOS) files from the Firebase console.

Place google-services.json in the android/app directory.

Place GoogleService-Info.plist in the ios/Runner directory.

Enable Firebase Authentication and configure email/password authentication.

Set up Firestore Database for storing posts and comments.

Steps to Build and Run

Clone this repository:

git clone https://github.com/Noodlesud/Statement-APP.git

Navigate to the project directory:

cd statement_app

Install dependencies:

flutter pub get

Run the app on an emulator or device:

flutter run

🧩 Summary of Functions Implemented

🔐 Authentication

Sign In: Allows users to log in using their email and password.

Sign Up: Enables new users to create an account with email and password.

📝 Post Management

Add Post: Users can create a new statement.

View Posts: Displays a feed of all statements posted by users.

Delete Post: Only the author of a post can delete it.

💬 Comment and Like Functionality

Comment: Users can comment on any statement.

Like: Allows users to like statements.

Delete Comment: Only the author of a comment can delete it.

👤 Profile Management

Displays the user’s profile, including basic account details and a list of their posts.

🎨 Theme Customization

Supports light and dark themes, enabling users to switch according to their preference.

🔗 Firebase Integration

Firebase Authentication for user management.

Firestore Database for real-time storage of posts, comments, and user data.

Firebase Storage for handling profile pictures and media (if implemented).

This README provides a comprehensive overview of the Flutter Firebase Opinion/Question App, its functionality, and how to build and run it locally.

