import SwiftUI

struct CartScreen: View {
    let onBack: () -> Void
    @State var vm = CartViewModel()
    @State private var toast: String? = nil

    var body: some View {
        Group {
            if vm.items.isEmpty {
                Text("Your cart is empty").foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 0) {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.items, id: \.productId) { item in
                                HStack(spacing: 0) {
                                    AsyncImage(url: URL(string: item.thumbnail)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.clear
                                    }
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    Spacer().frame(width: 12)
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(item.title).fontWeight(.semibold)
                                        Text("Qty: " + String(item.quantity)).foregroundStyle(.gray).font(.system(size: 13))
                                        Text(fmt(item.price * (1 - item.discountPercentage / 100) * Double(item.quantity)))
                                            .fontWeight(.bold)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    Button {
                                        vm.delete(id: item.productId)
                                    } label: {
                                        Image(systemName: "trash").frame(width: 48, height: 48)
                                    }
                                    .accessibilityLabel("Remove")
                                }
                                .padding(16)
                                Divider()
                            }
                        }
                    }
                    HStack {
                        Text("Total").font(.system(size: 18))
                        Spacer()
                        Text(fmt(vm.total)).font(.system(size: 22, weight: .bold))
                    }
                    .padding(16)
                    Button {
                        toast = "Checkout coming soon"
                    } label: {
                        Text("Checkout").frame(maxWidth: .infinity).frame(height: 32)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(16)
                }
            }
        }
        .navigationTitle("Your cart")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onBack) { Image(systemName: "chevron.backward") }
                    .accessibilityLabel("Back")
            }
        }
        .overlay(alignment: .bottom) {
            if let toast {
                Text(toast)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.black.opacity(0.8)))
                    .padding(.bottom, 96)
            }
        }
        .task(id: toast) {
            guard toast != nil else { return }
            try? await Task.sleep(for: .seconds(2))
            toast = nil
        }
    }
}
