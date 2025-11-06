# 🐢 Turtle Soup Puzzle Game

![Turtle Soup Game](https://img.shields.io/badge/Turtle_Soup-Puzzle_Game-brightgreen)
![Vue.js](https://img.shields.io/badge/Vue.js-3.x-4FC08D)
![TypeScript](https://img.shields.io/badge/TypeScript-4.x-3178C6)

## Project Overview

Turtle Soup is a popular situational puzzle game where players need to uncover the truth behind seemingly illogical scenarios through questioning. This project is a frontend implementation of a Turtle Soup puzzle game built with Vue 3 and TypeScript.

### Live Demo

URL: https://versaxu.github.io/Turtle-Soup/

**Available Account**:
- Username: admin
- Password: admin

> Note: User authentication system is under development. Currently only admin account is supported.

## Game Rules

1. The game starts with an absurd or confusing situation
2. Players ask questions to uncover the underlying reason
3. The system can only answer "Yes", "No", or "Irrelevant"
4. After 3 questions, players can request hints
5. Players should try to find the correct answer with minimal questions

## Technical Architecture

- **Frontend Framework**: Vue 3 + TypeScript
- **State Management**: Pinia
- **UI Components**: Custom components
- **API Communication**: Axios
- **Deployment**: GitHub Pages
- **Backend Service**: Express.js + Vercel

## Features

- Rich puzzle database with various types and difficulty levels
- Intelligent Q&A system that understands and responds to player questions
- Progress tracking system showing puzzle-solving progress
- Hint system to assist with challenging puzzles
- Responsive design for all devices

## Local Development

### Prerequisites

- Node.js 14.x or higher
- npm or yarn

### Installation Steps

1. Clone repository
```bash
git clone https://github.com/VersaXu/Turtle-Soup.git
cd Turtle-Soup
```

2. Install dependencies
```bash
npm install
# or
yarn install
```

3. Start development server
```bash
npm run dev
# or
yarn dev
```

4. Build for production
```bash
npm run build
# or
yarn build
```

## Puzzle Database

The game includes various types of puzzles:

- Classic puzzles
- Word games
- Life-or-death choices
- Daily life scenarios
- Horror and suspense
- Sci-fi and fantasy
- Emotional and psychological

Each puzzle has corresponding difficulty levels (Easy, Medium, Hard) and hint system.

## Project Structure

```
src/
├── assets/          # Static assets
├── components/      # Components
│   └── TurtleSoupGame.vue  # Main game component
├── config/          # Configuration files
│   ├── apiConfig.ts         # API configuration
│   └── turtleSoupKnowledgeBase.ts  # Puzzle database
├── services/        # Services
│   ├── http.service.ts      # HTTP service
│   ├── turtleSoupApi.ts     # Turtle Soup API service
│   └── turtleSoupService.ts # Turtle Soup game service
├── stores/          # State management
│   └── turtleSoupStore.ts   # Turtle Soup state store
└── views/           # Views
    └── TurtleSoupGameView.vue  # Game view
```

## Deployment

The project uses GitHub Actions for automatic deployment to GitHub Pages. When code is pushed to the main branch, it automatically builds and deploys to the gh-pages branch.

## Backend Service

The backend service is deployed on Vercel and provides API support:
- Puzzle generation
- Question answering
- User authentication

Backend repository: [Turtle-Soup-Backend](https://github.com/VersaXu/turtle-soup-backend)

## Contributing

Welcome to contribute to the project! You can participate through:

1. Submitting issues or suggestions
2. Contributing code improvements
3. Adding new puzzles

## License

[MIT](LICENSE)

## Acknowledgments

- Original authors of all Turtle Soup puzzles
- Vue.js community
- Project contributors