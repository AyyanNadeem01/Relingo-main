# Relingo

Relingo is an interactive educational platform for learning about world religions through gamified lessons and quizzes. The application provides structured content about major world religions including Islam, Christianity, Hinduism, Buddhism, and Judaism, presented in an accessible and engaging format.

## 🚀 Quick Start (3 Commands)

```bash
# 1. Install dependencies
npm install

# 2. Setup Supabase & run migrations
npx supabase login && npx supabase link --project-ref YOUR_PROJECT_REF && npx supabase db push

# 3. Start the app
npm run dev
```

> **Note:** Replace `YOUR_PROJECT_REF` with your Supabase project reference (found in your project URL).

## Overview

The platform employs gamification mechanics similar to language learning applications, featuring experience points, achievement tracking, daily streaks, and progressive lesson unlocking. Users can learn at their own pace while maintaining motivation through game-like elements.

## Features

- Interactive learning path with progressive lesson unlocking
- Multiple question types: multiple choice, true/false, and fill-in-the-gap
- Gamification system with XP, hearts, stars, and daily streaks
- Multi-language support (English, Norwegian, Turkish)
- Progress tracking and statistics
- Custom profile pictures with camera and file picker support
- Responsive design optimized for mobile and desktop
- Daily quests and challenges

## Technology Stack

### Frontend
- React 19.1 with TypeScript 5.9
- Vite 7.1 for build tooling and development server
- TailwindCSS 3.4 for styling
- Framer Motion for animations
- React Router 7.9 for navigation

### State Management & Data Fetching
- TanStack Query (React Query) for server state management
- React Hook Form with Zod validation

### Backend & Infrastructure
- Supabase for authentication and database
- PostgreSQL with Row Level Security policies
- Supabase Storage for file uploads
- Real-time capabilities

### Internationalization
- i18next with react-i18next for multi-language support

## Project Structure

```
relingo/
├── src/
│   ├── app/              # Route components
│   ├── components/       # Shared UI components
│   ├── features/         # Feature-specific components
│   ├── hooks/            # Custom React hooks
│   ├── lib/              # Third-party integrations
│   ├── utils/            # Utility functions
│   ├── types/            # TypeScript type definitions
│   └── locales/          # Translation files
├── supabase/
│   └── migrations/       # Database schema and seed data
└── public/
    └── assets/           # Static assets
```

## Prerequisites

- Node.js 18 or higher
- npm or yarn package manager
- Supabase account (free tier available)

## Quick Start

### Three Essential Commands

```bash
# 1. Install dependencies
npm install

# 2. Push migrations to Supabase (requires Supabase login)
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
npx supabase db push

# 3. Run the project
npm run dev
```

## Setup Instructions

### 1. Install Dependencies

```bash
npm install
```

This will install all required packages including React, TypeScript, Vite, TailwindCSS, Supabase client, and other dependencies.

### 2. Environment Configuration

Copy the example environment file and add your Supabase credentials:

```bash
cp env.example .env
```

Update the `.env` file with your Supabase project credentials:

```env
VITE_SUPABASE_URL=https://your-project-ref.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-key
```

You can find these values in your Supabase Dashboard under Settings > API.

### 3. Configure Supabase & Run Migrations

#### Option A: Using Supabase CLI (Recommended)

1. **Login to Supabase:**
   ```bash
   npx supabase login
   ```
   This will open a browser window for authentication.

2. **Link your project:**
   ```bash
   npx supabase link --project-ref YOUR_PROJECT_REF
   ```
   Replace `YOUR_PROJECT_REF` with your project reference from the Supabase URL (e.g., `czanrjnbduutomedjqdp`).

3. **Push all migrations:**
   ```bash
   npx supabase db push
   ```
   This will apply all 20 migration files automatically to create the complete database schema.

#### Option B: Manual Migration (Alternative)

If you prefer to run migrations manually:

1. Create a new project at [supabase.com](https://supabase.com)
2. Navigate to SQL Editor in your Supabase Dashboard
3. Execute each migration file in sequential order (0001 through 0020)

**Important:** When using the CLI method, migrations are tracked automatically and won't be re-applied.

### 4. Development Server

Start the development server:

```bash
npm run dev
```

The application will be available at **http://localhost:5173**

## Available Scripts

- `npm run dev` - Start development server at http://localhost:5173
- `npm run build` - Build for production
- `npm run preview` - Preview production build locally
- `npm run lint` - Run ESLint to check for code issues
- `npm run lint:fix` - Automatically fix ESLint issues
- `npm run test` - Run tests

### Supabase CLI Commands

- `npx supabase login` - Authenticate with Supabase
- `npx supabase link --project-ref <ref>` - Link local project to remote Supabase
- `npx supabase db push` - Push local migrations to remote database
- `npx supabase db pull` - Pull remote schema changes to local
- `npx supabase migration list` - List all migrations and their status
- `npx supabase status` - Check connection status

## Database Schema

The application uses the following main tables:

- **religions** - Available religions
- **lessons** - Learning modules linked to religions
- **quizzes** - Assessment sets linked to lessons
- **questions** - Individual quiz items (MCQ, True/False, Fill-in-the-gap)
- **user_progress** - Per-user lesson completion tracking
- **user_stats** - XP, hearts, and streak tracking
- **streak_log** - Daily activity audit trail

All user data is protected by Row Level Security policies ensuring users can only access their own information.

## Storage

The application uses Supabase Storage for:

- **avatars** - User profile pictures
  - Public bucket with RLS policies
  - Users can upload, update, and delete their own images
  - Maximum file size: 5MB
  - Supported formats: JPG, PNG, GIF

See [PROFILE_IMAGE_SETUP.md](PROFILE_IMAGE_SETUP.md) for detailed setup instructions.

## Content Management

The application currently supports five major world religions with comprehensive lesson content in multiple languages. Content is structured into six main categories per religion:

1. Historical origins and background
2. Core beliefs and teachings
3. Practices and rituals
4. Holidays and celebrations
5. Sacred texts and symbols
6. Modern expressions and diversity

## Deployment

The application can be deployed to any static hosting service:

**Build Command:**
```bash
npm run build
```

**Output Directory:**
```
dist/
```

Recommended platforms: Vercel, Netlify, or similar static hosting services.

## Documentation

- [Test User Setup](SETUP_TEST_USER.md) - Guide for setting up test accounts
- [Buddhism Content](BUDDHISM_CONTENT_ADDED.md) - Details about Buddhism curriculum
- [Profile Images](PROFILE_IMAGE_SETUP.md) - Setup and usage guide for profile pictures

## License

MIT License - Free for educational and non-commercial use.

## Acknowledgments

Content is sourced from reputable educational institutions and encyclopedias. All religious content is presented with respect, accuracy, and cultural sensitivity. This is an educational tool designed for learning about world religions in a non-proselytizing manner.
