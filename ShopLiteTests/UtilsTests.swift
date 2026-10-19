import Testing
@testable import ShopLite

struct UtilsTests {

    private func product(id: Int, rating: Double, stock: Int) -> Product {
        Product(
            id: id, title: "P\(id)", description: "", category: "c", price: 10.0,
            discountPercentage: 0.0, rating: rating, stock: stock, brand: nil,
            thumbnail: "", images: nil, tags: nil, reviews: nil, availabilityStatus: nil
        )
    }

    @Test
    func fixWorks() {
        let result = fix([product(id: 1, rating: 4.5, stock: 3), product(id: 2, rating: 3.0, stock: 0), product(id: 3, rating: 2.0, stock: 8)])
        #expect(result.map(\.id) == [3, 1])
    }

    @Test
    func calcWorks() {
        let items = [CartItem(productId: 1, title: "A", price: 10.0, discountPercentage: 10.0, thumbnail: "", quantity: 2), CartItem(productId: 2, title: "B", price: 5.0, discountPercentage: 0.0, thumbnail: "", quantity: 1)]
        #expect(abs(calc(items) - 25.0) < 0.001)
    }
}
