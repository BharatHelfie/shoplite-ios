import Foundation

struct HttpLoggingInterceptor: Interceptor {

    func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> HttpResult {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? ""
        print("--> \(method) \(url)")
        request.allHTTPHeaderFields?.forEach { print("\($0.key): \($0.value)") }
        if let body = request.httpBody {
            print(String(decoding: body, as: UTF8.self))
        }
        print("--> END \(method)")
        let result = try await chain.proceed(request)
        print("<-- \(result.response.statusCode) \(url)")
        print(String(decoding: result.data, as: UTF8.self))
        print("<-- END HTTP")
        return result
    }
}
