# 📰 Flutter News App

A feature-rich **Flutter News Application** built to demonstrate practical mobile development skills including REST API integration, state management, offline storage, Firebase services, push notifications, testing, and scalable app architecture.

The application fetches real-time news using **NewsAPI** and provides a smooth experience for browsing, searching, bookmarking, and receiving news updates.

## ✨ Key Features

### 📰 Real-Time News Headlines
- Fetches latest news articles using **NewsAPI REST APIs**
- Parses JSON responses into structured Dart models
- Displays article title, description, source, image, and other relevant information
- Handles loading, empty, and error states

### 🔍 News Search
- Search for news articles dynamically
- Uses API-based search functionality
- Updates application state using **Provider**

### 🔖 Offline Bookmarks
- Save favorite news articles
- Access bookmarked articles even without an active internet connection
- Stores article information locally for persistent access

### 🖼️ Image Caching
- Uses cached network images to improve performance
- Reduces unnecessary image downloads
- Handles missing article images gracefully

### 🔔 Firebase Push Notifications
Integrated **Firebase Cloud Messaging (FCM)** to support push notifications.

The implementation handles:

- Notification permission
- FCM device token generation
- Foreground notifications
- Background notifications
- Notification tap events
- App launch through notifications

Example flow:

```text
Firebase Cloud Messaging
        ↓
Push Notification
        ↓
User taps notification
        ↓
News App opens
        ↓
Notification Details screen
```

### 🔗 Deep Linking & Universal Links

Exploring deep linking to allow users to navigate directly to specific content inside the application.

Example:

```text
https://your-domain.com/news/flutter
                ↓
           News App
                ↓
        Relevant News Content
```

The iOS implementation explores:

- Universal Links
- Associated Domains
- Apple App Site Association (AASA)
- Deep navigation from push notifications

### 📊 Firebase Analytics
Integrated **Firebase Analytics** to track meaningful application events and understand user interactions.

Analytics logic is separated into a dedicated service layer to keep UI code maintainable.

### 🛡️ Firebase Crashlytics
Integrated **Firebase Crashlytics** for:

- Crash monitoring
- Runtime issue visibility
- Improved debugging of production problems

### 🧪 Unit Testing
Implemented unit tests for application logic and API services.

Testing includes:

- Model logic
- JSON parsing
- API service behavior
- Mock HTTP responses using `MockClient`
- Tests without making real network requests

### 🔐 Secure API Key Management
NewsAPI credentials are stored using environment configuration instead of being hard-coded in the application.

```text
.env
```

Sensitive values are excluded from Git using `.gitignore`.

An `.env.example` file can be shared safely without exposing the real API key.

## 🏗️ Architecture

The project follows a clean separation of responsibilities:

```text
lib/
├── models/
├── providers/
├── screens/
├── services/
├── widgets/
└── main.dart
```

### Models
Represent structured application data such as news articles.

### Services
Handle API communication, Firebase Analytics, Push Notifications, and related external services.

### Providers
Manage application state and connect business logic with the UI.

### Screens
Contain major application pages such as Headlines, Search, Bookmarks, and Notification Details.

### Widgets
Contain reusable UI components such as news cards.

## 🛠️ Tech Stack

| Technology | Usage |
|---
