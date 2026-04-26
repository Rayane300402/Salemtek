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
    - uses in-memory local data for now
    - emulates future SQLite single-row settings table
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

- [x] Planned future DB shape for Settings
  - [x] one local `settings` table
  - [x] single-row settings design
  - [x] intended columns:
    - `notifications_enabled`
    - `excessive_reminders_enabled`
    - `excessive_reminder_minutes`
    - `updated_at`

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
      - [ ] drip/IV drip
      - [x] cream
      - [ ] inhaler
      - [ ] powder/sachet
      - [ ] bandage/wound care
      - [ ] liquid
      - [ ] drops
      - [ ] suppository

  - [x] Medicine name section
    - [x] title: Name
    - [x] rounded input container
    - [x] leading image based on selected medicine type
    - [x] text field for medicine name
    - [ ] prefilled in edit mode

  - [ ] Reason section
    - [ ] title: Reason
    - [ ] optional multiline text field
    - [ ] rounded large input container
    - [ ] prefilled in edit mode
    - [ ] can be empty

  - [ ] Notification section
    - [ ] title: Notification
    - [ ] dropdown for reminder type
    - [ ] options:
      - [ ] none
      - [ ] every X days
      - [ ] every X weeks
      - [ ] every X months
    - [ ] show X value input only when reminder is not none
    - [ ] X value must be friendly and adjustable
    - [ ] selected reminder affects preview text later
    - [ ] prefilled in edit mode

  - [ ] Dosage section
    - [ ] title: Dosage
    - [ ] dosage UI changes based on medicine type
    - [ ] examples:
      - [ ] pill: 1 pill, 2 pills
      - [ ] capsule: 1 capsule, 2 capsules
      - [ ] injection: 1 injection
      - [ ] inhaler: 1 puff, 2 puffs
      - [ ] cream: apply once, apply twice
      - [ ] powder/sachet: 1 sachet, 2 sachets
      - [ ] liquid: ml-based or spoon-based
      - [ ] drops: 1 drop, 2 drops
      - [ ] suppository: 1 suppository
      - [ ] bandage: apply/change once
      - [ ] drip: 1 drip/session
    - [ ] prefilled in edit mode

  - [ ] Date section
    - [ ] title: Date
    - [ ] start date is required
    - [ ] end date is optional
    - [ ] rounded date buttons
    - [ ] prefilled in edit mode
    - [ ] empty end date means long-term/permanent medicine

  - [ ] Submit button
    - [ ] large rounded primary button
    - [ ] create mode text: Create
    - [ ] edit mode text: Update
    - [ ] closes bottom sheet for now
    - [ ] no database/cubit mutation yet

  - [ ] Future data/model considerations
    - [ ] medicine type should become a real field in `Medicine`
    - [ ] dosage should probably become structured, not only string
    - [ ] notification can stay structured using reminder unit/every value
    - [ ] dosage history may be needed later for accurate stats
    - [ ] completion/stats should eventually store exact dosage taken at that time