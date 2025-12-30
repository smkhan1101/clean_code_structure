# Actions aur Exercises - Complete Explanation

## Database Structure (Firestore)

```
protocol/
  └── level1/                    ← Level document
      ├── durationDays: 12       ← Level ki total days
      ├── videoId: "DkY4p9061VQ" ← Level ka tutorial video
      └── actions/               ← Actions subcollection
          ├── 0/                 ← Action document (step 1)
          │   ├── exerciseId: "top-down"
          │   ├── count: 3
          │   ├── dominant: false
          │   ├── weight: 0
          │   ├── requiresInput: true
          │   └── allowDriver: false
          ├── 1/                 ← Action document (step 2)
          │   ├── exerciseId: "top-down"
          │   ├── count: 3
          │   ├── dominant: false
          │   └── weight: 0
          ├── 12/                ← Action document (step 13)
          │   ├── exerciseId: "normal"
          │   ├── count: 5
          │   ├── dominant: true
          │   ├── weight: 2
          │   └── requiresInput: true
          └── ...

exercise/                        ← Exercises collection (separate)
    ├── top-down/               ← Exercise document
    │   ├── title: "Top Down Swing"
    │   └── videoId: "xyz123"
    ├── normal/                 ← Exercise document
    │   ├── title: "Normal Swing"
    │   └── videoId: "abc456"
    └── ...
```

---

## Key Concepts

### 1. **Actions vs Exercises**

**Actions** = Training steps (protocol/level1/actions/0, 1, 2...)
- Actions define **KAISE** exercise perform karna hai
- Har action ek exercise ko reference karta hai via `exerciseId`
- Actions mein parameters hote hain: `count`, `dominant`, `weight`, etc.

**Exercises** = Exercise types (exercise/top-down, normal, etc.)
- Exercises define **KONSA** exercise hai
- Exercise mein basic info hoti hai: `title`, `videoId`
- Same exercise multiple actions mein use ho sakta hai with different parameters

### Example:
```
Action 0: exerciseId="top-down", count=3, dominant=false, weight=0
Action 1: exerciseId="top-down", count=3, dominant=false, weight=0
Action 12: exerciseId="normal", count=5, dominant=true, weight=2
```

Yahan:
- Action 0 aur 1 dono same exercise ("top-down") use kar rahe hain
- But Action 12 different exercise ("normal") use kar raha hai
- Har action ka apna `count`, `dominant`, `weight` hai

---

## 2. **Exercise Fetching Process (iOS Code se)**

### Step-by-Step Flow:

```swift
// 1. Get Protocol (Level document)
protocol/level1 → durationDays, videoId

// 2. Get All Actions (Actions subcollection)
protocol/level1/actions → [0, 1, 2, 3... 12]

// 3. For Each Action, Get Exercise
For each action:
  - Read exerciseId from action (e.g., "top-down")
  - Fetch exercise document: exercise/{exerciseId}
  - Attach exercise to action

// 4. Result: DayProtocol with actions containing exercises
DayProtocol {
  actions: [
    ProtocolAction(id: "0", exerciseId: "top-down", exercise: Exercise(...)),
    ProtocolAction(id: "1", exerciseId: "top-down", exercise: Exercise(...)),
    ProtocolAction(id: "12", exerciseId: "normal", exercise: Exercise(...))
  ]
}
```

### iOS Code Reference:

**DatabaseManager.swift:**
```swift
func getProtocol(withTimelineState timelineState: TimelineState, completion: @escaping (DayProtocol?) -> ()) {
    // 1. Get level document
    let docId = "level\(timelineState.level)"
    self.firestoreReference.collection("protocol").document(docId).getDocument { document, error in
        // 2. Create DayProtocol from document
        guard let dayProtocol = DayProtocol(from: document.data() ?? [:], withId: docId) else { return }
        
        // 3. Get all actions
        self.firestoreReference.collection("protocol").document(docId)
            .collection("actions").getDocuments { snapshot, error in
                // 4. For each action, fetch exercise
                for document in snapshot.documents {
                    guard let action = ProtocolAction(from: document.data(), withId: document.documentID) else { continue }
                    
                    // 5. Fetch exercise using exerciseId
                    self.get(exerciseWithId: action.exerciseId) { exercise in
                        action.exercise = exercise  // Attach exercise to action
                        dayProtocol.actions.append(action)
                    }
                }
            }
    }
}
```

---

## 3. **Field Meanings**

### `exerciseId` (String)
- **Kya hai**: Exercise ka unique identifier
- **Kahan se aata hai**: Action document se (`protocol/level1/actions/0/exerciseId`)
- **Kya karta hai**: Exercise document ko fetch karne ke liye use hota hai
- **Example**: `"top-down"`, `"normal"`, `"driver"`

### `count` (Int)
- **Kya hai**: Kitne swings/repetitions perform karne hain
- **Values**: Usually 3, 5, or time-based
- **Example**: 
  - `count: 3` = 3 swings
  - `count: 5` = 5 swings
  - `count: 0` or time-based = Timer-based exercise

**iOS Code:**
```swift
// TrainingActiveViewModel.swift
var actionCount: Int {
    guard let currentAction else { return 5 }
    if case .timed(let seconds) = currentAction.exerciseType {
        return 1  // Timer-based = 1 action
    }
    return currentAction.count  // Otherwise use count
}
```

### `dominant` (Bool?)
- **Kya hai**: Dominant side (right/left hand) use karna hai ya nahi
- **Values**: 
  - `true` = Dominant side (right hand for right-handed)
  - `false` = Non-dominant side (left hand for right-handed)
  - `null` = Doesn't matter / both sides

**Example:**
- Action 0: `dominant: false` = Left hand swing
- Action 12: `dominant: true` = Right hand swing

**Display:**
```swift
// ProtocolAction.swift
func swingParametersDescription() -> String {
    if let dominant {
        result += dominant ? "Dominant" : "Non-dominant"
    }
    // Shows: "Dominant, 2 weights" or "Non-dominant, zero weights"
}
```

### `weight` (Int)
- **Kya hai**: Kitne weights add karne hain
- **Values**: 0, 1, 2, 3
- **Example**:
  - `weight: 0` = No weights
  - `weight: 1` = 1 weight
  - `weight: 2` = 2 weights

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

### `requiresInput` (Bool)
- **Kya hai**: User se speed input chahiye ya nahi
- **Values**: `true` = Speed input required, `false` = Not required
- **Use**: Radar enabled users ke liye speed measurement

### `allowDriver` (Bool)
- **Kya hai**: Driver club use kar sakte hain ya nahi
- **Values**: `true` = Driver allowed, `false` = Driver not allowed

---

## 4. **Duration Calculation**

### Level Duration:
- **Source**: `protocol/level1/durationDays`
- **Value**: 12 days per level
- **Use**: Total days in a level

### Training Session Duration:
- **Calculation**: Sum of all action durations
- **Each Action Duration**:
  - If `count > 0`: `count * (swing_time + rest_time)`
  - If timer-based: Use `durationSeconds` from action
  - Rest time between swings: 15 seconds (default)

**Example:**
```
Action 0: count=3, rest=15s → 3 swings + 2 rests = ~45 seconds
Action 1: count=3, rest=15s → 3 swings + 2 rests = ~45 seconds
Action 12: count=5, rest=15s → 5 swings + 4 rests = ~75 seconds

Total: ~15 minutes (estimated)
```

**iOS Code:**
```swift
// TrainingView.swift
@ViewBuilder var timeToCompleteView: some View {
    Text("Around 15 minutes.")  // Hardcoded estimate
}
```

---

## 5. **"Coming up" Exercises Display**

### How Unique Exercises are Found:

**iOS Code (DayProtocol.swift):**
```swift
var exercises: [Exercise] {
    var result = [Exercise]()
    for action in actions {
        if let exercise = action.exercise,
           !result.contains(where: { $0.id == exercise.id }) {
            result.append(exercise)
        }
    }
    return result
}
```

**Process:**
1. Loop through all actions
2. Extract exercise from each action
3. Check if exercise already in result (by `id`)
4. If not, add to result
5. Return unique exercises list

**Example:**
```
Actions: [
  Action 0: exerciseId="top-down" → Exercise("top-down", "Top Down Swing")
  Action 1: exerciseId="top-down" → Exercise("top-down", "Top Down Swing")  // Duplicate
  Action 2: exerciseId="normal" → Exercise("normal", "Normal Swing")
  Action 12: exerciseId="normal" → Exercise("normal", "Normal Swing")  // Duplicate
]

Result: [
  Exercise("top-down", "Top Down Swing"),
  Exercise("normal", "Normal Swing")
]
```

**Display:**
```
Coming up:
- Top Down Swing
- Normal Swing
```

---

## 6. **Day-wise Exercise Changes**

### Important: Actions are Level-based, NOT Day-based!

**Current Structure:**
- `protocol/level1/actions/` contains ALL actions for Level 1
- Actions are NOT separated by day
- Same actions are used for ALL days in a level

**How Days Work:**
- `durationDays: 12` means Level 1 has 12 days
- But actions (0, 1, 2... 12) are same for all days
- Day progression is just a counter, not a filter

**If You Want Different Exercises Per Day:**
You would need to structure it like:
```
protocol/
  └── level1/
      ├── day1/
      │   └── actions/ [0, 1, 2...]
      ├── day2/
      │   └── actions/ [0, 1, 2...]  // Different actions
      └── ...
```

**But Current Structure:**
```
protocol/
  └── level1/
      ├── durationDays: 12
      └── actions/ [0, 1, 2... 12]  // Same for all 12 days
```

**Conclusion:**
- **Same exercises** for all days in a level
- Day number is just for **tracking progress**
- Actions don't change based on day number

---

## 7. **Video ID Handling**

### Level Video:
- **Source**: `protocol/level1/videoId`
- **Use**: Training screen par tutorial video
- **Example**: `"DkY4p9061VQ"`

### Exercise Video:
- **Source**: `exercise/{exerciseId}/videoId`
- **Use**: Training active screen par exercise-specific video
- **Example**: `exercise/top-down/videoId = "xyz123"`

### Video Change Logic:

**Training Screen (Setup):**
- Shows level video: `protocol/level1/videoId`

**Training Active Screen:**
- Shows exercise video: `currentAction.exercise.videoId`
- Video changes when exercise changes

**iOS Code:**
```swift
// TrainingActiveView.swift
@ViewBuilder var tutorialView: some View {
    if let videoId = viewModel.currentAction?.exercise?.videoId {
        YoutubeVideoView(youtubeVideoID: videoId)
    }
}
```

**Flutter Fix Needed:**
- Use `ValueKey('video_$videoId')` to force widget rebuild
- Update video controller when `currentAction.exercise.videoId` changes

---

## 8. **Action Processing Flow**

### During Training:

```
1. Load Protocol
   ↓
2. Get Actions [0, 1, 2... 12]
   ↓
3. For Each Action:
   - Fetch Exercise using exerciseId
   - Attach Exercise to Action
   ↓
4. Start Training:
   - Action 0: exercise="top-down", count=3, dominant=false
   - Perform 3 swings
   - Countdown 15 seconds
   ↓
5. Next Action:
   - Action 1: exercise="top-down", count=3, dominant=false
   - Perform 3 swings
   - Countdown 15 seconds
   ↓
6. Continue until all actions complete
```

### Action Comparison Logic:

**iOS Code (TrainingActiveViewModel.swift):**
```swift
func prepareNextSwing() {
    if currentSwingNo >= currentAction.count - 1 {
        // Move to next action
        let newAction = dayProtocol.actions[currentIndex + 1]
        
        // Check what changed
        if newAction.exerciseId != currentAction.exerciseId {
            notifyExerciseSwitch = true  // Different exercise
        } else if newAction.weight != currentAction.weight {
            notifyWeightSwitch = true   // Weight changed
        } else if newAction.dominant != currentAction.dominant {
            notifySideSwitch = true     // Side changed
        }
    }
}
```

---

## 9. **Flutter Implementation**

### Current Flutter Code Issues:

1. **"Coming up" Exercises:**
   - ✅ Fixed: Now extracts unique exercises from actions
   - Uses `exerciseId` to get unique exercise names

2. **Video Not Changing:**
   - ✅ Fixed: Added `ValueKey('video_$videoId')` to force rebuild
   - Video updates when `currentAction.exercise.videoId` changes

3. **Day Progression:**
   - ✅ Fixed: Updates `currentDay` after training completion
   - If `day > 12`, increments level and resets day

### Flutter Code Structure:

```dart
// training_repo.dart
Future<Map<String, dynamic>> getProtocolData(int level, int day) async {
  // 1. Get level document
  final protocolDoc = await FirebaseFirestore.instance
      .collection('protocol')
      .doc('level$level')
      .get();
  
  // 2. Get actions subcollection
  final actionsSnapshot = await FirebaseFirestore.instance
      .collection('protocol')
      .doc('level$level')
      .collection('actions')
      .get();
  
  // 3. Extract unique exerciseIds
  final exerciseIds = <String>{};
  for (final action in actionsSnapshot.docs) {
    final exerciseId = action.data()['exerciseId'] as String?;
    if (exerciseId != null) exerciseIds.add(exerciseId);
  }
  
  // 4. Fetch exercises
  final exercises = <ExerciseData>[];
  for (final exerciseId in exerciseIds) {
    final exerciseDoc = await FirebaseFirestore.instance
        .collection('exercise')
        .doc(exerciseId)
        .get();
    if (exerciseDoc.exists) {
      exercises.add(ExerciseData.fromJson(exerciseDoc.data()!));
    }
  }
  
  // 5. Build actions with exercises
  final actionsWithExercises = [];
  for (final actionDoc in actionsSnapshot.docs) {
    final actionData = actionDoc.data();
    final exerciseId = actionData['exerciseId'] as String?;
    final exercise = exercises.firstWhere((e) => e.id == exerciseId);
    
    actionsWithExercises.add({
      ...actionData,
      'exercise': exercise.toJson(),
    });
  }
  
  return {
    'exercises': exercises,  // Unique exercises for "Coming up"
    'actions': actionsWithExercises,  // All actions with exercises
    'videoId': protocolDoc.data()?['videoId'],
  };
}
```

---

## 10. **Summary**

### Key Points:

1. **Actions** = Training steps with parameters (count, dominant, weight)
2. **Exercises** = Exercise types (top-down, normal, etc.)
3. **exerciseId** = Link between action and exercise
4. **count** = Number of swings/repetitions
5. **dominant** = Which side to use (true/false)
6. **weight** = How many weights to add (0-3)
7. **Same exercises** for all days in a level
8. **Video changes** when exercise changes (not when action changes)
9. **Duration** = Estimated based on count and rest times
10. **"Coming up"** = Unique exercises extracted from actions

### Database Flow:

```
protocol/level1 (document)
  ├── durationDays: 12
  ├── videoId: "DkY4p9061VQ"
  └── actions/ (subcollection)
      ├── 0/ → exerciseId="top-down", count=3, dominant=false
      ├── 1/ → exerciseId="top-down", count=3, dominant=false
      └── 12/ → exerciseId="normal", count=5, dominant=true, weight=2

exercise/ (collection)
  ├── top-down/ → title="Top Down Swing", videoId="xyz"
  └── normal/ → title="Normal Swing", videoId="abc"
```

### Training Flow:

```
1. User selects Level 1, Day 1
2. Load protocol/level1
3. Load protocol/level1/actions (all actions)
4. For each action, fetch exercise using exerciseId
5. Display unique exercises in "Coming up"
6. Start training: Process actions sequentially
7. Each action: Perform count swings with given parameters
8. After completion: Increment day (or level if day > 12)
```

---

## 11. **Common Questions Answered**

**Q: Har day mein different exercises hote hain?**
A: Nahi, same exercises hote hain. Actions level-based hain, day-based nahi.

**Q: Count ka matlab kya hai?**
A: Kitne swings perform karne hain. Example: count=3 means 3 swings.

**Q: Dominant true/false ka kya matlab?**
A: true = Right hand (dominant), false = Left hand (non-dominant)

**Q: Exercise kaise find hota hai?**
A: Action se `exerciseId` read karo, phir `exercise/{exerciseId}` document fetch karo.

**Q: Video kahan se aata hai?**
A: Level video = `protocol/level1/videoId`, Exercise video = `exercise/{exerciseId}/videoId`

**Q: Duration kaise calculate hota hai?**
A: Estimated based on count × (swing_time + rest_time). Usually "Around 15 minutes" hardcoded.

**Q: "Coming up" mein kya show hota hai?**
A: Unique exercises extracted from all actions, duplicates removed.


