import Foundation
import SwiftData

@MainActor
final class ProductDao {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getAll() async throws -> [Product] {
        try context.fetch(FetchDescriptor<ProductEntity>()).map { $0.toProduct() }
    }

    func getById(_ id: Int) throws -> Product? {
        try context.fetch(FetchDescriptor<ProductEntity>(predicate: #Predicate { $0.id == id })).first?.toProduct()
    }

    func insertAll(_ products: [Product]) async throws {
        products.forEach { context.insert(ProductEntity(product: $0)) }
        try context.save()
    }

    func deleteAll() async throws {
        try context.delete(model: ProductEntity.self)
        try context.save()
    }
}
