# mobile — набор простых мобильных приложений и примеров

[![GitHub stars](https://img.shields.io/github/stars/Dizastes/mobile)](https://github.com/Dizastes/mobile/stargazers) [![Forks](https://img.shields.io/github/forks/Dizastes/mobile)](https://github.com/Dizastes/mobile/network/members) [![Open issues](https://img.shields.io/github/issues/Dizastes/mobile)](https://github.com/Dizastes/mobile/issues) [![License](https://img.shields.io/github/license/Dizastes/mobile)](https://github.com/Dizastes/mobile/blob/main/LICENSE) [![Last commit](https://img.shields.io/github/last-commit/Dizastes/mobile)](https://github.com/Dizastes/mobile/commits/main) [![Languages](https://img.shields.io/github/languages/top/Dizastes/mobile)](https://github.com/Dizastes/mobile)

Короткое описание
Этот репозиторий содержит набор небольших мобильных примеров (Calculator, calendar, converter, finansy, food, news, todo, vladameteo) реализованных на различных технологиях (C/C++, CMake, Makefile, Dart/Flutter, Swift). Каждый подпроект — самостоятельная заготовка, которую можно использовать как стартовую точку.

Быстрый старт
1) Клонируйте: `git clone https://github.com/Dizastes/mobile.git`
2) Перейдите в подпроект: `cd mobile/<папка>`
3) Выполните команды, указанные в README каждой подпапки (общие рекомендации ниже).

Общие инструкции по сборке (подсказки)
- Flutter / Dart (если в подпроекте есть pubspec.yaml): `flutter pub get` затем `flutter run` или `flutter build apk`.
- Android / Gradle (если есть build.gradle / gradlew): `./gradlew assembleDebug`.
- iOS / Swift / Xcode (если есть .xcodeproj / Package.swift): откройте в Xcode и запустите; для командной сборки используйте `xcodebuild` или swift package tools.
- CMake / C++: `cmake -S . -B build && cmake --build build --config Release`.
- Makefile: `make` или `make all`.
- Проверяйте файлы в корне подпроекта (README, Makefile, CMakeLists.txt, pubspec.yaml, build.gradle) — если они есть, следуйте содержимому.

Что добавлено в этом наборе
- Корневой README.md (этот файл)
- CONTRIBUTING.md — рекомендации по вкладу
- .github/ISSUE_TEMPLATE/bug_report.md и feature_request.md
- .github/PULL_REQUEST_TEMPLATE.md
- CODE_OF_CONDUCT.md и SECURITY.md
- Примеры workflow для GitHub Actions: flutter.yml, android.yml, cmake.yml
- Персональные README для подпроектов (Calculator, calendar, converter, finansy, food, news, todo, vladameteo) со стандартными командами сборки и рекомендациями

CI / Badges
В каталоге `.github/workflows/` содержатся примеры рабочих конфигураций для Flutter, Android/Gradle и CMake. После добавления workflow вы можете поместить соответствующий badge в корень README.

