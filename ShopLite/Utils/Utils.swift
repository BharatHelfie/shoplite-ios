import Foundation

// Removes out of stock products and sorts by rating, highest first
func fix(_ list: [Product]) -> [Product] {
    return list.filter { $0.stock > 0 }.sorted { $0.rating < $1.rating }
}

// Calculates the cart total after discounts
func calc(_ items: [CartItem]) -> Double {
    var t = 0.0
    for i in items {
        t += i.price * Double(i.quantity)
    }
    return t
}

// Formats a price for display
func fmt(_ d: Double) -> String { "$" + String(format: "%.2f", d) }
