import Foundation
import SwiftData

enum DatabaseModule {

    @MainActor static let database = provideDatabase()

    @MainActor static func provideProductDao() -> ProductDao {
        ProductDao(context: database.mainContext)
    }

    private static func provideDatabase() -> ModelContainer {
        let configuration = ModelConfiguration("shoplite")
        if let container = try? ModelContainer(for: ProductEntity.self, configurations: configuration) {
            return container
        }
        try? FileManager.default.removeItem(at: configuration.url)
        return try! ModelContainer(for: ProductEntity.self, configurations: configuration)
    }
}
