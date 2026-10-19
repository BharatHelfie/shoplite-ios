import Foundation

enum NetworkModule {

    static func provideHttpClient() -> HttpClient {
        HttpClient(interceptors: [AuthInterceptor(), HttpLoggingInterceptor()])
    }

    static func provideApiService() -> ApiService {
        HttpApiService(baseURL: URL(string: "https://dummyjson.com/")!, client: provideHttpClient())
    }
}
