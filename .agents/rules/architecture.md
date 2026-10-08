# Architecture Rules

## Layered Clean Architecture (Feature-First)

The project organizes code by feature in `lib/features/`, backed by cross-cutting primitives in `lib/core/` and bootstrap logic in `lib/app/`.

### Directory Layout

```
lib/
├── app/                  # Application initialization & routing
├── config/               # Environment constants (.env mapping)
├── core/                 # Shared domain-agnostic foundations
└── features/             # Business modules (feature-first)
    └── <feature>/
        ├── data/         # Repositories & DTOs
        ├── domain/       # Entities & Repository contracts
        └── presentation/ # Pages, widgets, notifiers
```

### Layer Boundaries & Dependencies

1. **Presentation Layer:**
   - Depends on: `domain`, `core`
   - Contains: UI Pages, component widgets, Riverpod Notifiers/Providers, forms.
   - Responsibilities: Render UI, capture user input, bind to Riverpod providers, dispatch user actions.
   - Presentation must NEVER import directly from other features' `data` layer.

2. **Domain Layer:**
   - Depends on: `core` (Result, errors)
   - Contains: Entities (`@freezed`), Repository interfaces (abstract classes), business value objects.
   - Responsibilities: Pure Dart business rules. Independent of Flutter UI and third-party frameworks.

3. **Data Layer:**
   - Depends on: `domain`, `core` (network, storage)
   - Contains: Repository implementations (e.g., `AuthRepositoryRemote`, `AuthRepositoryMock`), API clients, local caching.
   - Responsibilities: Fetching/persisting data, mapping network DTOs to Domain entities, handling network failures.

4. **Core Layer:**
   - Depends on: external packages only.
   - Contains: Network clients, theme definitions, storage abstractions, extensions, base widgets.
   - Core must NEVER import from any `features/`.

### Barrel Files

- If a feature provides a public API, use a barrel file (`<feature>.dart`) exporting domain entities and presentation pages/providers.
- Barrel files must declare `library;` if they only contain doc comments and export directives.
