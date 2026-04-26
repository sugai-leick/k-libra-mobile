# K-Libra Mobile 💎

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green)](#architecture)
[![State Management](https://img.shields.io/badge/State%20Management-BLoC-blue)](https://pub.dev/packages/flutter_bloc)

**K-Libra Mobile** is the high-performance mobile extension of the **K-Libra Management System**. Specifically designed for dental laboratories and digital dentistry clinics, it offers a premium, glassmorphism-inspired experience for managing clients, sales, and realtime inventory.

This project is the mobile counterpart to the official K-Libra Web React application.

---

## ✨ Key Features

-   **CRM / Client Management**: Full CRUD with swipe-to-action gestures and haptic feedback.
-   **Sales & Orders**: Multi-step forms for sales of courses, hardware, and consumables.
-   **Real-time Synchronization**: Powered by Supabase for instant data updates across devices.
-   **Premium UI/UX**: State-of-the-art glassmorphism design with smooth micro-animations.
-   **Secure Authentication**: JWT-based auth with session management and "Remember Email" service.

---

## 🏗 Architecture & Tech Stack

The project follows strict **Clean Architecture** principles to ensure scalability and maintainability:

-   **Data Layer**: Repositories implementations, DataSources (REST + Supabase), and DTOs.
-   **Domain Layer**: Entities, UseCases, and Repository interfaces.
-   **Presentation Layer**: BLoC pattern for state management, reactive UI components.

### Core Technologies:
-   **State Management**: `flutter_bloc`
-   **Dependency Injection**: `get_it`
-   **Persistence/Auth**: `supabase_flutter` & `flutter_secure_storage`
-   **Animations**: `flutter_animate`
-   **Networking**: `dio` with custom interceptors for auth & logging.

---

## 🚀 Getting Started

### Prerequisites
-   Flutter SDK (v3.24.0 or higher)
-   FVM (Flutter Version Management) - *Recommended*

### Setup
1.  **Clone the repository**:
    ```bash
    git clone https://github.com/Sugai-Leick/K-libra-mobile.git
    ```

2.  **Install dependencies**:
    ```bash
    fvm flutter pub get
    ```

3.  **Environment Variables**:
    Create a `.env` file in the root directory and add your API and Supabase credentials:
    ```env
    API_URL=https://your-api-url.com/api/v1
    SUPABASE_URL=your-supabase-url
    SUPABASE_ANON_KEY=your-anon-key
    ```

4.  **Run the application**:
    ```bash
    fvm flutter run
    ```

---

## 🎨 Design System

The application uses a custom design system based on a **Dark Premium** aesthetic:
-   **Primary Colors**: Deep Navy (`#0D0D0E`), Vivid Blue (`#00F2FF`), and Royal Purple.
-   **Glassmorphism**: High-blur containers with low opacity borders for a modern look.
-   **Typography**: Using Google Fonts (`Inter`, `Outfit`) for maximum readability.

---

## 📄 License

This project is proprietary. All rights reserved to **Sugai-Leick / K-Libra**.
