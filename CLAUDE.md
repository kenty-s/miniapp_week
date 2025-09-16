# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is 芋煮ケーション (Imonication), a Rails 8 mini-application that settles the eternal debate about 芋煮 (imoni) preparation styles across Tohoku region prefectures in Japan. The app features an interactive voting system where users answer questions about their imoni preferences and get automatically categorized by prefecture.

## Technology Stack

- **Backend**: Rails 8.0.2+ with PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS 4.x, esbuild
- **Template Engine**: Slim templates
- **Development**: Docker Compose, Foreman (via Procfile.dev)
- **Code Quality**: RuboCop Rails Omakase, Brakeman
- **Testing**: Minitest with Capybara and Selenium

## Development Commands

### Setup and Database
```bash
# First-time setup
docker compose up -d
docker compose exec web rails db:create db:migrate db:seed

# Database operations
rails db:migrate
rails db:seed
rails db:reset
```

### Development Server
```bash
# Start all services (Rails, JS, CSS watching)
bin/dev

# Individual services (as defined in Procfile.dev)
rails server -b 0.0.0.0 -p 3000
yarn build --watch          # JavaScript building with esbuild
yarn build:css --watch       # Tailwind CSS building
```

### Asset Building
```bash
# JavaScript (esbuild)
yarn build

# CSS (Tailwind)
yarn build:css
```

### Code Quality and Testing
```bash
# Linting
rubocop
bin/brakeman                 # Security scanning

# Testing
rails test                   # All tests
rails test:system            # System tests only
```

## Architecture Overview

### Domain Models
- **Post**: Basic content model (currently minimal)
- **Region**: Represents Tohoku prefectures (山形, 宮城, 福島, etc.)
- **Vote**: Records user votes tied to specific regions

### Controllers
- **PostsController**: Root controller (`posts#index`)
- **VotesController**: Handles voting logic and ranking display with geographic positioning
- **HomeController, QuestionsController**: Additional app flow controllers

### Frontend Architecture
- **Stimulus Controllers**:
  - `vote_map_controller.js`: Handles interactive map functionality
  - `slash_controller.js`: Manages special effects/animations
- **Asset Pipeline**: esbuild + Propshaft for JS, Tailwind CLI for CSS
- **Views**: Slim templates organized by controller

### Key Features
- Geographic voting visualization with hardcoded prefecture positions
- Real-time vote counting and percentage calculations
- Responsive design with Tailwind CSS

## Database Schema Notes
The current schema shows only a basic `posts` table. The README mentions Vote and Region models, but migrations may be missing or pending. Check for unmigrated files in `db/migrate/` if these models aren't working.

## Development Workflow
1. Use `bin/dev` to start the full development stack
2. Rails follows standard conventions with Slim templates
3. JavaScript organized as Stimulus controllers for progressive enhancement
4. CSS built with Tailwind CLI in watch mode during development

## Docker Configuration
- Uses `compose.yml` for PostgreSQL service
- Development Dockerfile available as `Dockerfile.dev`
- Production deployment ready with Kamal configuration