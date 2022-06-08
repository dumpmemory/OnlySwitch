//
//  SwitchType.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2021/12/1.
//

import AppKit

struct SwitchBarInfo {
    let title:String
    let onImage:NSImage
    let offImage:NSImage
    var controlType:ControlType = .Switch
    var category:SwitchCategory = .none
}

enum SwitchType:UInt64, CaseIterable {
    case hiddeDesktop = 1 //1 << 0
    case darkMode = 2 // 1 << 1
    case topNotch = 4 // 1 << 2
    case mute = 8 // 1 << 3
    case keepAwake = 16 // 1 << 4
    case screenSaver = 32 // 1 << 5
    case nightShift = 64 // 1 << 6
    case autohideDock = 128 // 1 << 7
    case autohideMenuBar = 256 // 1 << 8
    case airPods = 512 // 1 << 9
    case bluetooth = 1024 // 1 << 10
    case xcodeCache = 2048 // 1 << 11
    case hiddenFiles = 4096 // 1 << 12
    case radioStation = 8192 // 1 << 13
    case emptyTrash = 16384 // 1 << 14
    case emptyPasteboard = 32768 // 1 << 15
    case showUserLibrary = 65536 // 1 << 16
    case showExtensionName = 131072 // 1 << 17
    case pomodoroTimer = 262144 // 1 << 18
    case smallLaunchpadIcon = 524288 // 1 << 19
    case lowpowerMode = 1048576 // 1 << 20
    case muteMicrophone = 2097152 // 1 << 21
    case showFinderPathbar = 4194304 // 1 << 22
    case dockRecent = 8388608 // 1 << 23
    case spotify = 16777216 // 1 << 24
    case applemusic = 33554432 // 1 << 25
    case screenTest = 67108864 // 1 << 26
    case hideMenubarIcons = 134217728 // 1 << 27
    
    func barInfo() -> SwitchBarInfo {
        switch self {
        case .hiddeDesktop:
            return SwitchBarInfo(title:"Hide Desktop",
                                 onImage:NSImage(named: "desktopcomputer")!,
                                 offImage:NSImage(named: "desktop_with_icon")!)
        case .darkMode:
            return SwitchBarInfo(title:"Dark Mode",
                                 onImage:NSImage(named: "darkmode_on")!,
                                 offImage: NSImage(named: "darkmode_off")!)
        case .topNotch:
            return SwitchBarInfo(title:"Hide Notch",
                                 onImage:NSImage(named:"laptopnotchhidden")!,
                                 offImage: NSImage(named: "laptopwithnotch")!)
        case .mute:
            return SwitchBarInfo(title: "Mute",
                                 onImage: NSImage(systemSymbolName: "speaker.slash.circle"),
                                 offImage: NSImage(systemSymbolName: "speaker.wave.2.circle"),
                                 category: .audio)
        case .keepAwake:
            return SwitchBarInfo(title: "Keep Awake",
                                onImage: NSImage(systemSymbolName: "lock.slash.fill"),
                                offImage: NSImage(systemSymbolName: "lock.slash"))
        case .screenSaver:
            return SwitchBarInfo(title: "Screen Saver",
                                 onImage: NSImage(systemSymbolName: "display"),
                                 offImage: NSImage(systemSymbolName: "display"))
        case .nightShift:
            return SwitchBarInfo(title: "Night Shift",
                                 onImage: NSImage(systemSymbolName: "moon.stars.fill"),
                                 offImage: NSImage(systemSymbolName: "moon.stars"))
        case .autohideDock:
            return SwitchBarInfo(title: "Autohide Dock",
                                 onImage: NSImage(systemSymbolName: "dock.arrow.down.rectangle"),
                                 offImage: NSImage(systemSymbolName: "dock.rectangle"))
        case .autohideMenuBar:
            return SwitchBarInfo(title: "Autohide Menu Bar",
                                 onImage: NSImage(systemSymbolName: "menubar.arrow.up.rectangle"),
                                 offImage: NSImage(systemSymbolName: "menubar.rectangle"))
        case .airPods:
            return SwitchBarInfo(title: "AirPods",
                                 onImage: NSImage(systemSymbolName: "airpodspro"),
                                 offImage: NSImage(systemSymbolName: "airpodspro"),
                                 category: .audio)
        case .bluetooth:
            return SwitchBarInfo(title: "Bluetooth",
                                 onImage: NSImage(named: "bluetooth_on")!,
                                 offImage: NSImage(named: "bluetooth_off")!)
        case .xcodeCache:
            return SwitchBarInfo(title: "Xcode Derived Data",
                                 onImage: NSImage(systemSymbolName: "hammer.circle.fill"),
                                 offImage: NSImage(systemSymbolName: "hammer.circle"),
                                 controlType: .Button,
                                 category: .cleanup)
        case .hiddenFiles:
            return SwitchBarInfo(title: "Show Hidden Files",
                                 onImage: NSImage(systemSymbolName: "eye"),
                                 offImage: NSImage(systemSymbolName: "eye.slash"))
        case .radioStation:
            return SwitchBarInfo(title: "Radio Player",
                                 onImage: NSImage(systemSymbolName: "radio"),
                                 offImage: NSImage(systemSymbolName: "radio"),
                                 category: .audio)
        case .emptyTrash:
            return SwitchBarInfo(title: "Empty Trash",
                                 onImage: NSImage(systemSymbolName: "trash"),
                                 offImage: NSImage(systemSymbolName: "trash"),
                                 controlType: .Button,
                                 category: .cleanup)
        case .emptyPasteboard:
            return SwitchBarInfo(title: "Empty Pasteboard",
                                 onImage: NSImage(systemSymbolName: "doc.on.clipboard"),
                                 offImage: NSImage(systemSymbolName: "doc.on.clipboard"),
                                 controlType: .Button,
                                 category: .cleanup)
        case .showUserLibrary:
            return SwitchBarInfo(title: "Show User Library",
                                 onImage: NSImage(systemSymbolName: "building.columns.fill"),
                                 offImage: NSImage(systemSymbolName: "building.columns"))
        case .showExtensionName:
            return SwitchBarInfo(title: "Show Extension Name",
                                 onImage: NSImage(named: "extension_on")!,
                                 offImage: NSImage(named: "extension_off")!)
        case .pomodoroTimer:
            return SwitchBarInfo(title: "Pomodoro Timer",
                                 onImage: NSImage(systemSymbolName: "timer"),
                                 offImage: NSImage(systemSymbolName: "timer"))
        case .smallLaunchpadIcon:
            return SwitchBarInfo(title: "Small Launchpad Icon",
                                 onImage: NSImage(systemSymbolName: "square.grid.4x3.fill"),
                                 offImage: NSImage(systemSymbolName: "square.grid.4x3.fill"))
        case .lowpowerMode:
            return SwitchBarInfo(title: "Low Power Mode",
                                 onImage: NSImage(systemSymbolName: "bolt.circle"),
                                 offImage: NSImage(systemSymbolName: "bolt.circle.fill"))
        case .muteMicrophone:
            return SwitchBarInfo(title: "Mute Mic",
                                 onImage: NSImage(systemSymbolName: "mic.slash.circle"),
                                 offImage: NSImage(systemSymbolName: "mic.circle"),
                                 category: .audio)
        case .showFinderPathbar:
            return SwitchBarInfo(title: "Show Finder Path Bar",
                                 onImage: NSImage(systemSymbolName: "greaterthan.square.fill"),
                                 offImage: NSImage(systemSymbolName: "greaterthan.square"))
        case .dockRecent:
            return SwitchBarInfo(title: "Recent Apps in Dock",
                                 onImage: NSImage(named: "dock_recent_on")!,
                                 offImage: NSImage(named: "dock_recent_off")!)
        case .spotify:
            return SwitchBarInfo(title: "Spotify",
                                 onImage: NSImage(named: "spotify_icon")!,
                                 offImage: NSImage(named: "spotify_icon")!)
        case .applemusic:
            return SwitchBarInfo(title: "Apple Music",
                                 onImage: NSImage(named: "apple_music_icon")!,
                                 offImage: NSImage(named: "apple_music_icon")!)
        case .screenTest:
            return SwitchBarInfo(title: "Screen Test",
                                 onImage: NSImage(systemSymbolName: "display.trianglebadge.exclamationmark"),
                                 offImage: NSImage(systemSymbolName: "display.trianglebadge.exclamationmark"))
        case .hideMenubarIcons:
            return SwitchBarInfo(title: "Hide Menu Bar Icons",
                                 onImage: NSImage(named: "mark_icon")!,
                                 offImage: NSImage(named: "mark_icon_off")!)
        }
    }
    
}

let switchTypeCount = SwitchType.allCases.count

enum ControlType{
    case Switch
    case Button
}

enum SwitchCategory{
    case none
    case audio
    case cleanup
    case tool
}


