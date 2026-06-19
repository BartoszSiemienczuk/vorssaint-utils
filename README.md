# Borssaint

> One small menu bar app that replaces a whole stack of paid Mac utilities.

> [!NOTE]
> **Borssaint is a personal fork** of [Vorssaint](https://github.com/vorssaint/vorssaint-utils)
> by JB Software, rebranded per the upstream [TRADEMARKS.md](TRADEMARKS.md). All credit for the
> original app goes to the Vorssaint project; the source remains GPL-3.0-or-later.

<p align="center">
  <a href="https://github.com/BartoszSiemienczuk/vorssaint-utils"><strong>github.com/BartoszSiemienczuk/vorssaint-utils</strong></a>
</p>

<p align="center">
  <a href="https://github.com/BartoszSiemienczuk/vorssaint-utils/releases"><img src="https://img.shields.io/github/v/release/BartoszSiemienczuk/vorssaint-utils?label=release" alt="Latest release"></a>
  <a href="https://github.com/BartoszSiemienczuk/vorssaint-utils/actions/workflows/ci.yml"><img src="https://github.com/BartoszSiemienczuk/vorssaint-utils/actions/workflows/ci.yml/badge.svg?branch=main&event=push" alt="CI status"></a>
  <a href="#what-you-need"><img src="https://img.shields.io/badge/macOS-14%2B%20(Apple%20Silicon)-black" alt="macOS 14 and newer, Apple Silicon"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL%203.0%20or%20later-blue" alt="License GPL 3.0 or later"></a>
</p>

<p align="center"><sub>Também disponível em <a href="docs/README.pt-BR.md">Português (Brasil)</a>.</sub></p>

Borssaint is the one menu bar app that does the work of a whole shelf of paid Mac tools. Per app volume, a full system monitor, a window switcher, a file shelf, an app uninstaller, link cleaning, keep awake and a handful more, all living behind a single icon up in your menu bar. Install it once and stop paying for and juggling a pile of single purpose apps. It runs entirely on your Mac and stays out of your way. Free, open source, no account, no subscription and no telemetry.

## Everything in one menu bar app

Here is the whole toolkit. Every part can be turned on or off, so you keep what you use and hide the rest.

### 🎚️ Per app volume, the one people reach for first

Borssaint puts a real mixer in your menu bar, so you can slide any single app up or down while the rest of your Mac stays exactly where it was. Mute a loud video and let your music keep playing. Lift a quiet call without turning everything else up. There is no extra audio driver to install and nothing to set up first.

<p align="center"><img src="docs/assets/readme/volume-mixer.png" alt="Per app volume mixer" width="540"></p>

On macOS 26 and newer the slider takes on the Liquid Glass look, and earlier versions of macOS keep the familiar one.

### 📊 See what your Mac is doing

- **System monitor.** Follow CPU, GPU, memory, temperatures, battery details and uptime in one compact panel, with small history graphs and optional menu bar readouts.
- **Network.** Watch live upload and download rates, the totals for your session, and a speed test you can run whenever you are curious.
- **Power and battery.** Keep an eye on the system draw, the adapter input, the flow in and out of the battery, plus health, cycle count and which apps are burning real energy right now.

<p align="center"><img src="docs/assets/readme/system-monitor-graph.png" alt="System monitor with live graphs" width="460"></p>

### 🪟 Move windows and files around

- **Window switcher.** A richer spin on ⌘Tab with live thumbnails, including more than one window from the same app.
- **Shelf.** Park files, images, text and links near your cursor for a moment, then drag them wherever they belong later on.
- **Finder cut and paste.** Use ⌘X and ⌘V to move selected files, while text fields keep their usual shortcuts.
- **Quit on close.** Let an app quit when its last window closes, with exceptions for the apps you want to leave running.
- **Green button maximizer.** An optional take on the green button that keeps the window in the current Space and puts it back to its old size on the next click.

<p align="center"><img src="docs/assets/readme/window-switcher.gif" alt="Window switcher with live thumbnails" width="460"></p>

### ⚡ Keep your Mac awake

Run a timer or stay up until you say stop. Closed lid mode is there for when you want the Mac to keep going with the screen down, and it stays opt in and tightly scoped so it never catches you off guard.

<p align="center"><img src="docs/assets/readme/keep-awake-lid-closed.png" alt="Keep awake and closed lid controls" width="460"></p>

### 🧹 Tidy up and fine tune

- **Uninstaller.** Drop an app onto Settings, look over the caches, preferences and logs it left around, then move them all to the Trash together.
- **Clean URL.** Strip the tracking junk out of copied links, with an option to do it automatically.
- **Cleaning Mode.** Lock the keyboard for a quick wipe down and unlock from the overlay or a repeated key tap.
- **Scroll direction.** Flip the mouse wheel on its own without touching the trackpad and its natural scrolling.
- **Fan Control beta.** A safe testing entry is in place, with the manual controls held back until each Mac model is checked out properly.

### 🌍 Made to feel at home

Borssaint speaks eight languages and you can switch between them anytime in Settings. The compact panel lets you choose between a plain list and grouped sections, and you can tuck away the parts you rarely use, then bring them back from the same spot.

## Install

Borssaint is a personal fork and is **built from source** — there is no Homebrew cask or
notarized release. See [Build it yourself](#build-it-yourself) below.

Because the fork is self-signed rather than notarized by Apple, the first launch may show a
Gatekeeper prompt — right-click the app and choose **Open** once to allow it. The stable
self-signed identity means macOS keeps the permissions you grant across rebuilds.

## Private by default

Borssaint runs on your machine and asks for nothing it does not need. No account, no telemetry, no analytics and no tracking. The one request it makes on its own is a quiet check for a newer version, which you can switch off, and the speed test only reaches out when you press start. The whole story is written up in the [privacy notes](docs/PRIVACY.md).

Every macOS permission is optional, and the first run walks you through each one. A feature that is missing a permission simply stays quiet instead of breaking. Here is the short version, with the full picture in the [permissions guide](docs/PERMISSIONS.md).

| Permission | Used by | Without it |
|---|---|---|
| Accessibility | Scroll direction, the switcher, Finder cut and paste, quit on close | Those features stay off |
| Screen Recording | Window titles and thumbnails in the switcher | The switcher shows app icons only |
| Notifications | Keep awake, battery and update alerts | The app stays silent |
| Full Disk Access (optional) | A deeper uninstaller scan | It scans the reachable places only |
| Administrator (once, optional) | Password free closed lid toggling | A password prompt on each toggle |

Finder cut and paste and the uninstaller also ask macOS for Automation access the first time they talk to Finder. The shelf needs no permission at all.

## What you need

- A Mac with Apple Silicon
- macOS 14 Sonoma or newer
- Xcode Command Line Tools, only if you build it yourself

### Build it yourself

```sh
git clone https://github.com/BartoszSiemienczuk/vorssaint-utils.git
cd vorssaint-utils
./Tools/setup-signing.sh    # once: create the stable self-signed identity
./build.sh --dev --install  # build and install "Borssaint (Developer)"
```

The fork is **always built with `--dev`**: it installs as "Borssaint (Developer)" with its own
bundle id, so it coexists with the upstream app and its self-updater stays disabled (a plain
`./build.sh` would produce the upstream-bundle-id build, which the official OTA updater can
overwrite). Run `./refresh-fork.sh` to pull the latest upstream changes and rebuild.

This is a personal fork of [Vorssaint](https://github.com/vorssaint/vorssaint-utils). Per the
GPL, the source stays GPL-3.0-or-later and the Vorssaint name, logo and look remain the upstream
project's — which is why this fork rebrands as Borssaint. See [TRADEMARKS.md](TRADEMARKS.md) and
the [contributing guide](CONTRIBUTING.md).

## Troubleshooting

App blocked on first launch, a permission that will not take hold, or the switcher showing icons instead of thumbnails? The [troubleshooting guide](docs/TROUBLESHOOTING.md) walks through the common fixes, including how to reset permissions and remove the app cleanly.

## Uninstall

```sh
./Tools/uninstall.sh
```

The script quits the app, drops the login item, resets its Accessibility and Screen Recording access, deletes the app along with its preferences and saved state, and removes the optional closed lid rule, so nothing is left behind. You can also drag the app to the Trash and run `tccutil reset All pl.jbsoftware.borssaint` to clear its permissions.

## Documentation

- [Privacy](docs/PRIVACY.md), what does and does not leave your Mac
- [Permissions](docs/PERMISSIONS.md), every macOS permission in plain words
- [Troubleshooting](docs/TROUBLESHOOTING.md), the common fixes
- [Contributing](CONTRIBUTING.md), build, layout and conventions
- [Support](SUPPORT.md), where to get help
- [Security](SECURITY.md), how to report a vulnerability

## Contributing

Issues and pull requests are very welcome. The [contributing guide](CONTRIBUTING.md) has the build setup, the project conventions and how to add a translation or map the sensors on a new chip. For help, bug reports and feature ideas head to [support](SUPPORT.md), and to report something sensitive in private see the [security policy](SECURITY.md).

## Support the project

Borssaint is free and it will stay that way. If it earns a place in your menu bar, a quick ⭐ helps other people find it. If you want to chip in beyond that you can [buy me a coffee](https://buymeacoffee.com/vorssaint), and either way the project lives on the community around it.

## License

The source code is licensed under [GPL 3.0 or later](LICENSE), copyright 2026 Vorssaint. That license covers the source code. The Vorssaint name, logo and look are covered on their own in [TRADEMARKS.md](TRADEMARKS.md).
