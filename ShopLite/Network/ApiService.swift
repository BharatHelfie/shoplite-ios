import Foundation

protocol ApiService {

    func login(_ body: LoginRequest) async throws -> LoginResponse

    func me() async throws -> UserProfile

    func refresh(_ body: RefreshRequest) async throws -> ApiResponse<LoginResponse>

    func getProducts(limit: Int, skip: Int) async throws -> ProductsResponse

    func search(q: String) async throws -> ProductsResponse

    func getCategories() async throws -> [String]

    func getByCategory(slug: String) async throws -> ApiResponse<ProductsResponse>

    func getProduct(id: Int) async throws -> Product

    func addToCart(_ body: AddCartRequest) async throws -> ApiResponse<CartResponse>
}
