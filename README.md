# Blog Explorer

A application used to view and manage blogs.

## API Reference

#### Get all blogs

### Base URL: https://intent-kit-16.hasura.app

```http
  GET /api/rest/blogs
```

| Header                  | Type     | Description                |
| :---------------------- | :------- | :------------------------- |
| `x-hasura-admin-secret` | `string` | **Required**. Your API key |

## Features

- Fetch updated blogs
- List blogs
- Add/Remove Favourites
- Search blogs
- Filter Favourite blogs
- Multiple Theme Modes (Light, Dark)

## Libraries Used

- flutter_hooks: ^0.20.2
- fluttertoast: ^8.2.2
- google_fonts: ^6.1.0
- hive: ^2.2.3
- http: ^1.1.0
- provider: ^6.0.5

## How to Run

- Install Flutter
- Add `flutter` to Environment Variable
- Open Project
- cd `<Project_Directory>`
- flutter run
