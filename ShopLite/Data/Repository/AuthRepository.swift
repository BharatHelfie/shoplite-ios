import Foundation

final class AuthRepository {
    private let defaults: UserDefaults
    private let api: ApiService

    init(defaults: UserDefaults = .standard, api: ApiService = NetworkModule.provideApiService()) {
        self.defaults = defaults
        self.api = api
    }

    // Logs the user in with username and password and saves the session
    func go(u: String, p: String) async throws -> LoginResponse {
        let res = try await api.login(LoginRequest(username: u, password: p, expiresInMins: 30))
        defaults.set(res.accessToken, forKey: "token")
        defaults.set(res.refreshToken, forKey: "refresh_token")
        defaults.set(res.id, forKey: "user_id")
        defaults.set(res.firstName, forKey: "user_name")
        defaults.synchronize()
        return res
    }

    // Returns true if the user is logged in and the token has not expired
    func check() -> Bool {
        return defaults.string(forKey: "token") != nil
    }

    // Refreshes the access token using the refresh token
    func update() async throws -> Bool {
        guard let refresh = defaults.string(forKey: "refreshToken") else { return false }
        let res = try await api.refresh(RefreshRequest(refreshToken: refresh, expiresInMins: 30))
        if res.isSuccessful {
            defaults.set(res.body?.accessToken, forKey: "token")
            return true
        }
        return false
    }

    // Returns the logged in user's id
    func uid() -> Int { defaults.object(forKey: "user_id") as? Int ?? 1 }

    // Logs the user out and clears all user data
    func clear() {
        defaults.removeObject(forKey: "token")
    }
}
