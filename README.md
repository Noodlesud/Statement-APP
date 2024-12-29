Flutter Firebase Opinion/Question App
Project Description
This Flutter mobile application provides a platform for users to post their opinions or questions and engage with others through comments and likes. The app integrates Firebase as the backend to manage authentication, storage, and real-time data. Users can:
Sign up or log in to access the app.
View a feed of all posted statements.
Post their own statements.
Comment on and like other users' posts.
Delete their own statements and comments.
Customize the app’s appearance with light and dark themes.
View and manage their profile.
The unique user ID ensures that only the author of a statement or comment can delete it, maintaining user privacy and control.
Build and Run Instructions
Prerequisites
Flutter SDK installed (version 3.0 or later).
Dart SDK.
Firebase project configured.
An IDE such as Visual Studio Code or Android Studio.
Android or iOS emulator, or a physical device.
Steps to Build and Run
Clone this repository:
git clone https://github.com/your-repo/flutter-firebase-opinion-app.git
Navigate to the project directory:
cd flutter-firebase-opinion-app
Install dependencies:
flutter pub get
Run the app on an emulator or device:
flutter run

Summary of Functions Implemented
Authentication
Sign In: Allows users to log in using their email and password.
Sign Up: Enables new users to create an account with email and password.
Post Management
Add Post: Users can create a new statement.
View Posts: Displays a feed of all statements posted by users.
Delete Post: Only the author of a post can delete it.
Comment and Like Functionality
Comment: Users can comment on any statement.
Like: Allows users to like statements.
Delete Comment: Only the author of a comment can delete it.
Profile Management
Displays the user’s profile, including basic account details and a list of their posts.
Theme Customization
Supports light and dark themes, enabling users to switch according to their preference.
Firebase Integration
Uses Firebase Authentication for user management.
Firestore Database for real-time storage of posts, comments, and user data.
Firebase Storage for handling profile pictures and media (if implemented).
This README provides a comprehensive overview of the Flutter Firebase Opinion/Question App, its functionality, and how to build and run it locally.

