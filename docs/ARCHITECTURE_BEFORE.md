# Architecture Audit - Furniture App (Before Upgrade)

## 1. Overview
Repo ini adalah aplikasi e-commerce furnitur (`app_furniture`) dengan fitur yang sudah berjalan termasuk chat, alur transaksi, dan pengelolaan keranjang produk. Tujuan dari upgrade ini adalah untuk merombak aplikasi ini menjadi production-grade menggunakan Clean Architecture.

## 2. Struktur Folder Saat Ini (Legacy)
Saat ini, proyek menggunakan struktur folder layer-first yang sederhana tanpa pemisahan fitur yang jelas. Semua disatukan berdasarkan jenis komponen:
- `lib/models/`: Berisi struktur data murni (entity/model digabung).
- `lib/providers/`: Tempat *state management* (menggunakan package `provider`).
- `lib/screens/`: Berisi semua UI pages/screens secara *flat* (tidak ada pengelompokan fitur).
- `lib/services/`: Lapisan *data layer* yang bertugas mengambil data dari API (REST API via package `http`).
- `lib/utils/`: Berisi file konstanta dan formatter.
- `lib/widgets/`: Komponen UI modular yang dipakai ulang.

## 3. Teknologi & State Management
- **State Management**: Menggunakan package `provider` (`ChangeNotifier`). State saat ini diikat langsung dengan proses pemanggilan data API tanpa pemisahan usecase yang jelas.
- **Sumber Data**: REST API menggunakan package `http`. Base URL dikonfigurasi di `lib/services/api_config.dart`. Tidak ditemukan package `cloud_firestore` atau library Firebase lainnya.
- **Routing**: Routing standar `Navigator.push`/`Navigator.pushNamed` (tidak ada package tambahan seperti `go_router`).
- **Styling**: Styling dilakukan secara *ad-hoc* di dalam widget (menggunakan widget Flutter bawaan atau konstanta dari `lib/utils/app_theme.dart`).

## 4. Analisis Implementasi Fitur Existing
- **Katalog Produk & Keranjang**: Dikelola oleh `product_provider.dart` dan `cart_provider.dart`. Fetch data melalui `product_service.dart` dan `cart_service.dart`.
- **Checkout & Transaksi**: `checkout_provider.dart` dan `order_service.dart` menangani aliran transaksi.
- **Chat**: Menggunakan `chat_service.dart` untuk berkomunikasi dengan API.

## 5. Temuan Tambahan (Stashed Changes)
Sebelum memulai audit, ditemukan beberapa perubahan (uncommitted changes) di branch `main` yang sedang dalam status pengerjaan (WIP). Perubahan tersebut telah di-stash dengan pesan:
`wip: skeleton loading (shimmer/skeletonizer) + api client sebelum architecture audit`

**Detail Perubahan yang Di-stash:**
- `lib/main.dart`: Inisialisasi token autentikasi di startup aplikasi.
- `lib/services/api_client.dart`: Modifikasi logika penambahan header `Authorization` dan penanganan `ownerToken` via `LocalStorage`.
- `lib/services/api_config.dart`: Perubahan `baseUrl` API dari emulator (10.0.2.2) menjadi IP address fisik WiFi lokal.
- `pubspec.yaml` & `pubspec.lock`: Penambahan dependency `shimmer` dan `skeletonizer`.
- File Baru: `lib/core/local_storage.dart` dan `lib/widgets/skeleton_list_loader.dart`.

**Alasan Di-stash:**
Perubahan tersebut disimpan (stash) karena PR 1 ini ditugaskan khusus murni untuk audit dan penyiapan struktur kerangka kerja baru, sesuai instruksi *Aturan Khusus poin 2* (tidak mengubah perilaku kode). Modifikasi API Client dan fitur skeleton loading tersebut nantinya akan diintegrasikan kembali secara resmi di PR selanjutnya (misalnya PR 2 untuk Setup DI/Data layer atau PR 6 untuk UX States).
