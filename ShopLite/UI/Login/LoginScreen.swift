import SwiftUI

struct LoginScreen: View {
    let onDone: () -> Void
    @State var vm = LoginViewModel()

    var body: some View {
        if vm.done {
            let _ = onDone()
        }

        VStack(spacing: 0) {
            Text("ShopLite").font(.system(size: 32, weight: .bold)).foregroundStyle(Color(argb: 0xFF3949AB))
            Text("Sign in to continue").foregroundStyle(.gray)
            Spacer().frame(height: 32)
            TextField("Username", text: $vm.username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
            Spacer().frame(height: 12)
            SecureField("Password", text: $vm.password)
                .textFieldStyle(.roundedBorder)
            if vm.error != nil {
                Spacer().frame(height: 8)
                Text(vm.error ?? "").foregroundStyle(.red).font(.system(size: 13))
            }
            Spacer().frame(height: 24)
            Button {
                vm.submit()
            } label: {
                Group {
                    if vm.loading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Log in")
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
            }
            .buttonStyle(.borderedProminent)
            .disabled(vm.loading)
            Spacer().frame(height: 16)
            Text("Test accounts: emilys / emilyspass, michaelw / michaelwpass").foregroundStyle(.gray).font(.system(size: 12))
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
