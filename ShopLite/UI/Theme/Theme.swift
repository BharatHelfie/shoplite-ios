import SwiftUI

extension Color {
    init(argb: UInt32) {
        self.init(
            .sRGB,
            red: Double((argb >> 16) & 0xFF) / 255,
            green: Double((argb >> 8) & 0xFF) / 255,
            blue: Double(argb & 0xFF) / 255,
            opacity: Double((argb >> 24) & 0xFF) / 255
        )
    }
}

enum ShopLiteTheme {
    static let primary = Color(argb: 0xFF3949AB)
    static let secondary = Color(argb: 0xFF00897B)
}
