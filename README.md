# Turtle Soup -- Detective Game

A Vue.js based interactive detective game with authentication system and admin panel.

## Features

- **Authentication System**: JWT-based login/registration
- **Game Modules**:
  - Turtle Soup detective game
  - Snake game
  - Flight status tracker
  - Q&A system
  - Policy management
- **Admin Panel**: User data management

## Technical Stack

```mermaid
graph TD
    A[Frontend] -->|Axios| B[HTTP Service]
    A -->|Pinia| C[State Management]
    A -->|Vue Router| D[Routing]
    B -->|JWT| E[Auth Service]
    C --> F[Supabase Integration]
    A --> G[Ant Design Vue]
```

## Development Setup

### Prerequisites
- Node.js 18+
- npm 9+

### Installation
```sh
npm install
```

### Running the Project

Start backend server:
```sh
node server.js
```

Start development server:
```sh
npm run dev
```

Build for production:
```sh
npm run build
```

Run tests:
```sh
npm run test:unit
```

Lint code:
```sh
npm run lint
```

## Project Structure

- `src/views/`: Main game views
- `src/components/games/`: Game components
- `src/services/`: API services
- `src/stores/`: Pinia stores
- `src/config/`: Game configurations

## Running views
<img width="819" height="604" alt="image" src="https://github.com/user-attachments/assets/13f6281a-6a6f-4f11-9ae9-22fb4b59612e" />

<img width="859" height="598" alt="image" src="https://github.com/user-attachments/assets/43bf380c-ad05-4a15-ae2d-f7563de3b6af" />

<img width="754" height="572" alt="image" src="https://github.com/user-attachments/assets/cbbfbaa6-9d2f-43a2-8816-bfb4357a59d8" />


## License
MIT License (see LICENSE file)
  
