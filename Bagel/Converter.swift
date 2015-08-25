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

public func convert(path: String, completion: (String? -> Void)? = nil) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        if let giffile = _convert(path) {
            dispatch_async(dispatch_get_main_queue()) {
                completion?(giffile)
            }
        }
    }
}

private func _convert(path: String) -> String? {
    guard let ffmpeg = NSBundle.mainBundle().pathForResource("ffmpeg", ofType: nil) else { return nil }
    guard let convert = NSBundle.mainBundle().pathForResource("convert", ofType: nil) else { return nil }
    guard let gifsicle = NSBundle.mainBundle().pathForResource("gifsicle", ofType: nil) else { return nil }

    let filename = path.lastPathComponent.stringByDeletingPathExtension
    let tempDir = NSTemporaryDirectory().stringByAppendingPathComponent(filename)
    let target = path.stringByDeletingPathExtension + ".gif"

    NSLog("filename: \(filename)")
    NSLog("tempDir: \(tempDir)")
    NSLog("target: \(target)")

    let fileManager = NSFileManager.defaultManager()
    defer {
        NSLog("Removing '\(tempDir)'...")
        do {
            try fileManager.removeItemAtPath(tempDir)
        } catch _ {}
    }

    NSLog("Removing '\(tempDir)'...")
    do {
        try fileManager.removeItemAtPath(tempDir)
    } catch _ {}

    NSLog("Creating '\(tempDir)'...")
    do {
        try fileManager.createDirectoryAtPath(tempDir, withIntermediateDirectories: true, attributes: nil)
    } catch _ {
        return nil
    }

    NSLog("Mapping...")
    if sh("\(ffmpeg) -i \(path) -r 30 -vcodec png \(tempDir)/out-static-%05d.png") != 0 {
        return nil
    }

    NSLog("Reducing...")
    if sh("time \(convert) -verbose +dither -layers Optimize -resize 600x600\\> \(tempDir)/out-static*.png GIF:-" +
          " | \(gifsicle) --colors 256 --loop --optimize=3 --delay 3 --multifile - > \(target)") != 0 {
        return nil
    }

    return target
}

private func sh(command: String) -> Int32 {
    NSLog(command)
    let task = NSTask.launchedTaskWithLaunchPath("/bin/sh", arguments: ["-c", command])
    task.waitUntilExit()
    return task.terminationStatus
}
