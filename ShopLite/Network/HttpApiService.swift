import Foundation

final class HttpApiService: ApiService {
    private let baseURL: URL
    private let client: HttpClient
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(baseURL: URL, client: HttpClient) {
        self.baseURL = baseURL
        self.client = client
    }

    func login(_ body: LoginRequest) async throws -> LoginResponse {
        try await call(post("auth/login", body: body))
    }

    func me() async throws -> UserProfile {
        try await call(get("auth/me"))
    }

    func refresh(_ body: RefreshRequest) async throws -> ApiResponse<LoginResponse> {
        try await response(post("auth/refresh", body: body))
    }

    func getProducts(limit: Int, skip: Int) async throws -> ProductsResponse {
        try await call(get("products", query: [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(skip)),
        ]))
    }

    func search(q: String) async throws -> ProductsResponse {
        try await call(get("products/search", query: [URLQueryItem(name: "q", value: q)]))
    }

    func getCategories() async throws -> [String] {
        try await call(get("products/category-list"))
    }

    func getByCategory(slug: String) async throws -> ApiResponse<ProductsResponse> {
        try await response(get("products/category/\(slug)"))
    }

    func getProduct(id: Int) async throws -> Product {
        try await call(get("products/\(id)"))
    }

    func addToCart(_ body: AddCartRequest) async throws -> ApiResponse<CartResponse> {
        try await response(post("carts/add", body: body))
    }

    private func call<T: Decodable>(_ request: URLRequest) async throws -> T {
        let result = try await client.execute(request)
        guard ApiResponse<T>.successCodes.contains(result.response.statusCode) else {
            throw HttpException(code: result.response.statusCode)
        }
        return try decoder.decode(T.self, from: result.data)
    }

    private func response<T: Decodable>(_ request: URLRequest) async throws -> ApiResponse<T> {
        let result = try await client.execute(request)
        let code = result.response.statusCode
        guard ApiResponse<T>.successCodes.contains(code) else {
            return ApiResponse(code: code, body: nil)
        }
        return ApiResponse(code: code, body: try decoder.decode(T.self, from: result.data))
    }

    private func get(_ path: String, query: [URLQueryItem] = []) -> URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        if !query.isEmpty {
            components.queryItems = query
        }
        return URLRequest(url: components.url!)
    }

    private func post(_ path: String, body: some Encodable) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! encoder.encode(body)
        return request
    }
}
