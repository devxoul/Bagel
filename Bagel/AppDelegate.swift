//
// Copyright (c) 2015 Suyeol Jeon (http://xoul.kr)
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program; if not, write to the Free Software Foundation, Inc.,
// 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//

import Cocoa

public class AppDelegate: NSObject {

    public var window: NSWindow!
    public var openButton: NSButton!
    public var indicator: NSProgressIndicator!
    public var label: NSTextField!


    public func openDocument(sender: AnyObject?) {
        let openPanel = NSOpenPanel()
        openPanel.title = "Choose a movie file"
        openPanel.showsResizeIndicator = true
        openPanel.showsHiddenFiles = true
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["mov", "avi", "mp4", "flv"]
        openPanel.beginSheetModalForWindow(self.window) { result in
            guard result == NSModalResponseOK else { return }

            if let path = openPanel.URLs.first?.path?.stringByResolvingSymlinksInPath {
                self.openButton.hidden = true
                self.indicator.startAnimation(nil)
                self.displayMessage("Converting...", color: NSColor.grayColor())

                convert(path) { gif in
                    self.openButton.hidden = false
                    self.indicator.stopAnimation(nil)
                    if gif != nil {
                        self.displayMessage("✓", color: NSColor(red: 0, green: 0.6, blue: 0, alpha: 1))
                    } else {
                        self.displayMessage("✗", color: NSColor(red: 0.6, green: 0, blue: 0, alpha: 1))
                    }
                }
            }
        }
    }

    private func displayMessage(string: String, color: NSColor) {
        self.label.stringValue = string
        self.label.textColor = color
        self.label.sizeToFit()
        self.label.frame.origin.x = self.openButton.frame.midX - self.label.frame.width / 2
        self.label.frame.origin.y = self.openButton.frame.minY - self.label.frame.height - 5
    }

}


// MARK: - NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {

    public func applicationDidFinishLaunching(aNotification: NSNotification) {
        let contentRect = NSRect(x: 0, y: 0, width: 300, height: 200)
        let styleMask = NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
        self.window = NSWindow(contentRect: contentRect, styleMask: styleMask, backing: .Buffered, `defer`: false)
        self.window.title = "Bagel"
        self.window.hasShadow = true
        self.window.opaque = false
        self.window.movableByWindowBackground = true
        self.window.backgroundColor = NSColor.whiteColor()
        self.window.delegate = self
        self.window.center()
        self.window.makeKeyAndOrderFront(nil)

        self.openButton = NSButton(frame: NSRect.zeroRect)
        self.openButton.title = "Open..."
        self.openButton.bezelStyle = .RegularSquareBezelStyle
        self.openButton.setButtonType(.MomentaryLightButton)
        self.openButton.sizeToFit()
        self.openButton.frame.origin.x = (self.window.frame.width - self.openButton.frame.width) / 2
        self.openButton.frame.origin.y = (self.window.frame.height - self.openButton.frame.height) / 2
        self.openButton.target = self
        self.openButton.action = "openDocument:"

        self.indicator = NSProgressIndicator()
        self.indicator.style = .SpinningStyle
        self.indicator.controlSize = .SmallControlSize
        self.indicator.displayedWhenStopped = false
        self.indicator.sizeToFit()
        self.indicator.frame.origin.x = (self.window.frame.width - self.indicator.frame.width) / 2
        self.indicator.frame.origin.y = (self.window.frame.height - self.indicator.frame.height) / 2

        self.label = NSTextField()
        self.label.alignment = .Center
        self.label.selectable = false
        self.label.editable = false
        self.label.bezeled = false
        self.displayMessage("Select a movie file.", color: NSColor.grayColor())

        self.window.contentView.addSubview(self.openButton)
        self.window.contentView.addSubview(self.indicator)
        self.window.contentView.addSubview(self.label)
    }

    public func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}


// MARK: - NSWindowDelegate

extension AppDelegate: NSWindowDelegate {

    public func windowWillClose(notification: NSNotification) {
        NSApp.terminate(nil)
    }
    
}
