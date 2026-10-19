import Foundation
import Observation

@Observable
@MainActor
final class CartViewModel {
    var items: [CartItem]
    var total: Double

    private let cartRepo: CartRepository

    init(cartRepo: CartRepository = CartRepository()) {
        self.cartRepo = cartRepo
        items = cartRepo.get()
        total = calc(cartRepo.get())
    }

    // Removes an item from the cart
    func delete(id: Int) {
        cartRepo.remove(id: id)
        items = cartRepo.get()
        total = calc(items)
    }
}
