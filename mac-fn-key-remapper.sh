#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════════
#
#   ███╗   ███╗ █████╗  ██████╗    ███████╗███╗   ██╗    ██╗  ██╗███████╗██╗   ██╗
#   ████╗ ████║██╔══██╗██╔════╝    ██╔════╝████╗  ██║    ██║ ██╔╝██╔════╝╚██╗ ██╔╝
#   ██╔████╔██║███████║██║         █████╗  ██╔██╗ ██║    █████╔╝ █████╗   ╚████╔╝
#   ██║╚██╔╝██║██╔══██║██║         ██╔══╝  ██║╚██╗██║    ██╔═██╗ ██╔══╝    ╚██╔╝
#   ██║ ╚═╝ ██║██║  ██║╚██████╗    ██║     ██║ ╚████║    ██║  ██╗███████╗   ██║
#   ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝    ╚═╝     ╚═╝  ╚═══╝    ╚═╝  ╚═╝╚══════╝   ╚═╝
#
#   MAC FN KEY REMAPPER
#   Advanced Function Key Remapping Tool for Apple Silicon Macs
#
#   Author:     Nurkamol Vakhidov
#   Email:      nurkamol@gmail.com
#   Website:    https://nurkamol.com
#   GitHub:     https://github.com/nurkamol/mac-fn-key-remapper
#
#   License:    MIT
#   Version:    1.0.0
#
#   Description:
#   Remaps macOS function keys (F1-F12) to custom actions like keyboard
#   backlight control, media playback, and more using native hidutil.
#   Designed specifically for Apple Silicon Macs (M1/M2/M3/M4).
#
#   Compatibility:
#   - Apple Silicon Macs (M1, M2, M3, M4 series)
#   - macOS 14 Sonoma and later
#   - macOS 15 Sequoia
#
# ═══════════════════════════════════════════════════════════════════════════════

VERSION="1.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
DIM='\033[2m'
NC='\033[0m' # No Color

PLIST_PATH="$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"

# ─────────────────────────────────────────────────────────────────────────────────
# HID Key Codes
# ─────────────────────────────────────────────────────────────────────────────────
# Source Keys (Function Keys)
HID_SPOTLIGHT="0x0C00000221"        # F4 - Spotlight
HID_DICTATION="0x10000009B"         # F5 - Dictation  
HID_DND="0xC000000CF"               # F6 - Do Not Disturb
HID_MISSION_CTRL="0xFF0100000010"   # F3 - Mission Control
HID_LAUNCHPAD="0x0C000002A2"        # F4 - Launchpad (alternative)

# Destination Keys (Actions)
HID_KB_LIGHT_UP="0xFF00000008"      # Keyboard Backlight Up
HID_KB_LIGHT_DOWN="0xFF00000009"    # Keyboard Backlight Down
HID_DISPLAY_UP="0xFF00000004"       # Display Brightness Up
HID_DISPLAY_DOWN="0xFF00000005"     # Display Brightness Down
HID_PLAY_PAUSE="0xC000000CD"        # Play/Pause
HID_NEXT_TRACK="0xC000000B5"        # Next Track
HID_PREV_TRACK="0xC000000B6"        # Previous Track
HID_MUTE="0xC000000E2"              # Mute
HID_VOL_UP="0xC000000E9"            # Volume Up
HID_VOL_DOWN="0xC000000EA"          # Volume Down

# ─────────────────────────────────────────────────────────────────────────────────
# Functions
# ─────────────────────────────────────────────────────────────────────────────────

clear_screen() {
    clear
}

print_header() {
    echo -e "${CYAN}"
    echo "  ╔═══════════════════════════════════════════════════════════════╗"
    echo "  ║       ⌨️  MAC FN KEY REMAPPER  💡                              ║"
    echo "  ║         Advanced Function Key Remapping Tool                  ║"
    echo "  ║              Apple Silicon Mac Edition                        ║"
    echo "  ╠═══════════════════════════════════════════════════════════════╣"
    echo "  ║  Author: Nurkamol Vakhidov    Website: https://nurkamol.com   ║"
    echo "  ╚═══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_status() {
    echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
    if [ -f "$PLIST_PATH" ]; then
        echo -e "${WHITE}  │  Status:  ${GREEN}● ACTIVE${WHITE}                                             │${NC}"
        echo -e "${WHITE}  │  ${DIM}Custom key mapping is enabled${NC}${WHITE}                              │${NC}"
    else
        echo -e "${WHITE}  │  Status:  ${RED}○ INACTIVE${WHITE}                                           │${NC}"
        echo -e "${WHITE}  │  ${DIM}All function keys at default${NC}${WHITE}                              │${NC}"
    fi
    echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

print_menu() {
    echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}  │                        ${YELLOW}MAIN MENU${WHITE}                               │${NC}"
    echo -e "${WHITE}  ├─────────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${WHITE}  │                                                                 │${NC}"
    echo -e "${WHITE}  │      ${CYAN}[1]${NC}  Preset: Keyboard Backlight (F4↓ F5↑)                ${WHITE}│${NC}"
    echo -e "${WHITE}  │      ${CYAN}[2]${NC}  Preset: Media Controls (F4⏮ F5⏯ F6⏭)                ${WHITE}│${NC}"
    echo -e "${WHITE}  │      ${CYAN}[3]${NC}  Preset: Backlight + Media (F4↓ F5↑ F6⏯)            ${WHITE}│${NC}"
    echo -e "${WHITE}  │      ${CYAN}[4]${NC}  Custom Mapping Builder                              ${WHITE}│${NC}"
    echo -e "${WHITE}  │      ${CYAN}[5]${NC}  Disable All Mappings                                ${WHITE}│${NC}"
    echo -e "${WHITE}  │      ${CYAN}[6]${NC}  Show Current Mapping Details                        ${WHITE}│${NC}"
    echo -e "${WHITE}  │      ${CYAN}[7]${NC}  Help & HID Reference Table                          ${WHITE}│${NC}"
    echo -e "${WHITE}  │      ${RED}[0]${NC}  Exit                                                 ${WHITE}│${NC}"
    echo -e "${WHITE}  │                                                                 │${NC}"
    echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

apply_mapping() {
    local mapping="$1"
    local description="$2"
    
    mkdir -p ~/Library/LaunchAgents
    
    cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[$mapping]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
PLIST

    launchctl unload "$PLIST_PATH" 2>/dev/null
    launchctl load "$PLIST_PATH" 2>/dev/null
    
    # Apply immediately
    hidutil property --set "{\"UserKeyMapping\":[$mapping]}" >/dev/null 2>&1
    
    echo -e "${GREEN}  ✅ Mapping enabled successfully!${NC}"
    echo ""
    echo -e "${WHITE}  $description${NC}"
    echo ""
    echo -e "${DIM}  Tip: Changes persist after restart${NC}"
}

# ─────────────────────────────────────────────────────────────────────────────────
# Preset 1: Keyboard Backlight Only
# ─────────────────────────────────────────────────────────────────────────────────
preset_backlight() {
    echo ""
    echo -e "${YELLOW}  ⏳ Applying Keyboard Backlight preset...${NC}"
    
    local mapping='{\"HIDKeyboardModifierMappingSrc\":0x0C00000221,\"HIDKeyboardModifierMappingDst\":0xFF00000009},{\"HIDKeyboardModifierMappingSrc\":0xC000000CF,\"HIDKeyboardModifierMappingDst\":0xFF00000008}'
    
    local description="
  ┌─────────────────────────────────────────────────────────────────┐
  │  ${GREEN}F4${NC}  →  Keyboard Backlight ${RED}DOWN${NC}  ↓  (was Spotlight)          │
  │  ${GREEN}F5${NC}  →  Keyboard Backlight ${GREEN}UP${NC}    ↑  (was Dictation)          │
  └─────────────────────────────────────────────────────────────────┘"
    
    apply_mapping "$mapping" "$description"
}

# ─────────────────────────────────────────────────────────────────────────────────
# Preset 2: Media Controls
# ─────────────────────────────────────────────────────────────────────────────────
preset_media() {
    echo ""
    echo -e "${YELLOW}  ⏳ Applying Media Controls preset...${NC}"
    
    local mapping='{\"HIDKeyboardModifierMappingSrc\":0x0C00000221,\"HIDKeyboardModifierMappingDst\":0xC000000B6},{\"HIDKeyboardModifierMappingSrc\":0xC000000CF,\"HIDKeyboardModifierMappingDst\":0xC000000CD},{\"HIDKeyboardModifierMappingSrc\":0x10000009B,\"HIDKeyboardModifierMappingDst\":0xC000000B5}'
    
    local description="
  ┌─────────────────────────────────────────────────────────────────┐
  │  ${GREEN}F4${NC}  →  ⏮  Previous Track    (was Spotlight)                 │
  │  ${GREEN}F5${NC}  →  ⏯  Play/Pause        (was Dictation)                 │
  │  ${GREEN}F6${NC}  →  ⏭  Next Track        (was Do Not Disturb)            │
  └─────────────────────────────────────────────────────────────────┘"
    
    apply_mapping "$mapping" "$description"
}

# ─────────────────────────────────────────────────────────────────────────────────
# Preset 3: Backlight + Media
# ─────────────────────────────────────────────────────────────────────────────────
preset_backlight_media() {
    echo ""
    echo -e "${YELLOW}  ⏳ Applying Backlight + Media preset...${NC}"
    
    local mapping='{\"HIDKeyboardModifierMappingSrc\":0x0C00000221,\"HIDKeyboardModifierMappingDst\":0xFF00000009},{\"HIDKeyboardModifierMappingSrc\":0xC000000CF,\"HIDKeyboardModifierMappingDst\":0xFF00000008},{\"HIDKeyboardModifierMappingSrc\":0x10000009B,\"HIDKeyboardModifierMappingDst\":0xC000000CD}'
    
    local description="
  ┌─────────────────────────────────────────────────────────────────┐
  │  ${GREEN}F4${NC}  →  Keyboard Backlight ${RED}DOWN${NC}  ↓  (was Spotlight)          │
  │  ${GREEN}F5${NC}  →  Keyboard Backlight ${GREEN}UP${NC}    ↑  (was Dictation)          │
  │  ${GREEN}F6${NC}  →  ⏯  Play/Pause           (was Do Not Disturb)         │
  └─────────────────────────────────────────────────────────────────┘"
    
    apply_mapping "$mapping" "$description"
}

# ─────────────────────────────────────────────────────────────────────────────────
# Custom Mapping Builder
# ─────────────────────────────────────────────────────────────────────────────────
custom_builder() {
    local mappings=""
    local description_lines=""
    local count=0
    
    while true; do
        clear_screen
        echo -e "${CYAN}"
        echo "  ╔═══════════════════════════════════════════════════════════════╗"
        echo "  ║              🛠️  CUSTOM MAPPING BUILDER                        ║"
        echo "  ╚═══════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        if [ $count -gt 0 ]; then
            echo -e "${WHITE}  Current mappings (${count}):${NC}"
            echo -e "$description_lines"
            echo ""
        fi
        
        echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${WHITE}  │              ${YELLOW}SELECT SOURCE KEY (to remap)${WHITE}                    │${NC}"
        echo -e "${WHITE}  ├─────────────────────────────────────────────────────────────────┤${NC}"
        echo -e "${WHITE}  │  ${CYAN}[1]${NC}  F3  - Mission Control                                   ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[2]${NC}  F4  - Spotlight                                         ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[3]${NC}  F5  - Dictation                                         ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[4]${NC}  F6  - Do Not Disturb                                    ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[5]${NC}  F10 - Mute                                              ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[6]${NC}  F11 - Volume Down                                       ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[7]${NC}  F12 - Volume Up                                         ${WHITE}│${NC}"
        echo -e "${WHITE}  ├─────────────────────────────────────────────────────────────────┤${NC}"
        echo -e "${WHITE}  │  ${GREEN}[A]${NC}  Apply current mappings                                  ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${RED}[0]${NC}  Cancel and return                                       ${WHITE}│${NC}"
        echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        echo -ne "${WHITE}  Select source key: ${CYAN}"
        read src_choice
        echo -e "${NC}"
        
        local src_code=""
        local src_name=""
        
        case $src_choice in
            1) src_code="0xFF0100000010"; src_name="F3 (Mission Control)";;
            2) src_code="0x0C00000221"; src_name="F4 (Spotlight)";;
            3) src_code="0x10000009B"; src_name="F5 (Dictation)";;
            4) src_code="0xC000000CF"; src_name="F6 (Do Not Disturb)";;
            5) src_code="0xC000000E2"; src_name="F10 (Mute)";;
            6) src_code="0xC000000EA"; src_name="F11 (Volume Down)";;
            7) src_code="0xC000000E9"; src_name="F12 (Volume Up)";;
            [Aa])
                if [ $count -gt 0 ]; then
                    echo -e "${YELLOW}  ⏳ Applying custom mappings...${NC}"
                    apply_mapping "$mappings" "$description_lines"
                    return
                else
                    echo -e "${RED}  ❌ No mappings added yet!${NC}"
                    sleep 1
                    continue
                fi
                ;;
            0) return;;
            *) continue;;
        esac
        
        # Select destination
        echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
        echo -e "${WHITE}  │            ${YELLOW}SELECT DESTINATION (new function)${WHITE}                 │${NC}"
        echo -e "${WHITE}  ├─────────────────────────────────────────────────────────────────┤${NC}"
        echo -e "${WHITE}  │  ${CYAN}[1]${NC}  Keyboard Backlight Down                                 ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[2]${NC}  Keyboard Backlight Up                                   ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[3]${NC}  Display Brightness Down                                 ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[4]${NC}  Display Brightness Up                                   ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[5]${NC}  Play/Pause                                              ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[6]${NC}  Previous Track                                          ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[7]${NC}  Next Track                                              ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[8]${NC}  Mute                                                    ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[9]${NC}  Volume Down                                             ${WHITE}│${NC}"
        echo -e "${WHITE}  │  ${CYAN}[10]${NC} Volume Up                                               ${WHITE}│${NC}"
        echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        echo -ne "${WHITE}  Select destination: ${CYAN}"
        read dst_choice
        echo -e "${NC}"
        
        local dst_code=""
        local dst_name=""
        
        case $dst_choice in
            1) dst_code="0xFF00000009"; dst_name="KB Backlight Down";;
            2) dst_code="0xFF00000008"; dst_name="KB Backlight Up";;
            3) dst_code="0xFF00000005"; dst_name="Display Brightness Down";;
            4) dst_code="0xFF00000004"; dst_name="Display Brightness Up";;
            5) dst_code="0xC000000CD"; dst_name="Play/Pause";;
            6) dst_code="0xC000000B6"; dst_name="Previous Track";;
            7) dst_code="0xC000000B5"; dst_name="Next Track";;
            8) dst_code="0xC000000E2"; dst_name="Mute";;
            9) dst_code="0xC000000EA"; dst_name="Volume Down";;
            10) dst_code="0xC000000E9"; dst_name="Volume Up";;
            *) continue;;
        esac
        
        # Add mapping
        if [ $count -gt 0 ]; then
            mappings="$mappings,"
        fi
        mappings="$mappings{\\\"HIDKeyboardModifierMappingSrc\\\":$src_code,\\\"HIDKeyboardModifierMappingDst\\\":$dst_code}"
        description_lines="$description_lines
  │  ${GREEN}$src_name${NC}  →  ${CYAN}$dst_name${NC}"
        ((count++))
        
        echo -e "${GREEN}  ✓ Added: $src_name → $dst_name${NC}"
        sleep 1
    done
}

unload_mapping() {
    echo ""
    echo -e "${YELLOW}  ⏳ Disabling all mappings...${NC}"
    
    launchctl unload "$PLIST_PATH" 2>/dev/null
    rm -f "$PLIST_PATH"
    hidutil property --set '{"UserKeyMapping":[]}' >/dev/null 2>&1
    
    echo -e "${GREEN}  ✅ All mappings disabled!${NC}"
    echo ""
    echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}  │  All function keys restored to default behavior                 │${NC}"
    echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_details() {
    echo ""
    echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}  │                    ${YELLOW}MAPPING DETAILS${WHITE}                             │${NC}"
    echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${CYAN}  Current hidutil mapping:${NC}"
    echo -e "${DIM}"
    hidutil property --get "UserKeyMapping" 2>/dev/null | sed 's/^/  /'
    echo -e "${NC}"
    echo -e "${CYAN}  Plist file:${NC} ${DIM}$PLIST_PATH${NC}"
    if [ -f "$PLIST_PATH" ]; then
        echo -e "${GREEN}  File exists ✓${NC}"
    else
        echo -e "${RED}  File not found ✗${NC}"
    fi
    echo ""
}

show_help() {
    echo ""
    echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}  │                      ${YELLOW}HELP & INFO${WHITE}                               │${NC}"
    echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${CYAN}  What this does:${NC}"
    echo -e "  Remaps function keys to custom actions using macOS hidutil."
    echo -e "  Changes persist after restart."
    echo ""
    echo -e "${CYAN}  Available Presets:${NC}"
    echo -e "  • Backlight:       F4/F5 → Keyboard brightness control"
    echo -e "  • Media:           F4/F5/F6 → Prev/Play/Next track"
    echo -e "  • Backlight+Media: F4/F5 → Backlight, F6 → Play/Pause"
    echo ""
    echo -e "${CYAN}  CLI Usage:${NC}"
    echo -e "  ${DIM}./mac-fn-key-remapper.sh backlight${NC}  - Preset 1"
    echo -e "  ${DIM}./mac-fn-key-remapper.sh media${NC}      - Preset 2"
    echo -e "  ${DIM}./mac-fn-key-remapper.sh combo${NC}      - Preset 3"
    echo -e "  ${DIM}./mac-fn-key-remapper.sh unload${NC}     - Disable all"
    echo -e "  ${DIM}./mac-fn-key-remapper.sh status${NC}     - Check status"
    echo ""
    echo -e "${CYAN}  Compatibility:${NC}"
    echo -e "  • Apple Silicon Macs (M1/M2/M3/M4 series)"
    echo -e "  • macOS 14 Sonoma and later"
    echo ""
    echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}  │              ${YELLOW}HID KEY MAPPING REFERENCE TABLE${WHITE}                   │${NC}"
    echo -e "${WHITE}  ├─────────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${WHITE}  │  ${CYAN}SOURCE KEYS (Function Row)${NC}                                   │${NC}"
    echo -e "${WHITE}  │  0xFF0100000010 = F3  Mission Control                           │${NC}"
    echo -e "${WHITE}  │  0x0C00000221   = F4  Spotlight                                 │${NC}"
    echo -e "${WHITE}  │  0x10000009B    = F5  Dictation                                 │${NC}"
    echo -e "${WHITE}  │  0xC000000CF    = F6  Do Not Disturb                            │${NC}"
    echo -e "${WHITE}  │  0x0C000002A2   = F4  Launchpad (alt)                           │${NC}"
    echo -e "${WHITE}  ├─────────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${WHITE}  │  ${CYAN}DESTINATION KEYS (Actions)${NC}                                   │${NC}"
    echo -e "${WHITE}  │  0xFF00000008   = Keyboard Backlight Up                         │${NC}"
    echo -e "${WHITE}  │  0xFF00000009   = Keyboard Backlight Down                       │${NC}"
    echo -e "${WHITE}  │  0xFF00000004   = Display Brightness Up                         │${NC}"
    echo -e "${WHITE}  │  0xFF00000005   = Display Brightness Down                       │${NC}"
    echo -e "${WHITE}  │  0xC000000CD    = Play/Pause                                    │${NC}"
    echo -e "${WHITE}  │  0xC000000B5    = Next Track                                    │${NC}"
    echo -e "${WHITE}  │  0xC000000B6    = Previous Track                                │${NC}"
    echo -e "${WHITE}  │  0xC000000E2    = Mute                                          │${NC}"
    echo -e "${WHITE}  │  0xC000000E9    = Volume Up                                     │${NC}"
    echo -e "${WHITE}  │  0xC000000EA    = Volume Down                                   │${NC}"
    echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "${WHITE}  ┌─────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${WHITE}  │                       ${YELLOW}CREDITS${WHITE}                                  │${NC}"
    echo -e "${WHITE}  ├─────────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${WHITE}  │  Author:   Nurkamol Vakhidov                                    │${NC}"
    echo -e "${WHITE}  │  Email:    nurkamol@gmail.com                                   │${NC}"
    echo -e "${WHITE}  │  Website:  https://nurkamol.com                                 │${NC}"
    echo -e "${WHITE}  │  GitHub:   https://github.com/nurkamol/mac-fn-key-remapper      │${NC}"
    echo -e "${WHITE}  │  Version:  ${VERSION}                                                 │${NC}"
    echo -e "${WHITE}  │  License:  MIT                                                  │${NC}"
    echo -e "${WHITE}  └─────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

show_version() {
    echo "Mac Fn Key Remapper v${VERSION}"
    echo "Author: Nurkamol Vakhidov"
    echo "Website: https://nurkamol.com"
}

press_enter() {
    echo -e "${DIM}  Press Enter to continue...${NC}"
    read
}

# ─────────────────────────────────────────────────────────────────────────────────
# CLI Mode (non-interactive)
# ─────────────────────────────────────────────────────────────────────────────────

if [ -n "$1" ]; then
    case "$1" in
        backlight|load)
            preset_backlight
            ;;
        media)
            preset_media
            ;;
        combo)
            preset_backlight_media
            ;;
        unload)
            unload_mapping
            ;;
        status)
            if [ -f "$PLIST_PATH" ]; then
                echo -e "${GREEN}ACTIVE${NC} - Custom mapping enabled"
                hidutil property --get "UserKeyMapping" 2>/dev/null
            else
                echo -e "${RED}INACTIVE${NC} - All keys at default"
            fi
            ;;
        version|-v|--version)
            show_version
            ;;
        help|-h|--help)
            echo "Mac Fn Key Remapper v${VERSION}"
            echo ""
            echo "Usage: $0 {backlight|media|combo|unload|status|version}"
            echo ""
            echo "  backlight  - F4↓ F5↑ keyboard backlight"
            echo "  media      - F4⏮ F5⏯ F6⏭ media controls"
            echo "  combo      - F4↓ F5↑ backlight + F6⏯ play/pause"
            echo "  unload     - Disable all mappings"
            echo "  status     - Show current status"
            echo "  version    - Show version info"
            echo ""
            echo "Or run without arguments for interactive menu."
            ;;
        *)
            echo "Usage: $0 {backlight|media|combo|unload|status|version|help}"
            echo "Or run without arguments for interactive menu."
            ;;
    esac
    exit 0
fi

# ─────────────────────────────────────────────────────────────────────────────────
# Interactive Menu
# ─────────────────────────────────────────────────────────────────────────────────

while true; do
    clear_screen
    print_header
    print_status
    print_menu
    
    echo -ne "${WHITE}  Enter your choice: ${CYAN}"
    read choice
    echo -e "${NC}"
    
    case $choice in
        1)
            preset_backlight
            press_enter
            ;;
        2)
            preset_media
            press_enter
            ;;
        3)
            preset_backlight_media
            press_enter
            ;;
        4)
            custom_builder
            press_enter
            ;;
        5)
            unload_mapping
            press_enter
            ;;
        6)
            show_details
            press_enter
            ;;
        7)
            show_help
            press_enter
            ;;
        0)
            clear_screen
            echo -e "${GREEN}  👋 Goodbye!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}  ❌ Invalid option. Please try again.${NC}"
            sleep 1
            ;;
    esac
done
