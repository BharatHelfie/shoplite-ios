import SwiftUI

struct HomeScreen: View {
    let onOpen: (Int) -> Void
    let onCart: () -> Void
    let onLogout: () -> Void
    @StateObject var vm = HomeViewModel()
    @State private var showProfile = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if let userImage = vm.state.userImage {
                    AsyncImage(url: URL(string: userImage)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
                    .onTapGesture { showProfile = true }
                } else {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color(argb: 0xFF5C6BC0)))
                        .onTapGesture { showProfile = true }
                }
                Spacer().frame(width: 12)
                VStack(alignment: .leading, spacing: 0) {
                    Text("Hi, " + (vm.state.userName ?? "there") + " 👋")
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .bold))
                    Text("What are you shopping for today?")
                        .foregroundStyle(Color(argb: 0xFFC5CAE9))
                        .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    vm.doIt()
                } label: {
                    Image(systemName: "arrow.clockwise").foregroundStyle(.white).frame(width: 48, height: 48)
                }
                .accessibilityLabel("Refresh")
                Button(action: onCart) {
                    Image(systemName: "cart.fill")
                        .foregroundStyle(.white)
                        .overlay(alignment: .topTrailing) {
                            if vm.state.cartCount > 0 {
                                Text(String(vm.state.cartCount))
                                    .font(.system(size: 11))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 4)
                                    .background(Capsule().fill(Color(argb: 0xFFB3261E)))
                                    .offset(x: 10, y: -8)
                            }
                        }
                        .frame(width: 48, height: 48)
                }
                .accessibilityLabel("Cart")
            }
            .padding(EdgeInsets(top: 36, leading: 16, bottom: 12, trailing: 8))
            .background(Color(argb: 0xFF3949AB))

            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(.gray)
                TextField("Search products", text: Binding(get: { vm.state.query }, set: { vm.handle($0) }))
                    .textInputAutocapitalization(.never)
            }
            .padding(14)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.6)))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(label: "All", selected: vm.state.selectedCategory == nil) { vm.select(nil) }
                    ForEach(Array(vm.state.categories.enumerated()), id: \.offset) { _, c in
                        let label = c.replacingOccurrences(of: "-", with: " ")
                        FilterChip(label: label.prefix(1).uppercased() + label.dropFirst(), selected: vm.state.selectedCategory == c) {
                            vm.select(c)
                        }
                    }
                }
                .padding(.leading, 16)
            }
            .padding(.bottom, 8)

            if vm.state.error != nil {
                HStack {
                    Text(vm.state.error ?? "")
                        .foregroundStyle(Color(argb: 0xFFC62828))
                        .font(.system(size: 13))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("Retry") { vm.doIt() }
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color(argb: 0xFFFFEBEE)))
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
            }

            if vm.state.loading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.state.products.isEmpty {
                VStack(spacing: 0) {
                    Text("🛍️").font(.system(size: 48))
                    Spacer().frame(height: 8)
                    Text("No products found").fontWeight(.semibold)
                    if !vm.state.query.isEmpty {
                        Text("Try a different search").foregroundStyle(.gray).font(.system(size: 13))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(Array(vm.state.products.enumerated()), id: \.offset) { index, p in
                            if index == vm.state.products.count - 1 {
                                let _ = vm.more()
                            }
                            HStack(alignment: .top, spacing: 0) {
                                ZStack(alignment: .topLeading) {
                                    AsyncImage(url: URL(string: p.thumbnail)) { image in
                                        image.resizable().scaledToFill()
                                    } placeholder: {
                                        Color.clear
                                    }
                                    .frame(width: 96, height: 96)
                                    .background(Color(argb: 0xFFEEEEEE))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .accessibilityLabel(p.title)
                                    if p.discountPercentage > 10 {
                                        Text("-" + String(Int(p.discountPercentage)) + "%")
                                            .foregroundStyle(.white)
                                            .font(.system(size: 11, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(RoundedRectangle(cornerRadius: 6).fill(Color(argb: 0xFFE53935)))
                                            .padding(4)
                                    }
                                }
                                Spacer().frame(width: 12)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(p.title)
                                        .fontWeight(.semibold)
                                        .font(.system(size: 15))
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                    if let brand = p.brand {
                                        Text(brand).foregroundStyle(.gray).font(.system(size: 12))
                                    }
                                    Spacer().frame(height: 4)
                                    HStack(spacing: 0) {
                                        ForEach(1...5, id: \.self) { i in
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 11))
                                                .foregroundStyle(i <= Int(p.rating) ? Color(argb: 0xFFFFB300) : Color(argb: 0xFFE0E0E0))
                                        }
                                        Spacer().frame(width: 4)
                                        Text(String(format: "%.1f", p.rating)).font(.system(size: 12)).foregroundStyle(.gray)
                                    }
                                    Spacer().frame(height: 6)
                                    HStack(alignment: .bottom, spacing: 0) {
                                        let discounted = p.price * (1 - p.discountPercentage / 100)
                                        Text(fmt(discounted))
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundStyle(Color(argb: 0xFF1B5E20))
                                        Spacer().frame(width: 6)
                                        if p.discountPercentage > 0 {
                                            Text(fmt(p.price))
                                                .font(.system(size: 12))
                                                .foregroundStyle(.gray)
                                                .strikethrough()
                                        }
                                    }
                                    Spacer().frame(height: 4)
                                    if p.stock < 10 {
                                        Text("Only " + String(p.stock) + " left!")
                                            .foregroundStyle(Color(argb: 0xFFEF6C00))
                                            .font(.system(size: 12, weight: .medium))
                                    } else if p.stock < 50 {
                                        Text("In stock").foregroundStyle(Color(argb: 0xFF2E7D32)).font(.system(size: 12))
                                    } else {
                                        Text("Plenty in stock").foregroundStyle(Color(argb: 0xFF2E7D32)).font(.system(size: 12))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 14).fill(Color.white).shadow(color: .black.opacity(0.12), radius: 2, y: 1))
                            .padding(.horizontal, 16)
                            .onTapGesture { onOpen(p.id) }
                        }
                        Spacer().frame(height: 24)
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
        .background(Color(argb: 0xFFF5F5F5))
        .toolbar(.hidden, for: .navigationBar)
        .task {
            vm.callApi()
        }
        .sheet(isPresented: $showProfile) {
            VStack(alignment: .leading, spacing: 0) {
                Text(vm.state.userName ?? "Profile").font(.system(size: 24))
                Spacer().frame(height: 16)
                if let userImage = vm.state.userImage {
                    AsyncImage(url: URL(string: userImage)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.clear
                    }
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                    Spacer().frame(height: 12)
                }
                Text("Items in cart: " + String(vm.state.cartCount))
                Text("Products loaded: " + String(vm.state.products.count)).foregroundStyle(.gray).font(.system(size: 12))
                Spacer().frame(height: 24)
                HStack {
                    Spacer()
                    Button("Close") { showProfile = false }
                    Button("Log out") {
                        vm.out()
                        showProfile = false
                        onLogout()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(24)
            .presentationDetents([.height(320)])
        }
    }
}

private struct FilterChip: View {
    let label: String
    let selected: Bool
    let onClick: () -> Void

    var body: some View {
        Button(action: onClick) {
            Text(label)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .foregroundStyle(selected ? Color(argb: 0xFF1D192B) : Color(argb: 0xFF49454F))
                .background(RoundedRectangle(cornerRadius: 8).fill(selected ? Color(argb: 0xFFE8DEF8) : Color.clear))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(selected ? Color.clear : Color(argb: 0xFF79747E)))
        }
    }
}
