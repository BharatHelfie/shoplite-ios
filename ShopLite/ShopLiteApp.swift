import SwiftUI

@main
struct ShopLiteApp: App {
    private let authRepository = AuthRepository()

    var body: some Scene {
        WindowGroup {
            AppNav(start: authRepository.check() ? "home" : "login")
                .tint(ShopLiteTheme.primary)
        }
    }
}

struct AppNav: View {
    @State private var root: String
    @State private var path: [String] = []

    init(start: String) {
        _root = State(initialValue: start)
    }

    var body: some View {
        NavigationStack(path: $path) {
            destination(root)
                .navigationDestination(for: String.self) { route in destination(route) }
        }
    }

    @ViewBuilder
    private func destination(_ route: String) -> some View {
        if route == "login" {
            LoginScreen(onDone: { navigateHomePoppingLogin() })
        } else if route == "home" {
            HomeScreen(
                onOpen: { id in path.append("detail/\(id)") },
                onCart: { path.append("cart") },
                onLogout: { path.append("login") }
            )
        } else if route.hasPrefix("detail/") {
            ProductDetailScreen(
                id: Int(route.split(separator: "/")[1])!,
                onBack: { path.removeLast() },
                onCart: { path.append("cart") }
            )
        } else if route == "cart" {
            CartScreen(onBack: { path.removeLast() })
        }
    }

    private func navigateHomePoppingLogin() {
        guard let loginIndex = path.lastIndex(of: "login") else {
            root = "home"
            return
        }
        path.removeSubrange(loginIndex...)
        path.append("home")
    }
}
