import Foundation

struct AuthInterceptor: Interceptor {

    func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> HttpResult {
        let token = UserDefaults.standard.string(forKey: "token")

        var authorized = request
        if let token {
            authorized.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return try await chain.proceed(authorized)
    }
}
