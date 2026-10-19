import Foundation
import Combine

struct DetailState {
    var product: Product? = nil
    var loading = false
    var error: String? = nil
    var message: String? = nil
}

@MainActor
final class ProductDetailViewModel: ObservableObject {
    @Published private(set) var state = DetailState()

    private let api: ApiService
    private let repo: ProductRepository
    private let cartRepo: CartRepository

    init(
        api: ApiService = NetworkModule.provideApiService(),
        repo: ProductRepository = ProductRepository(),
        cartRepo: CartRepository = CartRepository()
    ) {
        self.api = api
        self.repo = repo
        self.cartRepo = cartRepo
    }

    // Loads the product for the screen
    func getIt(id: Int) {
        if state.product?.id == id { return }
        Task {
            state.loading = true
            do {
                let p = try await api.getProduct(id: id)
                state.product = p
                state.loading = false
                state.error = nil
            } catch {
                let cached = try? repo.getOne(id: id)
                state.product = cached
                state.loading = false
                state.error = cached == nil ? error.localizedDescription : nil
            }
        }
    }

    // Adds the current product to the cart
    func add() {
        guard let p = state.product else { return }
        Task {
            do {
                let ok = try await cartRepo.process(p)
                state.message = ok ? "Added to cart" : "Could not add to cart"
            } catch {
                state.message = "Could not add to cart"
            }
        }
    }

    func messageShown() {
        state.message = nil
    }
}
