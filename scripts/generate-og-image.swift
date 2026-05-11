#!/usr/bin/env swift

// Generates a 1200×630 Open Graph share image: terminal-style "<S>" logo,
// "SENDRACORP" wordmark, and tagline on the studio's dark background.

import Foundation
import AppKit

let width = 1200
let height = 630
let colorSpace = CGColorSpaceCreateDeviceRGB()

guard let ctx = CGContext(
    data: nil,
    width: width,
    height: height,
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
ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))

// Inset frame (mimics .grid-border on the page)
let inset: CGFloat = 80
let frameRect = CGRect(
    x: inset,
    y: inset,
    width: CGFloat(width) - inset * 2,
    height: CGFloat(height) - inset * 2
)
ctx.setStrokeColor(CGColor(red: 0, green: 1.0, blue: 0.53, alpha: 0.18))
ctx.setLineWidth(1.5)
ctx.stroke(frameRect)

// Corner marker squares at each corner of the frame
let cornerSize: CGFloat = 14
ctx.setStrokeColor(CGColor(red: 0, green: 1.0, blue: 0.53, alpha: 0.5))
ctx.setLineWidth(1.5)
let corners: [(CGFloat, CGFloat)] = [
    (frameRect.minX, frameRect.maxY),
    (frameRect.maxX, frameRect.maxY),
    (frameRect.minX, frameRect.minY),
    (frameRect.maxX, frameRect.minY),
]
for (cx, cy) in corners {
    ctx.stroke(CGRect(
        x: cx - cornerSize / 2,
        y: cy - cornerSize / 2,
        width: cornerSize,
        height: cornerSize
    ))
}

// Draws an attributed string with its visual center at imageY (bottom-left origin).
func drawCentered(_ str: NSAttributedString, visualCenterY y: CGFloat) {
    let line = CTLineCreateWithAttributedString(str)
    let bounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
    let baselineY = y - (bounds.origin.y + bounds.height / 2)
    let x = (CGFloat(width) - bounds.width) / 2 - bounds.origin.x
    ctx.textPosition = CGPoint(x: x, y: baselineY)
    CTLineDraw(line, ctx)
}

// Logo: <S>
let logoFont = CTFontCreateWithName("Menlo-Bold" as CFString, 180, nil)
let logoAttrs: [NSAttributedString.Key: Any] = [
    .font: logoFont,
    .foregroundColor: NSColor(red: 0, green: 1.0, blue: 0.53, alpha: 0.9),
    .kern: 24
]
drawCentered(
    NSAttributedString(string: "<S>", attributes: logoAttrs),
    visualCenterY: 400
)

// Wordmark: SENDRACORP
let wordmarkFont = CTFontCreateWithName("Menlo-Bold" as CFString, 56, nil)
let wordmarkAttrs: [NSAttributedString.Key: Any] = [
    .font: wordmarkFont,
    .foregroundColor: NSColor(red: 0.88, green: 0.88, blue: 0.91, alpha: 1.0),
    .kern: 18
]
drawCentered(
    NSAttributedString(string: "SENDRACORP", attributes: wordmarkAttrs),
    visualCenterY: 220
)

// Tagline
let taglineFont = CTFontCreateWithName("Menlo-Regular" as CFString, 22, nil)
let taglineAttrs: [NSAttributedString.Key: Any] = [
    .font: taglineFont,
    .foregroundColor: NSColor(red: 0, green: 1.0, blue: 0.53, alpha: 0.65),
    .kern: 12
]
drawCentered(
    NSAttributedString(string: "INDEPENDENT SOFTWARE STUDIO", attributes: taglineAttrs),
    visualCenterY: 155
)

guard let cgImage = ctx.makeImage() else {
    print("error: failed to make image")
    exit(1)
}

let bitmap = NSBitmapImageRep(cgImage: cgImage)
guard let data = bitmap.representation(using: .png, properties: [:]) else {
    print("error: failed to encode PNG")
    exit(1)
}

let outputPath = "public/og-image.png"
try! data.write(to: URL(fileURLWithPath: outputPath))
print("wrote \(data.count) bytes → \(outputPath) (\(width)×\(height))")
