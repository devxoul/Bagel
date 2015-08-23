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
    public var indicator: NSProgressIndicator!


    public func openDocument(sender: AnyObject?) {

    }

}


// MARK: - NSApplicationDelegate

extension AppDelegate: NSApplicationDelegate {

    public func applicationDidFinishLaunching(aNotification: NSNotification) {
        let contentRect = NSRect(x: 0, y: 0, width: 300, height: 300)
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

        let openButton = NSButton(frame: NSRect.zeroRect)
        openButton.title = "Open..."
        openButton.bezelStyle = .RegularSquareBezelStyle
        openButton.setButtonType(.MomentaryLightButton)
        openButton.sizeToFit()
        openButton.frame.origin.x = (self.window.frame.width - openButton.frame.width) / 2
        openButton.frame.origin.y = (self.window.frame.height - openButton.frame.height) / 2
        openButton.target = self
        openButton.action = "openDocument:"

        self.indicator = NSProgressIndicator()
        self.indicator.style = .SpinningStyle
        self.indicator.controlSize = .SmallControlSize
        self.indicator.displayedWhenStopped = false
        self.indicator.sizeToFit()
        self.indicator.frame.origin.x = openButton.frame.midX - self.indicator.frame.width / 2
        self.indicator.frame.origin.y = openButton.frame.minY - self.indicator.frame.height - 5

        self.window.contentView.addSubview(openButton)
        self.window.contentView.addSubview(self.indicator)
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
