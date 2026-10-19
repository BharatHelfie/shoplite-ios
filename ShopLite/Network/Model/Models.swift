import Foundation

struct Product: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let thumbnail: String
    let images: [String]?
    let tags: [String]?
    let reviews: [Review]?
    let availabilityStatus: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case category = "category"
        case price = "price"
        case discountPercentage = "discountPercentage"
        case rating = "rating"
        case stock = "stock"
        case brand = "brand"
        case thumbnail = "thumbnail"
        case images = "images"
        case tags = "tags"
        case reviews = "reviews"
        case availabilityStatus = "availabilityStatus"
    }
}

struct Review: Codable, Hashable {
    let rating: Int
    let comment: String
    let date: String
    let reviewerName: String
    let reviewerEmail: String
}

struct ProductsResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct LoginRequest: Codable {
    let username: String
    let password: String
    let expiresInMins: Int
}

struct LoginResponse: Codable {
    let id: Int
    let username: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let image: String?
    let accessToken: String?
    let refreshToken: String?
}

struct RefreshRequest: Codable {
    let refreshToken: String
    let expiresInMins: Int
}

struct UserProfile: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let image: String?
}

struct AddCartRequest: Codable {
    let userId: Int
    let products: [AddCartProduct]
}

struct AddCartProduct: Codable {
    let id: Int
    let quantity: Int
}

struct CartResponse: Codable {
    let id: Int
    let total: Double
    let discountedTotal: Double
    let totalProducts: Int
}

final class CartItem: Codable {
    let productId: Int
    let title: String
    let price: Double
    let discountPercentage: Double
    let thumbnail: String
    var quantity: Int

    init(productId: Int, title: String, price: Double, discountPercentage: Double, thumbnail: String, quantity: Int) {
        self.productId = productId
        self.title = title
        self.price = price
        self.discountPercentage = discountPercentage
        self.thumbnail = thumbnail
        self.quantity = quantity
    }
}
