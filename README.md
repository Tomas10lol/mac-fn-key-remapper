# 🎹 Mac Fn Key Remapper

> Advanced Function Key Remapping Tool for Apple Silicon Macs

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS](https://img.shields.io/badge/macOS-14%2B-blue.svg)](https://www.apple.com/macos/)
[![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon-M1%2FM2%2FM3%2FM4-orange.svg)](https://support.apple.com/en-us/HT211814)

Remap your MacBook's function keys to control **keyboard backlight**, **media playback**, and more — using native macOS `hidutil`. No third-party apps required!

![Demo](https://img.shields.io/badge/F4-Backlight%20↓-red) ![Demo](https://img.shields.io/badge/F5-Backlight%20↑-green) ![Demo](https://img.shields.io/badge/F6-Play%2FPause-blue)

---

## ✨ Features

- 🔆 **Keyboard Backlight Control** — Missing on Apple Silicon Macs? Not anymore!
- 🎵 **Media Controls** — Quick access to Play/Pause, Next/Previous track
- 🛠️ **Custom Mapping Builder** — Create your own key combinations
- 💾 **Persistent** — Survives restarts via LaunchAgent
- 🖥️ **Interactive Menu** — Beautiful TUI for easy configuration
- ⌨️ **CLI Support** — Script-friendly commands for automation
- 🍎 **Native** — Uses macOS `hidutil`, no kernel extensions

---

## 🖥️ Compatibility

| Requirement | Supported |
|-------------|-----------|
| **Chip** | Apple Silicon (M1, M2, M3, M4 series) |
| **macOS** | 14 Sonoma, 15 Sequoia, and later |
| **MacBook** | Air, Pro (all Apple Silicon models) |

---

## 🚀 Quick Start

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/nurkamol/mac-fn-key-remapper/main/mac-fn-key-remapper.sh -o mac-fn-key-remapper.sh && chmod +x mac-fn-key-remapper.sh && ./mac-fn-key-remapper.sh
```

### Manual Install

```bash
# Clone the repository
git clone https://github.com/nurkamol/mac-fn-key-remapper.git
cd mac-fn-key-remapper

# Make executable
chmod +x mac-fn-key-remapper.sh

# Run interactive menu
./mac-fn-key-remapper.sh
```

---

## 📖 Usage

### Interactive Mode

Simply run the script without arguments:

```bash
./mac-fn-key-remapper.sh
```

You'll see a beautiful menu:

```
  ╔═══════════════════════════════════════════════════════════════╗
  ║       ⌨️  MAC FN KEY REMAPPER  💡                              ║
  ║         Advanced Function Key Remapping Tool                  ║
  ║              Apple Silicon Mac Edition                        ║
  ╚═══════════════════════════════════════════════════════════════╝

  [1]  Preset: Keyboard Backlight (F4↓ F5↑)
  [2]  Preset: Media Controls (F4⏮ F5⏯ F6⏭)
  [3]  Preset: Backlight + Media (F4↓ F5↑ F6⏯)
  [4]  Custom Mapping Builder
  [5]  Disable All Mappings
  ...
```

### CLI Mode

```bash
# Enable keyboard backlight control
./mac-fn-key-remapper.sh backlight

# Enable media controls
./mac-fn-key-remapper.sh media

# Enable both backlight and play/pause
./mac-fn-key-remapper.sh combo

# Disable all mappings
./mac-fn-key-remapper.sh unload

# Check current status
./mac-fn-key-remapper.sh status

# Show version
./mac-fn-key-remapper.sh version
```

---

## 🎛️ Presets

### 1. Keyboard Backlight
| Key | New Function | Original |
|-----|--------------|----------|
| F4 | Backlight Down ↓ | Spotlight |
| F5 | Backlight Up ↑ | Dictation |

### 2. Media Controls
| Key | New Function | Original |
|-----|--------------|----------|
| F4 | Previous Track ⏮ | Spotlight |
| F5 | Play/Pause ⏯ | Dictation |
| F6 | Next Track ⏭ | Do Not Disturb |

### 3. Backlight + Media
| Key | New Function | Original |
|-----|--------------|----------|
| F4 | Backlight Down ↓ | Spotlight |
| F5 | Backlight Up ↑ | Dictation |
| F6 | Play/Pause ⏯ | Do Not Disturb |

---

## 🔧 HID Key Reference

### Source Keys (Function Row)
| Code | Key | Default Function |
|------|-----|------------------|
| `0xFF0100000010` | F3 | Mission Control |
| `0x0C00000221` | F4 | Spotlight |
| `0x10000009B` | F5 | Dictation |
| `0xC000000CF` | F6 | Do Not Disturb |
| `0x0C000002A2` | F4 | Launchpad (alt) |

### Destination Keys (Actions)
| Code | Action |
|------|--------|
| `0xFF00000008` | Keyboard Backlight Up |
| `0xFF00000009` | Keyboard Backlight Down |
| `0xFF00000004` | Display Brightness Up |
| `0xFF00000005` | Display Brightness Down |
| `0xC000000CD` | Play/Pause |
| `0xC000000B5` | Next Track |
| `0xC000000B6` | Previous Track |
| `0xC000000E2` | Mute |
| `0xC000000E9` | Volume Up |
| `0xC000000EA` | Volume Down |

---

## ❓ FAQ

### Q: How do I access Spotlight after remapping F4?
**A:** Use `Cmd + Space` (default macOS shortcut)

### Q: How do I access Dictation after remapping F5?
**A:** Go to `System Settings → Keyboard → Dictation` or set a custom shortcut

### Q: Will this survive a restart?
**A:** Yes! The script creates a LaunchAgent that loads automatically at login

### Q: How do I uninstall completely?
```bash
./mac-fn-key-remapper.sh unload
rm ~/Library/LaunchAgents/com.local.KeyRemapping.plist
```

### Q: Does this work on Intel Macs?
**A:** Some mappings may work, but this tool is designed and tested for Apple Silicon

---

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest features
- 🔀 Submit pull requests

---

## 📄 License

MIT License © 2026 [Nurkamol Vakhidov](https://nurkamol.com)

---

## 👨‍💻 Author

**Nurkamol Vakhidov**

- 🌐 Website: [nurkamol.com](https://nurkamol.com)
- 📧 Email: nurkamol@gmail.com
- 🐙 GitHub: [@nurkamol](https://github.com/nurkamol)

---

<p align="center">
  <sub>Made with ❤️ for the Mac community</sub>
</p>
