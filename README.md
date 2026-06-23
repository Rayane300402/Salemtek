# Salemtek

A Pill Reminder App

## Getting Started

Will provide a web view to see its full design without needing to set up here: 

## Checklist

- [x] Build Model for medicine
  - [x] Image (from assets)
  - [x] Title
  - [x] Dosage
  - [x] reason (optional)
  - [x] notification reminder (every .... )
  - [x] start - end date
  - [x] date_created
  - [x] date_deleted
  - [x] date_modified

- [x] Set up reminder unit (day, week, month, year)

- [ ] Work on pill card
  - [x] Image to discern type
  - [x] name of medicine
  - [x] quantity
  - [x] reminders
  - [x] Left to right swip shows delete button (extreme swip deletes, a small swipe only shows btn)
  - [x] Right to left swipe shows edit btn or completed consumption (only shows edit, but excessive for completed swipes and removes as completed)
  - [x] Create a global toast for delete and complete
  - [x] add edit and complete (if allowed to complete) and delete (if allowed to delete) in the 3 dot menu for user who would prefer to click than swipe
  - [ ] better animation
  - [x] center No medicine for this date and rephrase it to smth cuter

- [x] Set up Settings architecture
  - [x] Added `AppSettings` entity
    - stores:
      - `notificationsEnabled`
      - `excessiveRemindersEnabled`
      - `excessiveReminderMinutes`
    - added defaults + `copyWith`
  - [x] Added `SettingsModel`
    - maps between data layer and domain entity
  - [x] Added `SettingsRepo` contract
    - `getSettings`
    - `updateSettings`
    - `resetSettings`
  - [x] Added `SettingsRepoImpl`
    - connects settings datasource to domain repo
  - [x] Added `SettingsLocalDataSource`
    - backed by a single-row SQLite `settings` table
  - [x] Added `SettingsUseCases`
    - grouped settings actions into one usecase file
  - [x] Added `SettingsCubit` + `SettingsState`
    - manages:
      - current settings values
      - current visible settings section
      - loading/error state

- [x] Wired Settings into dependency injection
  - [x] Registered settings datasource in service locator
  - [x] Registered settings repo in service locator
  - [x] Registered settings usecases in service locator
  - [x] Registered `SettingsCubit` in service locator
  - [x] Made `SettingsCubit` depend on:
    - settings usecases
    - medicine repo
    - medicine cubit

- [x] Set up Settings UI shell
  - [x] Reused the same white rounded container layout as Home/Cabinet
  - [x] Kept root settings page with:
    - Data
    - Notification
  - [x] Added animated in-page subsection navigation
    - root -> data section
    - root -> notification section
    - subsection -> back to root
  - [x] Added subsection header with back button

- [x] Added Data section
  - [x] Restore Data
    - restores all medicines where `dateDeleted != null`
    - sets deleted items back to active
    - reloads medicine cubit so UI updates immediately
  - [x] Hard Reset
    - permanently deletes all medicines
    - resets settings to defaults
    - designed to later clear stats too
    - added confirmation dialog before running

- [x] Added Notification section
  - [x] Notifications toggle
    - updates UI
    - persists setting locally
    - no real notification behavior yet
  - [x] Excessive reminder toggle
    - updates UI
    - persists setting locally
    - no real notification behavior yet
  - [x] Repeat interval dropdown
    - stores repeat-every-X-minutes value
    - prepared for future reminder repetition logic

- [x] Expanded medicine data actions for Settings support
  - [x] Added `restoreAllMedicines`
    - to medicine repo contract
    - to medicine datasource
    - to medicine repo implementation
  - [x] Added `hardDeleteAllMedicines`
    - to medicine repo contract
    - to medicine datasource
    - to medicine repo implementation

- [x] Connected Settings with medicine state
  - [x] Settings restore action reloads `MedicineCubit`
  - [x] Settings hard reset reloads `MedicineCubit`
  - [x] keeps UI in sync after data actions

- [x] Settings persisted in SQLite
  - [x] one local `settings` table
  - [x] single-row design (`id = 0`)
  - [x] columns:
    - `notificationsEnabled`
    - `excessiveRemindersEnabled`
    - `excessiveReminderMinutes`

- [x] Local Database (SQLite)
  - [x] Switched persistence from in-memory / JSON to a real on-device SQLite database
  - [x] `sqflite` on mobile + `sqflite_common_ffi` for Windows/desktop dev
  - [x] One shared connection opened once at startup (`salemtek.db`)
  - [x] Clean `lib/data/local/` layer
    - `app_database.dart` — open, version, `onCreate`, `onUpgrade`
    - `database_schema.dart` — table names + `CREATE TABLE` / index statements
    - `migrations.dart` — append-only, versioned migrations
    - `dev_seeder.dart` — dev-only dummy data, behind `kSeedDevData`
  - [x] Tables (typed columns: dates as epoch millis, bools as 0/1, enums as text)
    - `medicines`
    - `statistics`
    - `settings` (single row)
  - [x] Indexes for fast loads
    - `medicines.dateDeleted`
    - `statistics.actionDate`
    - `statistics.medicineId`
  - [x] Only the 3 datasource impls changed — repos / usecases / cubits / UI untouched
  - [x] Models map via `toMap` / `fromMap` (replaced `toJson` / `fromJson`)
  - [x] Idempotent statistics via `INSERT OR REPLACE` on the composite id
  - [x] Starts empty in production; flip `kSeedDevData` for a populated demo history
  - [x] "Handled today" derives from the statistics table (single source of truth)
  - [ ] Add a feature later: bump `AppDatabase` version + append a `kMigrations` entry
  - [ ] Future: foreign keys / cascade, push stat filters into SQL, statistics export

- [x] Set up Drug Cabinet
  - [x] same card as home
  - [x] has option to delete shown

- [x] Stop showing intro if user clicks start

- [ ] Add Splash Screen

- [x] Cabinet search/create setup
  - [x] Update `CustomHeader`
    - [x] support optional primary icon action
    - [x] support optional search icon action
    - [x] keep existing pages working without changes
  - [x] Update Cabinet header
    - [x] search icon for future medicine search
    - [x] add icon opens create medicine view
  - [x] Create blank create/edit medicine sheet
    - [x] slides up from bottom
    - [x] uses white rounded top container
    - [x] no form logic yet
  - [x] Add medicine search
    - [x] search by medicine name
    - [x] search by medicine type/dosage text

- [ ] Create/Edit Medicine UI
  - [ ] Shared screen/component
    - [ ] `CreateEditMedicine` handles both create and edit
    - [x] accepts optional `Medicine? medicine`
    - [ ] create mode when medicine is null
    - [ ] edit mode when medicine exists
    - [x] button text changes:
      - [x] Create
      - [x] Update
    - [ ] button closes sheet for now
    - [ ] no save/update logic yet

  - [ ] Medicine type selector
    - [x] horizontal scroll selector
    - [x] selected item is centered/emphasized
    - [x] selection affects:
      - [x] displayed image
      - [x] name field leading image
    - [ ] supported types:
      - [x] pill
      - [x] capsule
      - [x] injection/syringe
      - [x] drip/IV drip
      - [x] cream
      - [x] inhaler
      - [x] powder/sachet
      - [x] bandage/wound care
      - [x] liquid
      - [x] drops
      - [x] suppository

  - [x] Medicine name section
    - [x] title: Name
    - [x] rounded input container
    - [x] leading image based on selected medicine type
    - [x] text field for medicine name
    - [x] prefilled in edit mode

  - [x] Reason section
    - [x] title: Reason
    - [x] optional multiline text field
    - [x] rounded large input container
    - [x] prefilled in edit mode
    - [x] can be empty

  - [x] Notification section
    - [x] title: Notification
    - [x] create notification option model
      - [x] none
      - [x] every day
      - [x] every X days
      - [x] every week
      - [x] every X weeks
      - [x] every month
      - [x] every X months
    - [x] dropdown for reminder type
    - [x] show custom X input only for:
      - [x] every X days
      - [x] every X weeks
      - [x] every X months
    - [x] hide custom X input for:
      - [x] none
      - [x] every day
      - [x] every week
      - [x] every month
    - [x] X value must be friendly and adjustable
      - [x] numeric input
      - [x] prevent zero/negative values
      - [x] show unit label based on selected option
        - [x] days
        - [x] weeks
        - [x] months
    - [x] selected reminder affects preview text later
      - [x] Every day
      - [x] Every 2 days
      - [x] Every week
      - [x] Every 3 weeks
      - [x] Every month
      - [x] Every 2 months
    - [ ] prefilled in edit mode later
    - [x] UI-only for now
    - [ ] later map notification option to medicine reminder fields

  - [x] Dosage section
    - [x] title: Dosage
    - [x] dosage UI changes based on medicine type
    - [x] examples:
      - [x] pill: 1 pill, 2 pills
      - [x] capsule: 1 capsule, 2 capsules
      - [x] injection: 1 injection
      - [x] inhaler: 1 puff, 2 puffs
      - [x] cream: apply once, apply twice
      - [x] powder/sachet: 1 sachet, 2 sachets
      - [x] liquid: ml-based or spoon-based
      - [x] drops: 1 drop, 2 drops
      - [x] suppository: 1 suppository
      - [x] bandage: apply/change once
      - [x] drip: 1 drip/session
    - [x] prefilled in edit mode

  - [x] Date section
    - [x] title: Date
    - [x] start date is required
    - [x] end date is optional
    - [x] rounded date buttons
    - [x] prefilled in edit mode
    - [x] empty end date means long-term/permanent medicine

  - [x] Submit button
    - [x] large rounded primary button
    - [x] create mode text: Create
    - [x] edit mode text: Update
    - [x] closes bottom sheet for now
    - [ ] no database/cubit mutation yet

  - [ ] Future data/model considerations
    - [x] medicine type should become a real field in `Medicine`
    - [x] dosage should probably become structured, not only string
    - [x] notification can stay structured using reminder unit/every value
    - [ ] dosage history may be needed later for accurate stats
    - [ ] completion/stats should eventually store exact dosage taken at that time
  
  - [x] Medicine Details View
    - [x] Open from three-dot menu
    - [x] Bottom sheet with rounded top corners
    - [ ] Show all medicine information
    - [x] Include optional reason text
    - [x] Reusable from Home and Cabinet

- [ ] Statistics Page
  - [x] Statistics data foundation
    - [x] Create local statistics table/data source
    - [x] Store one record for every medicine action
      - [x] completed
      - [x] skipped
    - [x] Required fields
      - [x] id
      - [x] medicineId
      - [x] medicineType
      - [x] dosageAmount
      - [x] actionType (completed / skipped)
      - [x] actionDate
      - [x] dateCreated
    - [x] Keep historical data even if medicine is edited later
    - [x] Remove statistics during hard reset
    - [x] Preserve statistics during soft delete
    - [x] Optional future export support

  - [x] Domain layer
    - [x] Create `MedicineStatistic` entity
    - [x] Create model with SQLite (`toMap` / `fromMap`) support
    - [x] Create statistics repository
    - [x] Create statistics use cases

  - [x] Statistics Cubit
    - [x] Load statistics
    - [x] Apply filters
    - [x] Compute summary values
    - [x] Compute chart data
    - [x] Compute achievements

  - [x] Header filters
    - [x] Medicine filter dropdown
      - [x] All medicines
      - [x] Optional future filter by medicine type
    - [x] Time filter dropdown
      - [x] Specific month and year
      - [x] Entire year
      - [x] Lifetime
      - [x] Only list past months that have data
    - [x] Refresh button
      - [x] Recalculate statistics

  - [x] Summary cards
    - [x] Streak
      - [x] Number of consecutive days with at least one completed medicine
      - [x] Reset when a day has no completed medicines
    - [x] Consistency (action-based for now)
      - [x] Percentage of completed actions
      - [x] Formula:
        - [x] completed doses / (completed + skipped) × 100
        - [ ] scheduled-based formula later (needs scheduled-dose calc)

  - [ ] Progress section
    - [x] Title: Progress

    - [x] Progress overview container
      - [x] Horizontal layout
      - [x] Fixed height
      - [x] Holds circle + medicine legend
      - [x] Prevent full-height expansion

    - [x] Completion percentage circle
      - [x] Show completion percentage (action-based)
      - [x] Respect current medicine and date filters
      - [ ] Animated percentage later
      - [x] Progress ring around the circle

    - [x] Medicine legend
      - [x] Show medicine icon and title
      - [x] Display only medicines included in current filter
      - [x] Scrollable vertical list
      - [x] Fixed max height
      - [ ] Custom scrollbar styling later

    - [x] Progress chart section
      - [x] Add `fl_chart` package
      - [x] Create progress line chart component
      - [x] Show one line per medicine/type
      - [x] X-axis adapts to selected period
        - [x] Month → days
        - [x] Year → months
        - [x] Lifetime → years
      - [x] Y-axis = doses completed
      - [x] Respect current filters

    - [x] Dose tracking — action-based (current approach)
      - [x] Count recorded actions instead of computing a schedule
      - [x] Each Complete / Skip on Home writes one statistic record
      - [x] Consistency = completed / (completed + skipped)
      - [x] Chart Y-axis = completed records per period bucket
      - [ ] Scheduled-dose calculation (future — for a true adherence %)
        - [ ] Expected doses from start/end date + reminder interval + unit
        - [ ] Daily / weekly / monthly reminders
        - [ ] Ignore dates outside the active range; permanent meds continue indefinitely

    - [x] Achievements section
      - [x] Title: Achievements
      - [x] Achievement cards for medicine mastery

      - [x] Type-specific achievements — all 11 MedicineTypes (art ✓)
        - [x] Pill Keeper — pill
        - [x] Capsule Guardian — capsule
        - [x] Injection Inspector — injection
        - [x] Cream Captain — cream
        - [x] Liquid Legend — liquid
        - [x] Sachet Specialist — powder
        - [x] Puff Pro — inhaler
        - [x] Bandage King — bandage
        - [x] Drip Master — drip (IV Drip)
        - [x] Drop Doctor — drop
        - [x] Suppository Sentinel — suppository

      - [x] General / secret achievements
        - [x] Healer — secret · unlocks at more than 5 different medicine types · hidden until earned
        - [ ] First Dose (future)
        - [ ] 7-Day Streak (future)
        - [ ] 30-Day Streak (future)
        - [ ] 100% Monthly Consistency (future)

      - [x] Unlock rules
        - [x] Type achievements: more than 20 completions of that type (times taken — not pills/dosage)
        - [x] Healer: more than 5 different medicine types
        - [ ] Multi-tier thresholds later (10 / 50 / 100)

      - [x] Visual states
        - [x] Locked → hidden (not shown — keeps the full set a surprise)
        - [x] Unlocked → full color

      - [x] Statistics action recording
        - [x] Record completed medicine actions
        - [x] Record skipped medicine actions
        - [x] Create statistic entry from Home page interactions
        - [x] Refresh statistics automatically after action
        - [x] Prevent duplicate records for same medicine/date/action
        - [x] Home hides a medicine once handled — derived from the statistics table (survives restart)
        - [ ] Future:
          - [ ] allow editing action status
          - [ ] allow removing mistaken records

      - [x] Empty states
        - [x] No statistics available
        - [x] No data for selected filters
        - [x] No achievements unlocked yet

    - [x] Hard reset integration
      - [x] Delete all statistics
      - [x] Reset streaks
      - [x] Reset achievements

    - [ ] Future enhancements
      - [ ] Export statistics
      - [ ] Share achievements
      - [ ] Weekly reports
      - [ ] Monthly reports
      - [ ] Personalized insights