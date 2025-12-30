# Training Scenarios - Complete Documentation

## Overview
The training system is structured around **Levels** and **Days**. Each level contains multiple days, and users progress through days sequentially. When all days in a level are completed, they move to the next level.

---

## 1. Level and Day Structure

### Database Structure (Firestore)

```
users/{userId}/
  ├── currentLevel: number (default: 1)
  ├── currentDay: number (default: 0 or 1)
  ├── originalBaseline: number (first baseline measurement)
  ├── currentBaseline: number (updated after each training)
  ├── speedUnit: string (MPH/KPH)
  ├── distanceUnit: string (YDS/M)
  └── trainingLockedUntil: timestamp (optional)

protocol/
  ├── level1/
  │   ├── videoId: string (tutorial video for level)
  │   └── actions/ (subcollection)
  │       ├── 0/ (action document)
  │       │   ├── exerciseId: string
  │       │   ├── count: number (swings per action)
  │       │   ├── weight: number
  │       │   ├── dominant: boolean (left/right side)
  │       │   └── requiresInput: boolean (speed input needed)
  │       ├── 1/
  │       └── ...
  ├── level2/
  └── ...

exercise/{exerciseId}/
  ├── exerciseName: string
  ├── heading: string
  ├── videoId: string (YouTube video ID)
  ├── allowDriver: boolean
  └── ...
```

### Constants
- **Training Level Days**: 12 days per level (iOS: `Constants.trainingLevelDays = 12`)
- **Countdown Timers**:
  - Next swing countdown: 15 seconds (default)
  - Weight switch countdown: 30 seconds
  - Side switch countdown: 20 seconds
  - Swing countdown: 5 seconds (in SwingSheet)

---

## 2. Training Flow Scenarios

### Scenario 1: First Time User (No Baseline)

**Flow:**
1. User opens app → No `originalBaseline` exists
2. Home screen shows:
   - Intro video (if available)
   - "Measure baseline" tile (priority menu item)
3. User clicks "Measure baseline"
4. **Measure Baseline Flow:**
   - Shows baseline measurement screen
   - User performs swings with speed input
   - Baseline is calculated and saved as `originalBaseline` and `currentBaseline`
5. After baseline measurement:
   - `currentLevel = 1`, `currentDay = 1`
   - Training becomes available
   - Home screen shows calendar and stats tiles

**Code Location:**
- `home_controller.dart`: Checks `originalBaseline` to show measure baseline
- `measure_baseline_active_screen.dart`: Baseline measurement flow
- `training_repo.dart`: `updateBaseline()` saves baseline

---

### Scenario 2: Starting Training (Level X, Day Y)

**Flow:**
1. User clicks "Start training" on home screen
2. **Training Screen** (`training_screen.dart`):
   - Shows current level and day (e.g., "Level 1, Day 1")
   - Displays tutorial video (from `protocol/levelX/videoId`)
   - Shows "Coming up" exercises list
   - Shows time to complete estimate
   - Shows radar selection (if applicable)
   - Shows "I have warmed up" checkbox
   - Shows "Slide to start" button

3. User can change level/day:
   - Tap level/day buttons
   - Select different day (1-12)
   - Protocol data reloads for selected day

4. User checks "I have warmed up" and slides to start

**Code Location:**
- `training_controller.dart`: Loads protocol data for level/day
- `training_repo.dart`: `getProtocolData(level, day)` fetches exercises and video

---

### Scenario 3: Active Training Session

**Flow:**
1. **Start Button Clicked**:
   - `TrainingActiveScreen` opens
   - Shows first exercise video and name
   - Shows "START" button with "Press when ready"

2. **User Clicks START**:
   - `startSwingSequence()` called
   - `SwingSheet` appears with 5-second countdown (5, 4, 3, 2, 1, SWING)
   - User performs swing
   - If `requiresInput = true`: Speed input field appears
   - User enters speed (if needed)

3. **SwingSheet Closes**:
   - `finishSwing()` called
   - `prepareNextSwing()` determines next action
   - If not exercise switch: `countDownToNextSwing()` starts (15 seconds)
   - Countdown screen shows:
     - Notification text ("PREPARE TO SWING", "NEXT EXERCISE", etc.)
     - Swing parameters description
     - Hourglass icon + countdown timer
     - Pause/Continue button

4. **Countdown Reaches 0**:
   - Automatically starts next swing
   - `SwingSheet` appears again
   - Process repeats

**Code Location:**
- `training_active_controller.dart`: Manages swing sequence, countdowns, progress
- `swing_sheet_screen.dart`: 5-second countdown and speed input
- `training_active_screen.dart`: Main training UI

---

### Scenario 4: Exercise/Weight/Side Changes

**During Training:**
- **Exercise Change**: When next action has different `exerciseId`
  - Shows "NEXT EXERCISE" notification
  - Shows "Start" button (user must click to continue)
  - Countdown is 0 (immediate start when clicked)

- **Weight Change**: When next action has different `weight`
  - Shows "ADD ONE WEIGHT" notification
  - Countdown: 30 seconds
  - User can pause/continue

- **Side Change**: When next action has different `dominant` (left/right)
  - Shows "SWITCH SIDES" notification
  - Countdown: 20 seconds
  - User can pause/continue

**Code Location:**
- `training_active_controller.dart`: `prepareNextSwing()` detects changes
- `_moveToNextAction()`: Sets notification flags

---

### Scenario 5: Quitting Training (Unfinished Training)

**Flow:**
1. User clicks "Quit training" during active session
2. **Progress Saved**:
   - Current action index
   - Current swing number
   - Speed inputs (if any)
   - Exercise list
   - Saved to `SharedPreferences` and optionally Firestore

3. **Home Screen Updates**:
   - Shows "Continue training" tile (priority menu item)
   - Shows "Pick up where you left off" heading

4. **User Clicks "Continue training"**:
   - Alert appears: "You're on Level X Day Y"
   - Options:
     - **Continue**: Resumes from saved progress
     - **Start over**: Clears progress, starts fresh

**Code Location:**
- `training_active_controller.dart`: `quit()` saves unfinished training
- `home_controller.dart`: Checks `hasUnfinishedTraining()` and shows continue option
- `training_repo.dart`: `saveUnfinishedTraining()`, `getUnfinishedTraining()`, `clearUnfinishedTraining()`

---

### Scenario 6: Training Completion

**Flow:**
1. **Last Swing Completed**:
   - `prepareNextSwing()` detects no more actions
   - `_activeFinishTraining()` called
   - `trainingCompleted = true`

2. **Completion Screen Shows**:
   - "Training completed" heading
   - New baseline display (if speed inputs collected):
     - Shows new baseline value
     - Shows difference from old baseline (e.g., "+5.2 MPH")
   - Or "Great job!" message (if no speed inputs)
   - Share button
   - Finish button

3. **User Clicks Finish**:
   - **Day Progression**:
     - `currentDay += 1`
     - If `currentDay > 12` (trainingLevelDays):
       - `currentLevel += 1`
       - `currentDay = 1`
   - **Baseline Update** (if radar enabled and speed inputs exist):
     - Calculates average of all speed inputs
     - Updates `currentBaseline` in Firestore
   - **Calendar Entry**:
     - Adds entry to user's calendar for today
   - **Training Lock** (optional):
     - Sets `trainingLockedUntil` to start of next day
   - **Navigation**:
     - Returns to home screen
     - Shows rating prompt (after 1 second delay)

**Code Location:**
- `training_active_controller.dart`: `finishTraining()`, `newBaseline` calculation
- iOS: `TrainingActiveView.swift`: `dismissWithRatingRequest()`, `moveToNextDay()`
- Flutter: Needs implementation for day progression on completion

---

## 3. Training State Management

### Key State Variables

**TrainingActiveController:**
```dart
bool _swingSequenceActive = false;  // Shows countdown UI
bool _swingSheetPresented = false;  // Shows SwingSheet overlay
bool _trainingCompleted = false;     // Training finished
int _currentSwingNo = 0;             // Current swing in action
ExerciseData? _currentAction;       // Current exercise/action
List<ExerciseData> _dayProtocol;    // All exercises for day
int _nextSwingCountdown = 15;       // Countdown timer
bool _notifyExerciseSwitch = false; // Show "NEXT EXERCISE"
bool _notifyWeightSwitch = false;   // Show "ADD ONE WEIGHT"
bool _notifySideSwitch = false;    // Show "SWITCH SIDES"
double _trainingProgressPercentage; // Progress bar (0.0 - 1.0)
List<double> _baselineSpeeds = [];   // Speed inputs collected
```

### State Transitions

```
Initial State
  ↓
[Start Button Clicked]
  ↓
SwingSheet (5 sec countdown)
  ↓
[SwingSheet Complete]
  ↓
Countdown Screen (15 sec) OR Exercise Switch Screen
  ↓
[Countdown 0 OR Start Clicked]
  ↓
Next SwingSheet
  ↓
[Repeat until all actions complete]
  ↓
Training Completed Screen
```

---

## 4. Protocol Data Structure

### Protocol Document (`protocol/level1`)
```json
{
  "videoId": "youtube_video_id_here"
}
```

### Actions Subcollection (`protocol/level1/actions/`)
```json
{
  "0": {
    "exerciseId": "exercise_123",
    "count": 5,
    "weight": 0,
    "dominant": true,
    "requiresInput": true
  },
  "1": {
    "exerciseId": "exercise_123",
    "count": 5,
    "weight": 1,
    "dominant": true,
    "requiresInput": true
  },
  "2": {
    "exerciseId": "exercise_456",
    "count": 5,
    "weight": 1,
    "dominant": false,
    "requiresInput": false
  }
}
```

### Exercise Document (`exercise/exercise_123`)
```json
{
  "exerciseName": "Driver Swing",
  "heading": "Driver",
  "videoId": "youtube_video_id",
  "allowDriver": true
}
```

---

## 5. Action Processing Logic

### Action Count
- If `action.time > 0`: 1 swing per action
- If `action.time = 0`: 5 swings per action (default)

### Swing Progression
```dart
void prepareNextSwing() {
  final actionCount = _getActionCount(_currentAction!);
  
  if (_currentSwingNo >= actionCount - 1) {
    // Move to next action
    _moveToNextAction();
  } else {
    // Same action, increment swing number
    _currentSwingNo++;
  }
}
```

### Action Change Detection
```dart
void _moveToNextAction() {
  final newAction = _dayProtocol[currentIndex + 1];
  
  if (newAction.exerciseName != _currentAction!.exerciseName) {
    _notifyExerciseSwitch = true;  // Different exercise
  } else if (newAction.weight != _currentAction!.weight) {
    _notifyWeightSwitch = true;   // Weight change
  } else if (newAction.dominant != _currentAction!.dominant) {
    _notifySideSwitch = true;     // Side change
  }
}
```

---

## 6. Unfinished Training Data Structure

### Saved to SharedPreferences:
```json
{
  "speedInputs": [85.5, 87.2, 86.8],
  "exercises": [
    { /* ExerciseData JSON */ },
    { /* ExerciseData JSON */ }
  ],
  "currentActionIndex": 2,
  "currentSwingNo": 3
}
```

### Loading Unfinished Training:
1. Check `SharedPreferences` for saved data
2. If exists:
   - Restore `_baselineSpeeds`
   - Restore `_dayProtocol`
   - Restore `_currentAction` (from index)
   - Restore `_currentSwingNo`
3. If not exists:
   - Load fresh protocol data for current level/day

---

## 7. Training Progress Calculation

### Progress Percentage
```dart
double _trainingProgressPercentage = _actionsCompleted / _totalActions;

int get _actionsCompleted {
  // Returns index of current action in protocol
  return _dayProtocol.indexOf(_currentAction!);
}

int get _totalActions => _dayProtocol.length;
```

### Progress Bar Display
- Shows in footer of `TrainingActiveScreen`
- Updates after each swing completion
- Visual indicator of training completion

---

## 8. Baseline Calculation

### During Training:
- Speed inputs collected in `_baselineSpeeds` array
- Each swing with `requiresInput = true` adds speed value

### After Training:
```dart
double get newBaseline {
  if (_baselineSpeeds.isEmpty) return 0.0;
  return _baselineSpeeds.reduce((a, b) => a + b) / _baselineSpeeds.length;
}
```

### Baseline Update:
- Only if user has radar enabled (`radarOption != .noRadar`)
- Only if speed inputs were collected (`baselineSpeeds.isNotEmpty`)
- Updates `currentBaseline` in Firestore
- Does NOT update `originalBaseline` (only set once)

---

## 9. Day/Level Progression Logic

### Current Implementation (iOS):
```swift
user.currentDay += 1
if user.currentDay == (Constants.trainingLevelDays) + 1 {
  // Level completed, move to next level
  user.currentLevel += 1
  user.currentDay = 1
}
```

### Flutter Implementation Needed:
- On training completion, update `currentDay` in Firestore
- If `currentDay > 12`, increment `currentLevel` and reset `currentDay = 1`
- Update `trainingLockedUntil` timestamp (optional)
- Add calendar entry for completed day

---

## 10. Training Lock Mechanism

### Purpose:
- Prevents user from training multiple times in same day
- Enforces one training session per day

### Implementation:
```swift
if lockTrainingUntilTomorrow {
  user.trainingLockedUntil = Calendar.current.startOfNextDay
}
```

### Check Before Training:
- Verify `trainingLockedUntil` is in past or null
- If locked, show message or disable training button

---

## 11. Calendar Integration

### Calendar Entry Structure:
```json
{
  "date": "timestamp",
  "level": 1,
  "day": 1,
  "completed": true
}
```

### When Entry is Added:
- After successful training completion
- Only if training was completed (not quit)
- Added to user's `calendarData.entries` array

---

## 12. Error Scenarios

### Scenario: Protocol Not Found
- If `protocol/levelX` doesn't exist:
  - Return empty exercises list
  - Show error message
  - Allow user to select different level/day

### Scenario: Network Error
- If Firestore fetch fails:
  - Show error toast
  - Retry option
  - Fallback to cached data (if available)

### Scenario: Training Data Corrupted
- If unfinished training data is invalid:
  - Clear corrupted data
  - Start fresh training session
  - Log error for debugging

---

## 13. Testing Scenarios

### Test Case 1: First Time User
1. New user registration
2. No baseline exists
3. Measure baseline flow
4. Verify baseline saved
5. Training becomes available

### Test Case 2: Complete Training Session
1. Start training (Level 1, Day 1)
2. Complete all swings
3. Verify day progression
4. Verify baseline update (if applicable)
5. Verify calendar entry

### Test Case 3: Quit and Resume
1. Start training
2. Complete 3 swings
3. Quit training
4. Verify progress saved
5. Resume training
6. Verify continues from swing 4

### Test Case 4: Exercise Changes
1. Training with multiple exercises
2. Verify "NEXT EXERCISE" notification
3. Verify Start button appears
4. Continue to next exercise

### Test Case 5: Weight/Side Changes
1. Training with weight progression
2. Verify "ADD ONE WEIGHT" notification
3. Verify 30-second countdown
4. Test pause/continue functionality

---

## 14. Key Files Reference

### Controllers:
- `home_controller.dart`: Manages home screen, baseline check, continue training
- `training_controller.dart`: Manages training screen, protocol loading
- `training_active_controller.dart`: Manages active training session, swings, countdowns
- `swing_sheet_controller.dart`: Manages SwingSheet countdown and input

### Views:
- `home.dart`: Home screen with calendar, stats, menu
- `training_screen.dart`: Training setup screen
- `training_active_screen.dart`: Active training session screen
- `swing_sheet_screen.dart`: 5-second countdown overlay
- `measure_baseline_active_screen.dart`: Baseline measurement flow

### Repositories:
- `training_repo.dart`: Firestore operations for training data
- `home_repo.dart`: Firestore operations for user data, calendar

### Models:
- `exercise_data.dart`: Exercise/action data model
- `calendar_entry.dart`: Calendar entry model

---

## 15. iOS vs Flutter Differences

### iOS Implementation:
- Uses `TrainingProgress` class for unfinished training
- Uses `DatabaseManager.shared.moveToNextDay()` for progression
- Uses `TimelineState` struct for level/day tracking
- Training lock uses `Calendar.current.startOfNextDay`

### Flutter Implementation:
- Uses `SharedPreferences` for unfinished training
- Needs `updateTimeline()` implementation for progression
- Uses `HomeController` for level/day tracking
- Training lock needs timestamp implementation

---

## Summary

The training system is a complex state machine that:
1. Manages user progression through levels and days
2. Handles multiple exercise types with different parameters
3. Tracks swing-by-swing progress
4. Saves and restores unfinished training
5. Calculates and updates baseline measurements
6. Integrates with calendar for tracking
7. Provides pause/resume functionality
8. Handles various notification scenarios (exercise/weight/side changes)

The key to understanding the system is recognizing that each training session consists of:
- **Actions**: Individual exercise instances with specific parameters
- **Swings**: Multiple repetitions within an action (usually 5, or 1 if time-based)
- **Countdowns**: Rest periods between swings (15/20/30 seconds)
- **Progress**: Tracked by action completion, not swing completion


