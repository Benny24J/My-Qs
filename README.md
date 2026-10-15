# My-QS (Civil Calculation & Quantity Surveying App)

A professional Flutter mobile application tailored for civil engineers, quantity surveyors, building contractors, and homeowners. **My-QS** automates material estimation, bill of quantities (BOQ) calculations, reinforcement design schedules, and multi-room project estimation with instant PDF export.

---

## 🏗️ Features Overview

### 1. 🧮 Material & Quick Calculators
- **Wall Sandcrete Blocks**:
  - Calculates hollow sandcrete blocks (6" and 9").
  - Deducts door and window openings automatically.
  - Computes joint mortar cement (50kg bags) and sharp sand (tonnes / m³).
- **Concrete Batching & Slabs**:
  - Wet volume conversion with **1.54 dry shrinkage multiplier**.
  - Supports standard mix ratios: `1:2:4` (structural), `1:1.5:3` (high strength), and `1:3:6` (mass concrete / blinding).
  - Calculates 50kg cement bags, sharp sand (tonnes), granite coarse aggregates (tonnes), and hydration water.
- **Reinforcement & Rebar (RCC)**:
  - Supports 4-bar, 6-bar, 8-bar, and 10-bar square and circular column/beam sections.
  - Calculates main longitudinal rebar (12m standard commercial rod lengths).
  - Calculates stirrups/links (Y8/Y10), spacing center-to-center, hook overlaps, and weight via civil formula ($\frac{D^2}{162} \text{ kg/m}$).
  - Estimates required annealed binding wire (kg).
- **Floor & Wall Tiles**:
  - Supports common tile sizes (`30x30`, `40x40`, `60x60`, `60x120` cm).
  - Converts gross surface area to commercial retail pack counts.
  - Computes tile adhesive bags (20kg) and joint grout filler (kg).
- **Plastering & Rendering**:
  - Single-face and internal/external double-side options.
  - Computes 1:4 mortar dry requirements, cement bags, and screened plaster sand.
- **Paint & Finishes**:
  - Computes multi-coat emulsion and acrylic paint requirements.
  - Automatically breaks quantities down into commercial 20L drums and 4L gallon containers.
  - Estimates wall primer / acrylic sealer liters.
- **Roofing & Framing**:
  - Pitched roof area calculations including eaves overhang allowance.
  - Calculates corrugated / longspan roofing sheets (lengths & count).
  - Estimates apex ridge caps, timber purlins / rafters (12ft planks), and self-drilling screw packs.

### 2. 🏠 Whole Building & Multi-Room Project Estimation
- Create and organize multi-room construction projects with client details and site locations.
- Configure room-by-room dimensions (length, width, height, door & window counts).
- Toggle specific components per room (walls, slab, plastering, floor tiles, paint).
- Aggregates room materials into a unified **Master Material Schedule & Bill of Quantities**.

### 3. 📄 PDF Export & Printing
- Generates clean, client-ready A4 PDF reports with a single tap.
- Formats master material schedules, exact math vs. safety cushion, purchasing units, and room-by-room breakdowns.
- Native sharing and direct printing support via `printing` and `pdf` packages.

### 4. 📐 Visual Diagrams & "Show The Working"
- **Interactive Diagrams**: Custom canvas painters showing walls with opening cutouts, rebar cross-sections, and mix ratios.
- **Show The Working**: Transparent mathematical derivation steps for every calculation, helping laymen understand how figures are reached.
- **Layman's Guide**: In-app glossary explaining key construction concepts (wastage, concrete ratios, rod diameters, shrinkage factors).

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (Dart 3.x)
- **State Management & Persistence**: Native Flutter State + `shared_preferences`
- **PDF & Document Engine**: `pdf` & `printing`
- **Formatting & Localization**: `intl`
- **Architecture**: Clean Feature-First Directory Structure:
  - `lib/core/calculator/`: Pure Dart deterministic math engine (`QsCalculatorEngine`).
  - `lib/core/models/`: Strongly typed data models (`MaterialItem`, `CalculationResult`, `ProjectModel`).
  - `lib/core/storage/`: SharedPreferences persistence layer.
  - `lib/core/theme/`: Custom civil-engineering-inspired palette and component themes.
  - `lib/core/widgets/`: Canvas painters, diagram widgets, and step breakdowns.
  - `lib/features/`: Modular screens (home dashboard, quick calc, projects, reports, glossary, settings).

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.11.4)
- Dart SDK (>= 3.0.0)
- Android Studio / Xcode / VS Code with Flutter extension

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Benny24J/My-Qs.git
   cd My-Qs
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run unit tests**:
   ```bash
   flutter test
   ```

4. **Run on an emulator or connected device**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

The calculation engine is backed by thorough unit tests covering concrete batching, rebar formulas, tile pack rollups, and project aggregation:
```bash
flutter test test/calculator_engine_test.dart
```

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
