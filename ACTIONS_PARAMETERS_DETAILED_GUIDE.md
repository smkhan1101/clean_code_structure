# Actions Parameters - Complete Detailed Guide

## Overview
Yeh guide explain karta hai ki actions ke sabhi parameters ka kya matlab hai, kab "Prepare to swing" use hota hai, kab "Switch sides" use hota hai, aur kaise naye exercises add kiye ja sakte hain.

---

## 1. Action Parameters - Complete Explanation

### Database Structure:
```
protocol/level1/actions/
  ├── 0/
  │   ├── exerciseId: "top-down"
  │   ├── count: 3
  │   ├── dominant: false
  │   ├── weight: 0
  │   ├── requiresInput: true
  │   ├── allowDriver: false
  │   └── durationSeconds: null (optional)
  ├── 1/
  │   ├── exerciseId: "top-down"
  │   ├── count: 3
  │   ├── dominant: false
  │   └── weight: 0
  └── 12/
      ├── exerciseId: "normal"
      ├── count: 5
      ├── dominant: true
      ├── weight: 2
      ├── requiresInput: true
      └── allowDriver: true
```

---

## 2. All Parameters Explained

### `exerciseId` (String) - Required
**Kya hai:**
- Exercise ka unique identifier
- Exercise document ko fetch karne ke liye use hota hai

**Example Values:**
- `"top-down"` - Top down swing exercise
- `"normal"` - Normal swing exercise
- `"lead-heel-lift"` - Lead heel lift exercise
- `"driver"` - Driver club exercise

**Kahan se aata hai:**
- Action document se directly
- `exercise/{exerciseId}` collection se exercise details fetch hote hain

**Use:**
```dart
// Fetch exercise details
final exerciseDoc = await FirebaseFirestore.instance
    .collection('exercise')
    .doc(action['exerciseId'])
    .get();
```

---

### `count` (Int) - Required
**Kya hai:**
- Kitne swings/repetitions perform karne hain
- Agar `count > 0`: Number of swings
- Agar `count = 0` ya `time > 0`: Timer-based exercise

**Values:**
- `0` = Timer-based exercise (use `durationSeconds`)
- `3` = 3 swings
- `5` = 5 swings (default)

**iOS Code Logic:**
```swift
// ProtocolAction.swift
var actionCount: Int {
    if case .timed(let seconds) = exerciseType {
        return 1  // Timer-based = 1 action
    }
    return count  // Otherwise use count
}
```

**Flutter Implementation:**
```dart
int _getActionCount(ExerciseData action) {
    // If time > 0, it's timer-based (1 action)
    if (action.time > 0) return 1;
    // Otherwise use count (default 5)
    return action.count > 0 ? action.count : 5;
}
```

**Example:**
- Action 0: `count: 3` = 3 swings
- Action 12: `count: 5` = 5 swings
- Action with timer: `count: 0, durationSeconds: 60` = 60 seconds timer

---

### `dominant` (Bool?) - Optional
**Kya hai:**
- Dominant side (right/left hand) use karna hai ya nahi
- `true` = Dominant side (right hand for right-handed)
- `false` = Non-dominant side (left hand for right-handed)
- `null` = Doesn't matter / both sides / general exercise

**Use Cases:**
- Golf swings: Dominant hand swings
- Bilateral exercises: `null` or both sides

**Display Logic:**
```swift
// ProtocolAction.swift
func swingParametersDescription() -> String {
    if let dominant {
        result += dominant ? "Dominant" : "Non-dominant"
    }
    // Shows: "Dominant, 2 weights" or "Non-dominant, zero weights"
}
```

**When "Switch sides" is shown:**
- Jab next action ka `dominant` value different ho current action se
- Example:
  - Current: `dominant: true` (right hand)
  - Next: `dominant: false` (left hand)
  - Result: "SWITCH SIDES" notification

**Flutter Code:**
```dart
void _moveToNextAction() {
    final newAction = _dayProtocol[currentIndex + 1];
    
    if (newAction.dominant != _currentAction!.dominant) {
        _notifySideSwitch = true;  // Show "SWITCH SIDES"
    }
}
```

---

### `weight` (Int) - Optional (Default: 0)
**Kya hai:**
- Kitne weights add karne hain
- Weight progression ke liye use hota hai

**Values:**
- `0` = No weights (zero weights)
- `1` = 1 weight
- `2` = 2 weights
- `3` = 3 weights

**Display:**
```swift
// ProtocolAction.swift
func weightDescription(increment: Int = 0) -> String {
    switch weight + increment {
    case 0: return "zero weights"
    case 1: return "1 weight"
    case 2: return "2 weights"
    case 3: return "3 weights"
    }
}
```

**When "Add one weight" is shown:**
- Jab next action ka `weight` value increase ho
- Example:
  - Current: `weight: 0`
  - Next: `weight: 1`
  - Result: "ADD ONE WEIGHT" notification

**Flutter Code:**
```dart
void _moveToNextAction() {
    final newAction = _dayProtocol[currentIndex + 1];
    
    if (newAction.weight != _currentAction!.weight) {
        _notifyWeightSwitch = true;  // Show "ADD ONE WEIGHT"
    }
}
```

---

### `requiresInput` (Bool) - Optional (Default: false)
**Kya hai:**
- User se speed input chahiye ya nahi
- Radar enabled users ke liye speed measurement

**Values:**
- `true` = Speed input required (show input field after swing)
- `false` = No speed input needed

**Use:**
- Baseline measurement: `requiresInput: true`
- Training with radar: `requiresInput: true`
- Training without radar: `requiresInput: false`

**Flutter Implementation:**
```dart
// SwingSheetScreen
if (controller.requiresInput && controller.presentInputField) {
    // Show speed input field
}
```

---

### `allowDriver` (Bool) - Optional (Default: false)
**Kya hai:**
- Driver club use kar sakte hain ya nahi
- Golf-specific parameter

**Values:**
- `true` = Driver club allowed
- `false` = Driver club not allowed

**Display:**
```swift
// ProtocolAction.swift
func weightDescription(increment: Int = 0) -> String {
    var result = "..."
    if allowDriver { 
        result += " or driver"
    }
    return result
}
// Shows: "2 weights or driver"
```

---

### `durationSeconds` (Int?) - Optional
**Kya hai:**
- Timer-based exercise ke liye duration
- Agar `count = 0` ya `time > 0`, to timer use hota hai

**When Used:**
- `count: 0` AND `durationSeconds: 60` = 60 seconds timer
- `time > 0` in ExerciseData = Timer-based exercise

**iOS Code:**
```swift
// ProtocolAction.swift
init?(from object: [String: Any], withId id: String) {
    if let duration = object["durationSeconds"] as? Int {
        self.exerciseType = .timed(seconds: duration)
    } else {
        self.exerciseType = .standard
    }
}
```

**Flutter Implementation:**
```dart
// ExerciseData
int time;  // If > 0, it's timer-based

int _getActionCount(ExerciseData action) {
    return action.time > 0 ? 1 : 5;  // Timer = 1 action
}
```

**Timer Countdown:**
- Timer-based exercises mein countdown show hota hai
- Example: 60 seconds timer = 60, 59, 58... 1, 0

---

## 3. Notification Messages - When They Appear

### "PREPARE TO SWING" (Default)
**When shown:**
- Jab koi special change nahi ho raha
- Normal swing sequence continue ho rahi hai
- Same exercise, same parameters

**Code:**
```dart
String get nextSwingNotification {
    if (_notifyExerciseSwitch) {
        return 'NEXT EXERCISE';
    } else if (_notifyWeightSwitch) {
        return 'ADD ONE WEIGHT';
    } else if (_notifySideSwitch) {
        return 'SWITCH SIDES';
    }
    return 'PREPARE TO SWING';  // Default
}
```

**Example Scenario:**
```
Action 0: exerciseId="top-down", count=3, dominant=false, weight=0
Action 1: exerciseId="top-down", count=3, dominant=false, weight=0
→ "PREPARE TO SWING" (same exercise, same parameters)
```

---

### "NEXT EXERCISE"
**When shown:**
- Jab next action ka `exerciseId` different ho
- Different exercise start ho rahi hai

**Code:**
```dart
void _moveToNextAction() {
    final newAction = _dayProtocol[currentIndex + 1];
    
    if (newAction.exerciseName != _currentAction!.exerciseName) {
        _notifyExerciseSwitch = true;  // Show "NEXT EXERCISE"
    }
}
```

**Example Scenario:**
```
Action 1: exerciseId="top-down"
Action 2: exerciseId="normal"
→ "NEXT EXERCISE" (different exercise)
```

**UI Behavior:**
- "Start" button show hota hai (user must click)
- Countdown: 0 seconds (immediate start when clicked)

---

### "ADD ONE WEIGHT"
**When shown:**
- Jab next action ka `weight` value increase ho
- Weight progression

**Code:**
```dart
void _moveToNextAction() {
    final newAction = _dayProtocol[currentIndex + 1];
    
    if (newAction.weight != _currentAction!.weight) {
        _notifyWeightSwitch = true;  // Show "ADD ONE WEIGHT"
    }
}
```

**Example Scenario:**
```
Action 2: exerciseId="normal", weight=0
Action 3: exerciseId="normal", weight=1
→ "ADD ONE WEIGHT" (weight increased)
```

**Countdown:**
- 30 seconds countdown
- User can pause/continue

---

### "SWITCH SIDES"
**When shown:**
- Jab next action ka `dominant` value different ho
- Side change required

**Code:**
```dart
void _moveToNextAction() {
    final newAction = _dayProtocol[currentIndex + 1];
    
    if (newAction.dominant != _currentAction!.dominant) {
        _notifySideSwitch = true;  // Show "SWITCH SIDES"
    }
}
```

**Example Scenario:**
```
Action 3: exerciseId="normal", dominant=true (right hand)
Action 4: exerciseId="normal", dominant=false (left hand)
→ "SWITCH SIDES" (side changed)
```

**Countdown:**
- 20 seconds countdown
- User can pause/continue

---

## 4. Complete Action Flow Example

### Example: Level 1 Actions Sequence

```
Action 0:
  exerciseId: "top-down"
  count: 3
  dominant: false
  weight: 0
  requiresInput: true
  → Notification: "PREPARE TO SWING"
  → 3 swings, left hand, no weight

Action 1:
  exerciseId: "top-down"
  count: 3
  dominant: false
  weight: 0
  → Notification: "PREPARE TO SWING" (same exercise)
  → 3 swings, left hand, no weight

Action 2:
  exerciseId: "normal"
  count: 3
  dominant: false
  weight: 0
  → Notification: "NEXT EXERCISE" (different exerciseId)
  → 3 swings, left hand, no weight

Action 3:
  exerciseId: "normal"
  count: 3
  dominant: false
  weight: 1
  → Notification: "ADD ONE WEIGHT" (weight increased)
  → 3 swings, left hand, 1 weight

Action 4:
  exerciseId: "normal"
  count: 3
  dominant: true
  weight: 1
  → Notification: "SWITCH SIDES" (dominant changed)
  → 3 swings, right hand, 1 weight

Action 12:
  exerciseId: "normal"
  count: 5
  dominant: true
  weight: 2
  requiresInput: true
  allowDriver: true
  → Notification: "PREPARE TO SWING"
  → 5 swings, right hand, 2 weights or driver
```

---

## 5. Adding New Exercise at First Position

### Scenario: Level mein naya exercise add karna jo sabse pehle aaye

### Step 1: Create Exercise Document
```
exercise/new-exercise-name/
  ├── title: "New Exercise Name"
  ├── videoId: "youtube_video_id"
  └── ...
```

### Step 2: Add Action at Position 0

**Option A: Insert at Beginning (Recommended)**
```
protocol/level1/actions/
  ├── 0/  ← NEW ACTION (shift existing)
  │   ├── exerciseId: "new-exercise-name"
  │   ├── count: 3
  │   ├── dominant: false
  │   └── weight: 0
  ├── 1/  ← Previously 0, now shifted
  ├── 2/  ← Previously 1, now shifted
  └── ...
```

**Firestore Console Steps:**
1. Go to `protocol/level1/actions/`
2. Click "Add document"
3. Document ID: `0` (or use auto-ID and rename)
4. Add fields:
   - `exerciseId: "new-exercise-name"`
   - `count: 3`
   - `dominant: false`
   - `weight: 0`
   - `requiresInput: false`
   - `allowDriver: false`

**Option B: Renumber Existing Actions**
```
Before:
  actions/0, 1, 2, 3... 12

After adding new at 0:
  actions/0 (NEW), 1 (old 0), 2 (old 1), 3 (old 2)...
  
Need to:
  1. Rename all existing documents
  2. Or use negative numbers: -1, 0, 1, 2...
```

**Flutter Code (Auto-sort):**
```dart
// training_repo.dart
actions.sort((a, b) {
    final aId = int.tryParse(a['id'] ?? '0') ?? 0;
    final bId = int.tryParse(b['id'] ?? '0') ?? 0;
    return aId.compareTo(bId);  // Sorts numerically
});
```

### Step 3: Update Exercise Collection
```
exercise/new-exercise-name/
  ├── title: "New Exercise Name"
  ├── videoId: "youtube_video_id"
  └── allowDriver: false
```

### Step 4: Test
- Load protocol data
- Verify new exercise appears first
- Check "Coming up" section shows new exercise

---

## 6. Duration Calculation - Complete Logic

### When `count > 0` (Swing-based):
**Duration = count × (swing_time + rest_time)**

**Example:**
```
Action: count=3, rest=15s
Duration = 3 × (5s swing + 15s rest) = 60 seconds
```

**Calculation:**
- Swing time: ~5 seconds per swing
- Rest time: 15 seconds (default between swings)
- Total: `count × 20 seconds`

### When `count = 0` OR `time > 0` (Timer-based):
**Duration = durationSeconds OR time field**

**Source:**
1. **Action document:**
   ```
   protocol/level1/actions/X/
     ├── count: 0
     └── durationSeconds: 60  ← Timer duration
   ```

2. **Exercise document:**
   ```
   exercise/{exerciseId}/
     └── time: 60  ← Timer duration
   ```

**iOS Code:**
```swift
// ProtocolAction.swift
if let duration = object["durationSeconds"] as? Int {
    self.exerciseType = .timed(seconds: duration)
    // Timer-based exercise
}
```

**Flutter Code:**
```dart
// ExerciseData
int time;  // If > 0, timer-based

// training_active_controller.dart
int _getActionCount(ExerciseData action) {
    // If time > 0, it's timer-based (1 action)
    if (action.time > 0) return 1;
    // Otherwise use count
    return action.count > 0 ? action.count : 5;
}
```

**Timer Countdown Source:**
- **Action level:** `durationSeconds` field
- **Exercise level:** `time` field in ExerciseData
- **Default:** If both missing, use count-based logic

**Example:**
```
Action 5:
  count: 0
  durationSeconds: 60
  → 60 seconds timer countdown
  → Shows: 60, 59, 58... 1, 0
```

---

## 7. Complete Parameter Priority

### Notification Priority:
1. **Exercise Change** (`exerciseId` different) → "NEXT EXERCISE"
2. **Weight Change** (`weight` different) → "ADD ONE WEIGHT"
3. **Side Change** (`dominant` different) → "SWITCH SIDES"
4. **Default** → "PREPARE TO SWING"

### Countdown Duration:
1. **Weight Switch** → 30 seconds
2. **Side Switch** → 20 seconds
3. **Default** → 15 seconds

### Exercise Type:
1. **Timer-based:** `count = 0` OR `durationSeconds > 0` OR `time > 0`
2. **Swing-based:** `count > 0` AND no timer fields

---

## 8. Flutter Implementation Checklist

### When Loading Actions:
```dart
✅ Fetch protocol/level1 document
✅ Fetch protocol/level1/actions subcollection
✅ Sort actions by document ID (numerically)
✅ For each action, fetch exercise using exerciseId
✅ Attach exercise to action
✅ Build DayProtocol with actions
```

### When Processing Actions:
```dart
✅ Check if exerciseId changed → "NEXT EXERCISE"
✅ Check if weight changed → "ADD ONE WEIGHT"
✅ Check if dominant changed → "SWITCH SIDES"
✅ Default → "PREPARE TO SWING"
✅ Use count or time for action count
✅ Show appropriate countdown duration
```

### When Adding New Exercise:
```dart
✅ Create exercise document in exercise collection
✅ Add action document in protocol/level1/actions/
✅ Use document ID "0" for first position
✅ Or use negative numbers: -1, 0, 1, 2...
✅ Ensure actions are sorted numerically
✅ Test that new exercise appears first
```

---

## 9. Summary Table

| Parameter | Type | Required | Default | Purpose |
|-----------|------|----------|---------|---------|
| `exerciseId` | String | Yes | - | Exercise identifier |
| `count` | Int | Yes | 5 | Number of swings (0 = timer) |
| `dominant` | Bool? | No | null | Dominant side (true/false/null) |
| `weight` | Int | No | 0 | Number of weights (0-3) |
| `requiresInput` | Bool | No | false | Speed input required |
| `allowDriver` | Bool | No | false | Driver club allowed |
| `durationSeconds` | Int? | No | null | Timer duration (if count=0) |

### Notification Logic:
- **Exercise change** → "NEXT EXERCISE" (0s countdown, Start button)
- **Weight change** → "ADD ONE WEIGHT" (30s countdown)
- **Side change** → "SWITCH SIDES" (20s countdown)
- **Default** → "PREPARE TO SWING" (15s countdown)

### Duration Logic:
- **count > 0** → Swing-based: `count × (swing_time + rest_time)`
- **count = 0** OR **time > 0** → Timer-based: Use `durationSeconds` or `time` field

---

## 10. Examples from Screenshots

### Action 0:
```
exerciseId: "top-down"
count: 3
dominant: false
weight: 0
→ 3 swings, left hand, no weight
→ "PREPARE TO SWING"
```

### Action 12:
```
exerciseId: "normal"
count: 5
dominant: true
weight: 2
requiresInput: true
allowDriver: true
→ 5 swings, right hand, 2 weights or driver
→ Speed input required
→ "PREPARE TO SWING"
```

### Action with Timer:
```
exerciseId: "warm-up"
count: 0
durationSeconds: 60
→ 60 seconds timer
→ Timer countdown: 60, 59, 58... 1, 0
```

---

Yeh complete guide hai sabhi parameters, notifications, aur duration logic ke liye. Koi specific scenario par aur detail chahiye?



