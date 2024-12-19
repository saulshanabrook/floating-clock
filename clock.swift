// https://gist.github.com/blackgear/8dff1be2aecf62becc1718fd4e7ca675
// The MIT License

// Copyright (c) 2018 Daniel

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// How to build:
// $ swiftc -o clock -gnone -O -target x86_64-apple-macosx10.14 clock.swift
// How to run:
// $ ./clock

import Cocoa

class Clock: NSObject, NSApplicationDelegate {
    var dater : NSWindow?
    var timer : NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.initTimer()
    }

    func initLabel(font: NSFont, format: String, interval: TimeInterval) -> NSTextField {
        let formatter = DateFormatter()
        formatter.dateFormat = format

        let label = NSTextField()
        label.font = font
        label.isBezeled = false
        label.isEditable = false
        label.drawsBackground = false
        label.alignment = .center
        label.textColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1-(1/3)*(1/3))

        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            label.stringValue = formatter.string(from: Date())
        }
        timer.tolerance = interval / 10
        timer.fire()

        return label
    }

    func initWindow(rect: NSRect, label: NSTextField) -> NSWindow {
        let window = NSWindow(
            contentRect : rect,
            styleMask   : .borderless,
            backing     : .buffered,
            defer       : true
        )

        window.contentView = label
        window.ignoresMouseEvents = true
        window.level = .floating
        window.collectionBehavior = .canJoinAllSpaces
        window.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1/3)
        window.orderFrontRegardless()

        return window
    }

    func initTimer() {
        let label = self.initLabel(
            font     : NSFont.monospacedDigitSystemFont(ofSize: 36, weight: .regular),
            format   : "HH:mm",
            interval : 1
        )
        let screenWidth = NSScreen.main?.frame.width ?? 0
        let windowWidth: CGFloat = 120
        let xPosition = screenWidth - windowWidth

        self.timer = self.initWindow(
            rect     : NSMakeRect(xPosition, 0, windowWidth, 46),
            label    : label
        )
    }
}

let app = NSApplication.shared
let clock = Clock()
app.delegate = clock
app.setActivationPolicy(.accessory)
app.run()
