//
//  TopNotchSwitch.swift
//  OnlySwitch
//
//  Created by Jacklandrin on 2021/11/30.
//

import Cocoa
import UniformTypeIdentifiers

class TopNotchSwitch:SwitchProvider {
    static let shared = TopNotchSwitch()
    
    // Mark: - private properties
    
    private var currentImageName = ""
    private var notchHeight:CGFloat = 0
    
    
    // Mark: - SwitchProvider functions
    
    func currentStatus() -> Bool {
        
        let workspace = NSWorkspace.shared
        let appBundleID = Bundle.main.infoDictionary?["CFBundleName"] as! String
        guard let screen = getScreenWithMouse() else {return false}
        guard let path = workspace.desktopImageURL(for: screen) else {return false}
    
        if path.absoluteString.contains("/\(appBundleID)/processed") {
            currentImageName = path.lastPathComponent
            return true
        } else {
            return false
        }

    }
    
    
    func operationSwitch(isOn: Bool) async -> Bool {
        if isOn {
            return hiddenNotch()
        } else {
            return recoverNotch()
        }
    }
    
    func isVisable() -> Bool {
        return self.isNotchScreen
    }
    
    func currentInfo() -> String {
        return ""
    }
    
    func clearCache() {
        guard let myAppPath = myAppPath else {
            return
        }

        let processedPath = myAppPath.appendingPathComponent(string: "processed")
        let originalPath = myAppPath.appendingPathComponent(string: "original")
        var currentNames = [String]()
        let workspace = NSWorkspace.shared
        for screen in NSScreen.screens {
            if let path = workspace.desktopImageURL(for: screen){
                currentNames.append(path.lastPathComponent)
            }
        }
        
        let processedUrl = URL(fileURLWithPath: processedPath)
        let originalUrl = URL(fileURLWithPath: originalPath)
        
        removeAllFile(url: processedUrl, ignore: currentNames)
        removeAllFile(url: originalUrl, ignore: currentNames)
        
    }
    
    // Mark: - private functions
    
    private var isNotchScreen:Bool {
        if #available(macOS 12, *) {
            guard let screen = getScreenWithMouse() else {return false}
            guard let topLeftArea = screen.auxiliaryTopLeftArea, let _ = screen.auxiliaryTopRightArea else {return false}
            
            notchHeight = NSApplication.shared.mainMenu?.menuBarHeight ?? (topLeftArea.height + 5) //auxiliaryTopLeftArea is not equivalent to menubar's height
            print("get notchHeight:\(notchHeight)")
            return true
        } else {
            return false
        }
    }
    
    private var myAppPath:String? {
        let appBundleID = Bundle.main.infoDictionary?["CFBundleName"] as! String
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).map(\.path)
        let directory = paths.first
        let myAppPath = directory?.appendingPathComponent(string: appBundleID)
        return myAppPath
    }
    
    private func recoverNotch() -> Bool {
        let originalPath = myAppPath?.appendingPathComponent(string: "original", currentImageName)
        guard let originalPath = originalPath else {return false}
        let success = setDesktopImageURL(url: URL(fileURLWithPath: originalPath))
        if success {
            let _ = currentStatus()
        }
        
        return success
    }
  
    private func hiddenNotch() -> Bool {
        let workspace = NSWorkspace.shared
        guard let screen = getScreenWithMouse() else {return false}
        guard let path = workspace.desktopImageURL(for: screen) else {return false}
        let appBundleID = Bundle.main.infoDictionary?["CFBundleName"] as! String
        if let myAppPath = myAppPath ,path.absoluteString.contains("/\(appBundleID)/original") {
            currentImageName = URL(fileURLWithPath: path.absoluteString).lastPathComponent
            let processdUrl = myAppPath.appendingPathComponent(string: "processed", currentImageName)
            if FileManager.default.fileExists(atPath: processdUrl) {
                return setDesktopImageURL(url: URL(fileURLWithPath: processdUrl))
            }
        }
        print("original path:\(path)")
        guard let currentWallpaperImage = NSImage(contentsOf: path) else {
            return false
        }
        if path.pathExtension == "heic" {
            let success = hideHeicDesktopNotch(image: currentWallpaperImage)
            let _ = currentStatus()
            return success
        } else {
            let success = hideSingleDesktopNotch(image: currentWallpaperImage)
            let _ = currentStatus()
            return success
        }
    }
    
    
    private func hideHeicDesktopNotch(image:NSImage) -> Bool {
        let finalImage = NSImage()
        let imageReps = image.representations
        for index in 0..<imageReps.count {
            if let imageRep = imageReps[index] as? NSBitmapImageRep {
                let nsImage = NSImage()
                nsImage.addRepresentation(imageRep)
                if let processedImageRep = hideNotchForEachImageOfHeic(image:nsImage) {
                    finalImage.addRepresentation(processedImageRep)
                }
            }
        }
        let imageName = UUID().uuidString
        guard let url = saveHeicData(image: finalImage, isProcessed: true, imageName: imageName) else {return false}
        let _ = saveHeicData(image: image, isProcessed: false, imageName: imageName)
        let success = setDesktopImageURL(url: url)
        return success
    }
    
    private func hideNotchForEachImageOfHeic(image:NSImage) -> NSBitmapImageRep? {
        guard let finalCGImage = addBlackRect(on: image) else {return nil}
        return NSBitmapImageRep(cgImage: finalCGImage)
    }
    
    
    
    private func hideSingleDesktopNotch(image:NSImage) -> Bool {
        
        let finalCGImage = addBlackRect(on: image)
        
        guard let finalCGImage = finalCGImage else {
            return false
        }

        let imageName = UUID().uuidString
        guard let imageUrl = saveCGImage(finalCGImage, isProcessed: true, imageName: imageName) else {return false}
        let _ = saveImage(image, isProcessed: false, imageName: imageName)
        
        return setDesktopImageURL(url:imageUrl)
    }
    
    
    private func addBlackRect(on image:NSImage) -> CGImage? {
        var screenSize:CGSize = .zero
        if let screen = getScreenWithMouse() {
            screenSize = screen.visibleFrame.size
            print("screenSize:\(screenSize)")
        }
        
        let nsscreenSize = NSSize(width: screenSize.width, height: screenSize.height)
        guard let resizeWallpaperImage = image.resizeMaintainingAspectRatio(withSize: nsscreenSize) else {return nil}
        
        var imageRect = CGRect(origin: .zero, size: CGSize(width: resizeWallpaperImage.width, height: resizeWallpaperImage.height))
        guard let cgwallpaper = resizeWallpaperImage.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
            return nil
        }
        
        guard let finalWallpaper = cgwallpaper.crop(toSize: screenSize) else {return nil}
        
        print("notchHeight\(notchHeight)")
        var finalCGImage:CGImage? = nil

        if let context = createContext(size: screenSize) {
            context.draw(finalWallpaper, in: CGRect(origin: .zero, size: screenSize))
            context.setFillColor(.black)
            context.fill(CGRect(origin: CGPoint(x: 0, y: screenSize.height - notchHeight), size: CGSize(width: screenSize.width, height: notchHeight)))
            finalCGImage = context.makeImage()
        }
        return finalCGImage
    }
    
    private func setDesktopImageURL(url:URL) -> Bool {
        do {
            let workspace = NSWorkspace.shared
            guard let screen = getScreenWithMouse() else {return false}
            try workspace.setDesktopImageURL(url, for: screen, options: [:])
        } catch {
            return false
        }
        return true
    }
    
    private func getScreenWithMouse() -> NSScreen? {
      let mouseLocation = NSEvent.mouseLocation
      let screens = NSScreen.screens
      let screenWithMouse = (screens.first { NSMouseInRect(mouseLocation, $0.frame, false) })
      return screenWithMouse
    }
    
    private func saveImage(_ image:NSImage, isProcessed:Bool, imageName:String) -> URL? {
        guard let destinationURL = saveDestination(isProcessed: isProcessed, imageName: imageName, type: "jpg") else {
            return nil
        }
        if image.jpgWrite(to: destinationURL, options: .withoutOverwriting) {
            print("destinationURL:\(destinationURL)")
            return destinationURL
        }
        return nil
    }
    
    private func saveCGImage(_ image: CGImage, isProcessed:Bool, imageName:String) -> URL? {
        guard let destinationURL = saveDestination(isProcessed: isProcessed, imageName: imageName, type: "jpg") else {
            return nil
        }
        let cfdestinationURL = destinationURL as CFURL
        let destination = CGImageDestinationCreateWithURL(cfdestinationURL, kUTTypeJPEG, 1, nil)
        guard let destination = destination else {return nil}
        CGImageDestinationAddImage(destination, image, nil)
        if !CGImageDestinationFinalize(destination) {
            return nil
        }
        return destinationURL as URL
    }
    
    
    private func saveHeicData(image:NSImage, isProcessed:Bool, imageName:String) -> URL? {
        
        guard let destinationURL = saveDestination(isProcessed: isProcessed, imageName: imageName, type: "heic") else {
            return nil
        }
        if image.heicWrite(to: destinationURL, options: .withoutOverwriting) {
            print("destinationURL:\(destinationURL)")
            return destinationURL
        }
        return nil
    }
    
    private func saveDestination(isProcessed:Bool, imageName:String, type:String) -> URL? {
        let imagePath = myAppPath?.appendingPathComponent(string: isProcessed ? "processed" : "original")
        guard let imagePath = imagePath else {return nil}
        if !FileManager.default.fileExists(atPath: imagePath) {
            do {
                try FileManager.default.createDirectory(atPath: imagePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        let destinationPath = imagePath.appendingPathComponent(string: "\(imageName).\(type)")
        let destinationURL = URL(fileURLWithPath: destinationPath)
        return destinationURL
    }
    
    private func createContext(size: CGSize) -> CGContext? {
        return CGContext(data: nil,
                         width: Int(size.width),
                         height: Int(size.height),
                         bitsPerComponent: 8,
                         bytesPerRow: 0,
                         space: CGColorSpaceCreateDeviceRGB(),
                         bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
    }
    
    private func removeAllFile(url:URL, ignore:[String]) {
        do {
            let fileUrls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for fileUrl in fileUrls {
                if !ignore.contains(fileUrl.lastPathComponent) {
                    try FileManager.default.removeItem(at: fileUrl)
                }
            }
        } catch {
            
        }
    }
}