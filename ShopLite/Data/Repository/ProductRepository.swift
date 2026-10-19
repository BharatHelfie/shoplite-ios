import Foundation
import os

@MainActor
final class ProductRepository {
    private let api: ApiService
    private let dao: ProductDao
    private let defaults: UserDefaults
    private let logger = Logger(subsystem: "com.shoplite.app", category: "ProductRepository")

    init(
        api: ApiService = NetworkModule.provideApiService(),
        dao: ProductDao = DatabaseModule.provideProductDao(),
        defaults: UserDefaults = .standard
    ) {
        self.api = api
        self.dao = dao
        self.defaults = defaults
    }

    // Gets products for the given page.
    // Uses the local database as a cache so the app also works offline.
    func doIt(page: Int) async throws -> [Product] {
        if page == 0 {
            let cached = try await dao.getAll()
            if !cached.isEmpty {
                return cached
            }
        }
        do {
            let res = try await api.getProducts(limit: Self.pageSize, skip: page * Self.pageSize)
            try await dao.deleteAll()
            try await dao.insertAll(res.products)
            defaults.set(Date().timeIntervalSince1970 * 1000, forKey: "last_sync")
            return res.products
        } catch {
            logger.error("doIt failed: \(error)")
            return try await dao.getAll()
        }
    }

    // Returns a single product from the cache
    func getOne(id: Int) throws -> Product? { try dao.getById(id) }

    // Returns true if the cache is older than 24 hours
    func isOld() -> Bool {
        let last = defaults.double(forKey: "last_sync")
        return Date().timeIntervalSince1970 * 1000 - last > 24 * 60 * 60 * 1000
    }

    static let pageSize = 20
}
