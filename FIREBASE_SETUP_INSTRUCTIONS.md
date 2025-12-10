# Firebase Setup Instructions

## ✅ Firebase Integration Complete!

All Firebase functionality has been implemented in the Flutter app. Follow these steps to complete the setup:

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select existing project
3. Follow the setup wizard

## Step 2: Add Android App to Firebase

1. In Firebase Console, click "Add app" → Android
2. Register app with package name (check `android/app/build.gradle`)
3. Download `google-services.json`
4. Place it in `android/app/` directory

## Step 3: Add iOS App to Firebase

1. In Firebase Console, click "Add app" → iOS
2. Register app with bundle ID (check `ios/Runner.xcodeproj`)
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

## Step 4: Install Dependencies

Run in terminal:
```bash
cd clean_code_structure
flutter pub get
```

## Step 5: Configure Android

### Update `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### Update `android/app/build.gradle`:

Add at the bottom:
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 6: Configure iOS

### Update `ios/Podfile`:

Ensure minimum iOS version is 11.0:
```ruby
platform :ios, '11.0'
```

### Run:
```bash
cd ios
pod install
cd ..
```

## Step 7: Enable Firebase Services

In Firebase Console, enable:

1. **Authentication**
   - Go to Authentication → Sign-in method
   - Enable "Email/Password"

2. **Firestore Database**
   - Go to Firestore Database
   - Create database (start in test mode for development)
   - Set location

3. **Storage**
   - Go to Storage
   - Get started
   - Start in test mode for development

## Step 8: Firestore Security Rules

Update Firestore rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /posts/{postId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
    match /exercises/{exerciseId} {
      allow read: if request.auth != null;
    }
    match /rewards/{rewardId} {
      allow read: if request.auth != null;
    }
  }
}
```

## Step 9: Storage Security Rules

Update Storage rules in Firebase Console:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 10: Test the App

1. Run the app: `flutter run`
2. Test registration with a new email
3. Test login
4. Test creating a post
5. Verify data appears in Firestore Console

## Firestore Collections Structure

The app expects these collections:

### `users/{userId}`
```json
{
  "email": "user@example.com",
  "createdAt": "timestamp",
  "feedPostIds": ["postId1", "postId2"],
  "platforms": ["Flutter"],
  "currentLevel": 1,
  "currentDay": 0,
  "baseline": {},
  "isPro": false
}
```

### `posts/{postId}`
```json
{
  "date": "timestamp",
  "isFromCoach": false,
  "text": "Post text",
  "storagePaths": ["path/to/image"]
}
```

### `exercises/{exerciseId}`
```json
{
  "level": 1,
  "day": 1,
  "exerciseName": "Exercise name",
  "heading": "Heading",
  "videoId": "video_id",
  "isBaseline": false,
  "weight": 0,
  "time": 0
}
```

### `rewards/{rewardId}`
```json
{
  "name": "Reward name",
  "title": "Reward title",
  "rule": "Reward rule",
  "image": "image_url",
  "isAvailable": true
}
```

## Troubleshooting

### Error: "FirebaseApp not initialized"
- Ensure `Firebase.initializeApp()` is called in `main.dart` before `runApp()`

### Error: "Missing google-services.json"
- Ensure file is in `android/app/` directory
- Rebuild the app: `flutter clean && flutter pub get`

### Error: "Permission denied" in Firestore
- Check security rules in Firebase Console
- Ensure user is authenticated

### Error: "Storage permission denied"
- Check Storage security rules
- Ensure user is authenticated

## Next Steps

1. Set up Firebase Analytics (optional)
2. Set up Firebase Crashlytics (optional)
3. Set up Firebase Messaging for push notifications (optional)
4. Configure in-app purchases for Paywall module

## Support

If you encounter issues:
1. Check Firebase Console for error logs
2. Verify all configuration files are in place
3. Ensure Firebase services are enabled
4. Check security rules match your requirements

