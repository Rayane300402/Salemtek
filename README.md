# Salemtek

A medication reminder and adherence-tracking app built with Flutter. Track what you take, when you take it, and how consistently you actually take it — offline-first, no account, no server.

Built solo: product design, UI/UX, architecture, and implementation.

> **Status:** in active development. Scheduling, persistence, statistics, and achievements work end to end. Notification *delivery* is modelled and configurable but not yet wired to the OS — see [Roadmap](#roadmap).

---

## Screenshots

| Home | Cabinet | Create / Edit |
|:---:|:---:|:---:|
| ![Home](docs/screenshots/home.png) | ![Cabinet](docs/screenshots/cabinet.png) | ![Create](docs/screenshots/create.png) |

| Statistics | Settings |
|:---:|:---:|
| ![Statistics](docs/screenshots/stats.png) | ![Settings](docs/screenshots/settings.png) |

---

## Features

**Home — daily schedule**
- Horizontal date strip with the selected day emphasised
- "Today's Reminder" list showing only what is actually due on that date
- Swipe a card right to reveal delete, left to reveal edit or mark-as-taken; an extended swipe commits the action directly
- Every action available from a three-dot menu too, for users who would rather tap than swipe
- Once a medication is handled, it disappears for that day — derived from the statistics table, so it survives a restart

**Cabinet**
- Full medication list with search across name, type, and dosage text
- 11 medication types — pill, capsule, cream, injection, bandage, IV drip, drops, inhaler, liquid, powder, suppository — each with its own illustrated asset
- Soft delete with restore, so removing a medication never destroys its adherence history

**Create / edit**
- One screen handles both modes, driven by an optional `Medicine?`
- Horizontal type carousel where the centred selection drives the artwork throughout the form
- Dosage phrasing adapts to the type: *1 pill / 2 pills*, *1 puff / 2 puffs*, *apply once / apply twice*, *1 sachet / 2 sachets*
- Reminder builder covering every day, every _n_ days, every week, every _n_ weeks, every month, every _n_ months — the custom interval field appears only for the options that need it, and rejects zero and negative values
- Required start date, optional end date; an empty end date means an ongoing medication

**Statistics**
- Filter by medication and by period — a specific month, a full year, or lifetime; only months that actually contain data are listed
- **Streak**: consecutive days with at least one completed dose
- **Consistency**: completed ÷ (completed + skipped), stated as action-based rather than schedule-based, which is a deliberate simplification (see the build log)
- Completion ring plus an `fl_chart` line chart whose X-axis rebuckets by day, month, or year to match the selected period
- Achievements: 12-entry catalog across two rules — 20+ doses of a given type, and variety across 5+ distinct types. Locked achievements are hidden entirely rather than greyed out, so the full set stays a surprise

**Settings**
- **Data**: restore every soft-deleted medication, or hard reset — which wipes medications, statistics, and preferences behind a confirmation dialog
- **Notification**: master toggle, excessive-reminder toggle, and a repeat interval in minutes; all persisted, pending OS delivery
- Animated in-page navigation between the root and each subsection

**Onboarding**
- Paged introduction flow with its own scoped cubit, shown once and then never again

---

## Architecture

Clean Architecture. Dependencies point inward: `ui` depends on `domain`, `data` depends on `domain`, and `domain` depends on nothing — not on Flutter, not on `sqflite`.

```
lib/
├── domain/                  # Pure Dart. No Flutter, no sqflite, no I/O.
│   ├── entities/            # Medicine, Reminder, Settings, Achievement, MedicineStatistic
│   ├── repo/                # Repository contracts (abstract)
│   └── usecases/            # MedicineUseCases, StatisticsUseCases, SettingsUseCases
│
├── data/                    # Implements the domain contracts.
│   ├── local/               # app_database, database_schema, migrations
│   ├── sources/             # Local data sources (sqflite)
│   ├── repo/                # Repository implementations
│   └── models/              # Row <-> entity mapping
│
├── ui/
│   ├── bloc/                # Cubits: medicine, settings, statistics
│   ├── components/          # Reusable widgets (button, header, nav bar, card, toast, empty state)
│   └── pages/               # introduction/, main/{home, cabinet, create_edit, statistics, settings}
│
├── configs/                 # Theme, palette, asset catalogs
└── utils/                   # Service locator
```

**The layering paid for itself.** Persistence originally ran on in-memory/JSON storage and was later migrated to on-device SQLite. That migration touched **only the three data source implementations** — every repository, use case, cubit, and widget was left untouched, because none of them had ever known where the data came from. Swapping SQLite for a remote API, or adding a sync layer, is the same shape of change: one new implementation of an existing contract, one changed registration line.

### State management

`flutter_bloc` with **Cubits** rather than full BLoCs — the interactions here are direct method calls, with no meaningful event streams to model.

| Cubit | Owns |
|---|---|
| `MedicineCubit` | the cabinet, CRUD, soft delete, restore |
| `StatisticsCubit` | dose history, filters, summary values, chart data, achievements |
| `SettingsCubit` | preferences, data actions, visible settings section |
| `IntroductionCubit` | onboarding page state |
| `CalendarLoadCubit` | scoped to the home calendar |

Four are provided at the root via `MultiBlocProvider`; the calendar's is scoped locally. `hydrated_bloc` persists cubit state across launches.

`SettingsCubit` deliberately depends on the medicine repository and `MedicineCubit` as well as its own use cases — a restore or hard reset has to reload medication state so the UI stays truthful immediately after the action.

### Dependency injection

`get_it`, initialised in `initServiceLocator()` before `runApp`. The database is opened once and registered as a singleton; data sources, repositories, use cases, and cubits register as lazy singletons so nothing is constructed until first use.

### Scheduling

Due-date resolution lives in `Medicine.isDueOn` — a pure function on the entity, with no I/O and no framework dependency. It handles all four recurrence units, including the fiddly cases: weekly recurrence checks both weekday match and week index, monthly checks day-of-month, yearly checks month and day. Being pure makes the hardest logic in the app the most directly unit-testable part of it.

### Persistence

`sqflite` on mobile, `sqflite_common_ffi` for desktop, initialised conditionally in `main()`. One shared connection to `salemtek.db`, opened at startup.

The local layer is split three ways:

- `app_database.dart` — open, version, `onCreate`, `onUpgrade`
- `database_schema.dart` — table and index statements
- `migrations.dart` — an append-only versioned map, plus a runner that replays every step between `oldVersion` and `newVersion` inside a single batch

Three tables — `medicines`, `statistics`, and a single-row `settings` — with typed columns throughout: dates as epoch milliseconds, booleans as `0`/`1`, enums as text. Indexed on `medicines.dateDeleted`, `statistics.actionDate`, and `statistics.medicineId`. Statistics writes are idempotent via `INSERT OR REPLACE` on a composite id, so recording the same medication/date/action twice cannot corrupt the history.

The app starts genuinely empty. No seed data, no demo rows.

---

## Tech stack

| Area | Choice |
|---|---|
| Framework | Flutter, Dart |
| State management | `flutter_bloc` (Cubit), `hydrated_bloc` |
| Dependency injection | `get_it` |
| Local database | `sqflite`, `sqflite_common_ffi` (desktop) |
| Charts | `fl_chart` |
| Assets & formatting | `flutter_svg`, `intl` |
| Storage paths | `path_provider`, `path` |
| Lints | `flutter_lints` |

---

## Getting started

```bash
flutter pub get
flutter run
```

Runs on Android, iOS, web, Windows, macOS, and Linux. No API keys, no backend, no configuration — all data is local.

---

## Roadmap

- [ ] Wire local notification delivery — the model, per-medication reminder config, and settings all exist; OS scheduling does not
- [ ] Scheduled-dose adherence: compute *expected* doses from start/end date and reminder interval, so consistency becomes true adherence rather than completed ÷ actions
- [ ] Test coverage, starting with `Medicine.isDueOn` across all four recurrence units
- [ ] Splash screen
- [ ] Web preview build, so the UI can be reviewed without a local toolchain
- [ ] Statistics export and shareable achievements
- [ ] Card animation polish; animated percentage on the progress ring
- [ ] Foreign keys and cascade; push statistics filtering down into SQL
- [ ] Multi-tier achievement thresholds (10 / 50 / 100) and streak-based achievements
- [ ] Editing and removing mistaken statistic records
- [ ] Localisation

---

## Build log

The full development checklist is kept below, unedited. It is not a to-do list so much as a running record of how the app was reasoned about — which tradeoffs were taken deliberately, what was deferred and why, and what each architectural decision cost or saved.

A few threads worth following if you're reading it as a work sample:

- **The SQLite migration** — note the line *"Only the 3 datasource impls changed — repos / usecases / cubits / UI untouched."* That is the layering being tested in anger.
- **Action-based vs scheduled-based consistency** — a simpler metric shipped first, with the more correct one specified in full and deferred rather than hand-waved.
- **Dosage as a structured field** — flagged early as "should probably become structured, not only string," before it became painful.
- **Statistics idempotency** — duplicate-prevention was designed in at the schema level, not patched later.

<details>
<summary><strong>Full checklist</strong></summary>

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
    - clears all statistics
    - resets settings to defaults
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
  - [x] Starts empty — no demo or dummy data; the app begins blank as intended
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

</details>
