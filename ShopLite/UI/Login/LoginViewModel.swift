import Foundation
import Observation

@Observable
@MainActor
final class LoginViewModel {
    var username = "emilys"
    var password = "emilyspass"
    var loading = false
    var error: String? = nil
    var done = false

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository = AuthRepository()) {
        self.authRepository = authRepository
    }

    // Validates the input and logs the user in
    func submit() {
        if username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            error = "Please enter username and password"
            return
        }
        loading = true
        error = nil
        Task {
            do {
                _ = try await authRepository.go(u: username, p: password)
                done = true
            } catch {
                self.error = error.localizedDescription
            }
            loading = false
        }
    }
}
