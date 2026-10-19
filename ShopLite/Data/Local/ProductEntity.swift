import Foundation
import SwiftData

@Model
final class ProductEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var details: String
    var category: String
    var price: Double
    var discountPercentage: Double
    var rating: Double
    var stock: Int
    var brand: String?
    var thumbnail: String
    var images: String?
    var tags: String?
    var reviews: String?
    var availabilityStatus: String?

    init(product: Product, converters: Converters = Converters()) {
        id = product.id
        title = product.title
        details = product.description
        category = product.category
        price = product.price
        discountPercentage = product.discountPercentage
        rating = product.rating
        stock = product.stock
        brand = product.brand
        thumbnail = product.thumbnail
        images = converters.fromStringList(product.images)
        tags = converters.fromStringList(product.tags)
        reviews = converters.fromReviews(product.reviews)
        availabilityStatus = product.availabilityStatus
    }

    func toProduct(converters: Converters = Converters()) -> Product {
        Product(
            id: id, title: title, description: details, category: category, price: price,
            discountPercentage: discountPercentage, rating: rating, stock: stock, brand: brand,
            thumbnail: thumbnail, images: converters.toStringList(images), tags: converters.toStringList(tags),
            reviews: converters.toReviews(reviews), availabilityStatus: availabilityStatus
        )
    }
}
