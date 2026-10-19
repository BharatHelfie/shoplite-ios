# ShopLite

A shopping app built with SwiftUI, backed by the public [DummyJSON](https://dummyjson.com) API.

Features: login, product catalogue with search, categories and infinite scroll, product details with reviews, cart, and offline support.

## Stack

Swift · SwiftUI · Observation / Combine · URLSession · SwiftData · Swift Concurrency · NavigationStack · AsyncImage

No third-party dependencies.

## Running

1. Open `ShopLite.xcodeproj` in Xcode (16 or newer).
2. Select the `ShopLite` scheme.
3. Run on an iPhone simulator or device (iOS 17+). An internet connection is needed on first launch.

Test login: `emilys` / `emilyspass` (or `michaelw` / `michaelwpass`).

Unit tests: `Cmd + U` in Xcode.

The Xcode project is generated from `project.yml` with [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`xcodegen generate`), but the generated project is committed, so you don't need XcodeGen to run the app.

## Project structure

```
ShopLite/
├── ShopLiteApp.swift       # entry point + navigation graph
├── DI/                     # dependency providers (network, database)
├── Network/                # API service, HTTP client, interceptors, models
├── Data/
│   ├── Local/              # SwiftData entity, DAO, converters
│   └── Repository/         # Auth, Product, Cart repositories
├── UI/
│   ├── Login/
│   ├── Home/
│   ├── Detail/
│   ├── Cart/
│   └── Theme/
└── Utils/
ShopLiteTests/              # unit tests
```

## API

Base URL: `https://dummyjson.com/`

| Endpoint | Used for |
|---|---|
| `POST auth/login` | Login, returns access + refresh token |
| `GET auth/me` | Logged-in user's profile |
| `POST auth/refresh` | Refresh the access token |
| `GET products?limit=&skip=` | Paginated catalogue |
| `GET products/search?q=` | Search |
| `GET products/category-list` | Category names |
| `GET products/category/{slug}` | Products in a category |
| `GET products/{id}` | Product detail |
| `POST carts/add` | Add to cart |

## For this session

Your interviewer will give you a task. Treat it like a real ticket on a codebase you've just joined: think out loud, ask questions, and change what you think needs changing.
