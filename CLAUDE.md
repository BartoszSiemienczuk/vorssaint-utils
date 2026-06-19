# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Fork context (read first)

This is **BartoszSiemienczuk's personal fork** of `vorssaint/vorssaint-utils`, a macOS
menu-bar utility app, **rebranded as "Borssaint"** (a JB Software fork). It is maintained as a
**locally-built "Developer" variant** that coexists with — and does not replace — the official app.

- `origin` → `github.com/BartoszSiemienczuk/vorssaint-utils` (this fork)
- `upstream` → `github.com/vorssaint/vorssaint-utils` (the original, updated near-daily)
- The fork is **always built with `--dev`**: bundle id `pl.jbsoftware.borssaint.dev`, app name
  "Borssaint (Developer)". This is deliberate, because dev builds **disable the auto-updater**
  (`UpdateService` early-returns when `AppInfo.isDeveloperBuild` is true). The official build's
  updater is hardcoded to pull `upstream`'s releases and would otherwise overwrite a
  same-bundle-id install within the hour.
- There is **no Apple Developer ID** on this machine, so the fork cannot be notarized and
  cannot run its own real OTA feed. Upstream changes are tracked **manually** (see below).
- A visible **"Personal fork"** marker is shown in Settings → About to distinguish local builds.

### Rebrand: Vorssaint → Borssaint

Per `TRADEMARKS.md`, a fork must use a distinct name, icon, bundle id, signing identity, and
update feed — all done: name `Borssaint`, bundle id prefix `pl.jbsoftware`, signing identity
`Borssaint Signing`, blue-tinted icon (`Tools/MakeIcon.swift`), and `UpdateService.repository`
repointed to the fork.

**The rename deliberately did NOT touch copyright notices.** GPL requires preserving them, so:
- The `// Copyright (C) 2026 Vorssaint` SPDX headers on every source file stay as-is.
- The displayed `© 2026 Vorssaint` (in About / `Info.plist` `NSHumanReadableCopyright`) stays.

Also left as-is for low churn (internal, not user-visible): the `Sources/Vorssaint/` directory,
the SwiftPM target/module name `Vorssaint`, and the `VorssaintBuildCommit` Info.plist key. When
renaming brand strings, **only** replace capital-`V` `Vorssaint` and skip those two copyright
patterns — do not blanket sed.

## Common commands

```sh
./build.sh --dev            # compile + assemble + sign the Developer .app (no install)
./build.sh --dev --install  # also install into /Applications and relaunch
./build.sh --test           # compile & run the standalone unit tests, then exit
./refresh-fork.sh           # fetch upstream, merge upstream/main, then build --dev --install
./Tools/setup-signing.sh    # create the stable self-signed identity (run once; see Signing)
```

- **Always pass `--dev` for this fork.** A plain `./build.sh` produces the official-bundle-id
  app, which the upstream updater can clobber.
- **Tests** (`--test`) compile only the pure helpers (metrics, defaults, localization
  contracts, URL cleaning) against `Tests/MetricsTests.swift` with `swiftc` — no XCTest, no UI,
  no IOKit. To run a single test, edit `Tests/MetricsTests.swift` (it's a hand-rolled runner,
  not an XCTest suite). The build pins the macOS 26 SDK when present.
- `refresh-fork.sh` requires a **clean working tree** (it merges; commit your changes first)
  and stops on merge conflicts for you to resolve.

## Tracking upstream

Run `./refresh-fork.sh` to catch up with upstream's frequent releases. It uses **merge** (not
rebase) so your fork commits stay on top with no force-push, then rebuilds and reinstalls the
Developer app. Expect occasional conflicts in files you've customized (e.g. the About marker in
`Sources/Vorssaint/UI/Settings/SettingsView.swift`).

## Architecture

Single SwiftPM executable target (`Package.swift` → `Sources/Vorssaint`), no third-party
dependencies. Menu-bar-only agent (`LSUIElement` true). SwiftUI views hosted by AppKit plumbing.
Source is layered:

- **`App/`** — menu-bar plumbing: `AppDelegate` (lifecycle, wiring), `StatusItemController`
  (the `NSStatusItem`), `MenuBarRenderer` (the icon/panel).
- **`Core/`** — cross-cutting shared code: `AppInfo` (identity, `isDeveloperBuild`,
  `buildCommit`), `Defaults` (`UserDefaults` keys), `Localization` + `Localizations/Strings+*`
  (one file per language; the `--test` build verifies their contracts), `BundleMigration`,
  `ReleaseNotes`, `URLCleaning`.
- **`Services/`** — feature backends, one folder per capability: `Audio` (per-app volume mixer),
  `SystemMonitor`/`Metrics` (CPU/network readouts), `Switcher` (window & file moving),
  `AutoQuit`, `CleaningMode`, `Finder`, `Shelf`, `Uninstall`, and `Update` (the GitHub-releases
  self-updater).
- **`UI/`** — SwiftUI, mirroring the services: `MenuPanel`, `Settings`, `Onboarding`, plus
  per-feature views (`CleaningMode`, `Finder`, `Shelf`, `Switcher`, `Uninstall`).

### Update mechanism (important, non-obvious)

`Services/Update/UpdateService.swift` is a from-scratch self-updater (no Sparkle). The official
build polls `api.github.com/repos/vorssaint/vorssaint-utils/releases/latest` hourly, downloads
the release `.dmg`, and a detached shell script swaps the bundle after verifying it against a
**pinned designated requirement** (`identifier "com.vorssaint.utils"` + Apple team `3D485NHW29`
+ Gatekeeper `spctl`). A fork build cannot satisfy this requirement — which is exactly why this
fork relies on `--dev` to disable the updater rather than trying to repoint it.

## Signing

`build.sh` signs in this order of preference: (1) a real Apple **Developer ID** (none here),
(2) the **stable self-signed identity** "Borssaint Signing" created by
`Tools/setup-signing.sh`, (3) **ad-hoc**. This fork uses option 2: it gives every local build a
**stable** signature so macOS preserves granted permissions (Accessibility, Screen Recording)
across the frequent rebuilds instead of re-prompting. Run `Tools/setup-signing.sh` once per
machine. The build stages the bundle in a temp dir outside `~/Documents` because File Provider
xattrs invalidate the code signature.
