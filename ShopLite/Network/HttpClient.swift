import Foundation

typealias HttpResult = (data: Data, response: HTTPURLResponse)

protocol Interceptor {
    func intercept(_ request: URLRequest, chain: InterceptorChain) async throws -> HttpResult
}

struct InterceptorChain {
    let remaining: ArraySlice<any Interceptor>
    let session: URLSession

    func proceed(_ request: URLRequest) async throws -> HttpResult {
        guard let next = remaining.first else {
            let (data, response) = try await session.data(for: request)
            return (data, response as! HTTPURLResponse)
        }
        return try await next.intercept(request, chain: InterceptorChain(remaining: remaining.dropFirst(), session: session))
    }
}

final class HttpClient {
    private let interceptors: [any Interceptor]
    private let session: URLSession

    init(interceptors: [any Interceptor], session: URLSession = URLSession(configuration: .default)) {
        self.interceptors = interceptors
        self.session = session
    }

    func execute(_ request: URLRequest) async throws -> HttpResult {
        try await InterceptorChain(remaining: interceptors[...], session: session).proceed(request)
    }
}

struct HttpException: LocalizedError {
    let code: Int

    var errorDescription: String? { "HTTP \(code)" }
}

struct ApiResponse<T> {
    static var successCodes: Range<Int> { 200..<300 }

    let code: Int
    let body: T?

    var isSuccessful: Bool { Self.successCodes.contains(code) }
}
