import SwiftUI

struct ProductDetailScreen: View {
    let id: Int
    let onBack: () -> Void
    let onCart: () -> Void
    @StateObject var vm = ProductDetailViewModel()

    var body: some View {
        let _ = vm.getIt(id: id)
        let p = vm.state.product

        Group {
            if vm.state.loading && p == nil {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let p {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 8) {
                                ForEach(p.images ?? [p.thumbnail], id: \.self) { url in
                                    AsyncImage(url: URL(string: url)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.clear
                                    }
                                    .frame(width: 260, height: 260)
                                    .background(Color(argb: 0xFFEEEEEE))
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            }
                            .padding(16)
                        }

                        VStack(alignment: .leading, spacing: 0) {
                            Text(p.title).font(.system(size: 22, weight: .bold))
                            if let brand = p.brand {
                                Text(brand).foregroundStyle(.gray)
                            }
                            Spacer().frame(height: 8)
                            HStack(spacing: 0) {
                                Text("$" + String(Int(p.price * (100 - p.discountPercentage) / 100)))
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundStyle(Color(argb: 0xFF1B5E20))
                                Spacer().frame(width: 8)
                                Text(String(Int(p.discountPercentage)) + "% off")
                                    .foregroundStyle(Color(argb: 0xFFE53935))
                                    .fontWeight(.semibold)
                            }
                            Spacer().frame(height: 4)
                            HStack(spacing: 0) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color(argb: 0xFFFFB300))
                                Text(" " + String(p.rating) + " · " + (p.availabilityStatus ?? "")).foregroundStyle(.gray)
                            }
                            Spacer().frame(height: 16)
                            Text(p.description).lineSpacing(4)
                            Spacer().frame(height: 16)
                            Button {
                                vm.add()
                            } label: {
                                Text("Add to cart").font(.system(size: 16)).frame(maxWidth: .infinity).frame(height: 44)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 12))
                            Spacer().frame(height: 24)

                            Text("Reviews").font(.system(size: 18, weight: .bold))
                            Spacer().frame(height: 8)
                            ForEach(p.reviews ?? [], id: \.self) { r in
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(r.reviewerName).fontWeight(.semibold)
                                        Spacer().frame(width: 8)
                                        Text(String(repeating: "★", count: r.rating)).foregroundStyle(Color(argb: 0xFFFFB300))
                                    }
                                    Text(r.comment).foregroundStyle(Color(argb: 0xFF444444))
                                    Text(r.reviewerEmail).foregroundStyle(.gray).font(.system(size: 11))
                                }
                                .padding(.vertical, 8)
                                Divider()
                            }
                            Spacer().frame(height: 32)
                        }
                        .padding(.horizontal, 16)
                    }
                }
            } else {
                Text(vm.state.error ?? "Product not found").foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle(p?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: onBack) { Image(systemName: "chevron.backward") }
                    .accessibilityLabel("Back")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onCart) { Image(systemName: "cart.fill") }
                    .accessibilityLabel("Cart")
            }
        }
        .overlay(alignment: .bottom) {
            if let message = vm.state.message {
                Text(message)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 4).fill(Color(argb: 0xFF323232)))
                    .padding(12)
            }
        }
        .task(id: vm.state.message) {
            guard vm.state.message != nil else { return }
            try? await Task.sleep(for: .seconds(4))
            vm.messageShown()
        }
    }
}
