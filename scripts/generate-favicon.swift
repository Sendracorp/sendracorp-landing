#!/usr/bin/env swift

// Generates a 32×32 favicon.png: green terminal "S" on a dark background,
// matching the landing page's retro aesthetic.

import Foundation
import AppKit

let size = 32
let colorSpace = CGColorSpaceCreateDeviceRGB()

guard let ctx = CGContext(
    data: nil,
    width: size,
    height: size,
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace,
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
) else {
    print("error: failed to create context")
    exit(1)
}

// Background: #0a0a0f
ctx.setFillColor(CGColor(red: 0.04, green: 0.04, blue: 0.06, alpha: 1.0))
ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))

// Draw the "S" in terminal green
let font = CTFontCreateWithName("Menlo-Bold" as CFString, 24, nil)
let attrs: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: NSColor(red: 0, green: 1.0, blue: 0.53, alpha: 0.9)
]
let str = NSAttributedString(string: "S", attributes: attrs)
let line = CTLineCreateWithAttributedString(str)
let bounds = CTLineGetBoundsWithOptions(line, [])

// Center the glyph
let x = (CGFloat(size) - bounds.width) / 2 - bounds.origin.x
let y = (CGFloat(size) - bounds.height) / 2 - bounds.origin.y

ctx.textPosition = CGPoint(x: x, y: y)
CTLineDraw(line, ctx)

guard let cgImage = ctx.makeImage() else {
    print("error: failed to make image")
    exit(1)
}

let bitmap = NSBitmapImageRep(cgImage: cgImage)
guard let data = bitmap.representation(using: .png, properties: [:]) else {
    print("error: failed to encode PNG")
    exit(1)
}

let outputPath = "public/favicon.png"
try! data.write(to: URL(fileURLWithPath: outputPath))
print("wrote \(data.count) bytes → \(outputPath)")
