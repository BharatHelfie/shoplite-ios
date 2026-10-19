import Foundation

final class CartRepository {
    private let defaults: UserDefaults
    private let api: ApiService
    private var items: [CartItem] = []

    init(defaults: UserDefaults = .standard, api: ApiService = NetworkModule.provideApiService()) {
        self.defaults = defaults
        self.api = api
        items = load()
    }

    // Adds a product to the cart
    func process(_ p: Product, qty: Int = 1) async throws -> Bool {
        if let existing = items.first(where: { $0.productId == p.id }) {
            existing.quantity += qty
        } else {
            items.append(CartItem(productId: p.id, title: p.title, price: p.price, discountPercentage: p.discountPercentage, thumbnail: p.thumbnail, quantity: qty))
        }
        save()
        let userId = defaults.object(forKey: "user_id") as? Int ?? 1
        let res = try await api.addToCart(AddCartRequest(userId: userId, products: [AddCartProduct(id: p.id, quantity: qty)]))
        return res.isSuccessful
    }

    // Removes a product from the cart
    func remove(id: Int) {
        items.removeAll { $0.productId == id }
        save()
    }

    // Returns everything in the cart
    func get() -> [CartItem] { items }

    // Returns number of items in the cart
    func size() -> Int { items.reduce(0) { $0 + $1.quantity } }

    private func load() -> [CartItem] {
        guard let json = defaults.string(forKey: "cart") else { return [] }
        return try! JSONDecoder().decode([CartItem].self, from: Data(json.utf8))
    }

    private func save() {
        defaults.set(String(decoding: try! JSONEncoder().encode(items), as: UTF8.self), forKey: "cart")
    }
}
