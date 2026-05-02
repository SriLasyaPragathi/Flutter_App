# Task Manager App - Flutter + Back4App

A Flutter-based Task Manager Application that demonstrates CRUD (Create, Read, Update, Delete) operations with Back4App as a Backend-as-a-Service (BaaS).

##  Project Overview

This project showcases:
- **User Authentication** – Register and login with email/password
- **CRUD Operations** – Create, read, update, and delete tasks
- **Cloud Database** – Back4App (Parse Server) for data persistence
- **Real-Time Sync** – Task updates reflected immediately across the app
- **Secure Logout** – Session management and invalidation

##  Architecture

```
Flutter App (Frontend)
        ↓
Parse SDK for Flutter
        ↓
Back4App (Parse Server)
        ↓
Cloud Database
```

### Project Structure

```
task_manager_app/
├── lib/
│   ├── main.dart                    # App entry point & Parse initialization
│   ├── screens/
│   │   ├── home_screen.dart         # Main navigation hub
│   │   ├── auth/
│   │   │   ├── login_screen.dart    # Login UI
│   │   │   ├── register_screen.dart # Registration UI
│   │   ├── tasks/
│   │   │   ├── task_list_screen.dart   # Task list with CRUD UI
│   │   │   ├── task_create_screen.dart # Create task UI
│   │   │   ├── task_edit_screen.dart   # Edit task UI
│   ├── services/
│   │   ├── auth_service.dart        # Authentication logic
│   │   ├── task_service.dart        # Task CRUD operations
│   ├── models/
│   │   ├── task_model.dart          # Task data model
├── pubspec.yaml                     # Dependencies & project metadata
└── README.md                        # This file
```

##  Getting Started

### Prerequisites

1. **Flutter SDK** – [Install Flutter](https://flutter.dev/docs/get-started/install)
2. **Dart** – Comes with Flutter
3. **Back4App Account** – [Sign up at free.back4app.com](https://free.back4app.com)
4. **GitHub Account** – [For version control](https://github.com)

### Step 1: Create Back4App App & Get Credentials

1. Go to https://free.back4app.com
2. Sign up (use GitHub if you have an account)
3. Click **"Build a Backend"**
4. Create a new app named `TaskManagerApp`
5. Navigate to **Settings → App Keys**
6. Copy your:
   - **Application ID**
   - **Client Key**

### Step 2: Setup Flutter Project

Clone or download this project:

```bash
cd task_manager_app
flutter pub get
```

### Step 3: Add Back4App Credentials

**Replace the placeholder credentials in `lib/main.dart`:**

```dart
await Parse().initialize(
  'YOUR_APPLICATION_ID',        // ← Paste your Application ID here
  'https://parseapi.back4app.com/',
  clientKey: 'YOUR_CLIENT_KEY',  // ← Paste your Client Key here
  autoSendSessionId: true,
);
```

### Step 4: Run the App

**On Android:**
```bash
flutter run
```

**On iOS:**
```bash
flutter run -d ios
```

**On Web (optional):**
```bash
flutter run -d web
```

## 📱 App Features & User Flow

### 1. **Splash Screen** (Initial Load)
- Checks if user is already logged in
- Redirects to login or home screen

### 2. **Authentication Module**

#### Registration Screen
- Email and password input fields
- Password confirmation validation
- Minimum 6-character password requirement
- Creates user account in Back4App
- Auto-redirects to login after successful registration

#### Login Screen
- Email and password input fields
- Validates credentials against Back4App database
- Session persistence (user stays logged in after app restart)
- Error messages for authentication failures
- Link to registration screen for new users

### 3. **Task Management Module**

#### Task List Screen (Main Screen)
- Displays all tasks created by the logged-in user
- **Features:**
  -  Mark tasks as complete/incomplete (checkbox)
  - Edit task details (button)
  - Delete task (button)
  - Create new task (floating action button)
  - Pull-to-refresh to reload tasks
  - User email displayed in header

#### Create Task Screen
- Text inputs for:
  - Task title (required)
  - Task description (required)
- Validation ensures fields are not empty
- Success message on creation
- Auto-refresh task list

#### Edit Task Screen
- Pre-populated with existing task data
- Update title, description, or completion status
- Validation before saving
- Success message on update

#### Logout
- Menu option in app bar
- Confirmation dialog to prevent accidental logout
- Clears user session from Back4App
- Redirects to login screen

## CRUD Operations

### **Create (POST)**
```
User Input → Task Create Screen → TaskService.createTask() 
→ Back4App REST API → Cloud Database
```

### **Read (GET)**
```
Home Screen → TaskService.fetchAllTasks() 
→ Back4App REST API → Display in ListView
```

### **Update (PUT)**
```
Edit Task Screen → TaskService.updateTask() 
→ Back4App REST API → Task Updated in Cloud
```

### **Delete (DELETE)**
```
Task List → Delete Button → TaskService.deleteTask() 
→ Back4App REST API → Task Removed from Cloud
```

##  Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  parse_server_sdk_flutter: ^5.1.0  # Back4App SDK
  http: ^1.1.0                      # HTTP requests
  provider: ^6.0.0                  # State management (optional)
  cupertino_icons: ^1.0.2           # Icons
```
##  Testing the App

### Manual Testing Checklist

1. **Registration Flow**
   - [ ] Create new account with email
   - [ ] Try duplicate email (should fail)
   - [ ] Verify account in Back4App dashboard

2. **Login Flow**
   - [ ] Login with registered credentials
   - [ ] Try wrong password (should fail)
   - [ ] App should persist login on restart

3. **Task CRUD**
   - [ ] Create task → appears in list
   - [ ] Edit task → changes saved in cloud
   - [ ] Delete task → removed from all places
   - [ ] Mark complete → checkbox updates

4. **Logout**
   - [ ] Logout → redirected to login screen
   - [ ] Cannot access home screen without login
   - [ ] Re-login → same tasks appear (data persists)

## Back4App Dashboard

After creating tasks, verify in Back4App:

1. Go to your app on Back4App
2. Click **"Parse Dashboard"**
3. You should see:
   - `_User` class with your registered users
   - `Task` class with your created tasks

## Troubleshooting

### App Crashes on Startup
- **Cause:** Invalid Back4App credentials
- **Fix:** Verify Application ID and Client Key in `main.dart`

### Login Fails
- **Cause:** Wrong email/password or user doesn't exist
- **Fix:** Try registering a new account first

### Tasks Not Saving
- **Cause:** No internet connection or Parse SDK not initialized
- **Fix:** Check device connectivity and verify Parse initialization

### Tasks Not Refreshing
- **Cause:** Task list not reloaded after operation
- **Fix:** Pull-to-refresh manually or app should auto-reload

##  Key Learnings

This project teaches:
1. Flutter widget hierarchy and navigation
2. REST API calls with Parse SDK
3. Backend-as-a-Service (BaaS) concept
4. User authentication and session management
5. CRUD operations on cloud database
6. Error handling and validation
7. sync/await patterns in Dart
8. Model-View separation of concerns
---
