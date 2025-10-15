# Watch Sync Setup Instructions

The watch connectivity code has been created but needs to be added to your Xcode project.

## Steps to Enable Watch Syncing:

1. **Open Xcode**
2. **Add WatchConnectivityManager.swift to iOS Target:**
   - In Xcode, locate `WatchConnectivityManager.swift` in the Project Navigator (it should be in the zaCalc2 folder)
   - If you don't see it, drag the file from Finder into the Xcode project
   - Click on `WatchConnectivityManager.swift`
   - In the File Inspector (right sidebar), find "Target Membership"
   - **Check the box** next to `zaCalc2` (iOS app)
   - **Uncheck the box** next to `zaCalc2-watch Watch App` (watch app has its own copy)

3. **Uncomment the sync code in ContentView.swift:**
   - Open `ContentView.swift`
   - Find lines 96-99 (the commented .onAppear block)
   - Uncomment those lines

4. **Build and Run**
   - The app should now build successfully
   - Watch will automatically sync when:
     - Phone app launches
     - You press Calculate
     - You edit any recipe field
     - You press "Use this amount" in sourdough/baker's yeast screens
     - You change toppings size

## Files Created:
- `/zaCalc2/WatchConnectivityManager.swift` - iOS connectivity manager
- `/zaCalc2-watch Watch App/WatchConnectivityManager.swift` - Watch connectivity manager

## Files Modified:
- `ContentView.swift` - Initial sync on app launch
- `RecipeInputView.swift` - Sync on field changes and Calculate button
- `BakersYeastView.swift` - Sync on "Use this amount"
- `SourdoughCalculatorView.swift` - Sync on "Use this amount"
- `ToppingsView.swift` - Sync on toppings size change
- `zaCalc2-watch Watch App/ContentView.swift` - Use shared calculator data
- `zaCalc2-watch Watch App/zaCalc2_Watch_AppApp.swift` - Provide connectivity manager