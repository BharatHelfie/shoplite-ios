import Foundation
import Combine
import os

struct HomeState {
    var products: [Product] = []
    var categories: [String] = []
    var selectedCategory: String? = nil
    var query: String = ""
    var loading: Bool = false
    var error: String? = nil
    var userName: String? = nil
    var userImage: String? = nil
    var cartCount: Int = 0
    var page: Int = 0
}

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var state = HomeState()

    private let repo: ProductRepository
    private let api: ApiService
    private let cartRepo: CartRepository
    private let authRepo: AuthRepository
    private let logger = Logger(subsystem: "com.shoplite.app", category: "HomeViewModel")

    init(
        repo: ProductRepository = ProductRepository(),
        api: ApiService = NetworkModule.provideApiService(),
        cartRepo: CartRepository = CartRepository(),
        authRepo: AuthRepository = AuthRepository()
    ) {
        self.repo = repo
        self.api = api
        self.cartRepo = cartRepo
        self.authRepo = authRepo
        doIt()
        getData2()
        callApi()
        state.cartCount = cartRepo.size()
    }

    // Loads the first page of products
    func doIt() {
        Task {
            state.loading = true
            state.error = nil
            let list = try await repo.doIt(page: 0)
            state.products = fix(list)
            state.loading = false
            state.page = 0
        }
    }

    // Loads the next page of products
    func more() {
        Task {
            let next = state.page + 1
            let list = try await repo.doIt(page: next)
            state.products = state.products + fix(list)
            state.page = next
        }
    }

    // Searches products by the text the user typed
    func handle(_ q: String) {
        state.query = q
        Task {
            do {
                if q.isEmpty {
                    doIt()
                    return
                }
                let res = try await api.search(q: q)
                state.products = res.products
                state.error = nil
            } catch {
                state.error = error.localizedDescription
            }
        }
    }

    // Gets the list of categories
    func getData2() {
        Task {
            do {
                state.categories = try await api.getCategories()
            } catch {
            }
        }
    }

    // Shows only products from the selected category
    func select(_ c: String?) {
        state.selectedCategory = c
        Task {
            guard let c else {
                doIt()
                return
            }
            let res = try! await api.getByCategory(slug: c)
            state.products = res.body!.products
        }
    }

    // Fetches the logged in user's profile
    func callApi() {
        Task.detached {
            do {
                let me = try await self.api.me()
                await MainActor.run {
                    self.state.userName = me.firstName
                    self.state.userImage = me.image
                }
            } catch {
                self.logger.error("callApi failed: \(error)")
            }
        }
    }

    // Logs the user out
    func out() {
        authRepo.clear()
    }
}
