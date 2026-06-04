# TrustFund 🛡️

**Platform crowdfunding berbasis Blockchain & AI khusus untuk yayasan resmi terdaftar di Indonesia.**

> Dikembangkan oleh tim **NexTrust** (ID Peserta **S0261**) untuk **Digdaya x Hackathon BI 2026**.

---

## 1. Tentang TrustFund

Donasi online di Indonesia tumbuh pesat, tetapi kepercayaan publik kerap tergerus oleh kasus **penyalahgunaan dana** dan **penggalangan dana fiktif**. Donatur sulit memastikan apakah uang mereka benar-benar sampai ke penerima manfaat, dan lembaga yang jujur ikut terkena dampak menurunnya kepercayaan.

**TrustFund** hadir sebagai jawabannya: sebuah platform donasi yang **hanya** dapat digunakan oleh **yayasan yang sudah berbadan hukum dan terdaftar resmi di Kemenkumham**, dengan dua pilar utama:

1. **🔗 Transparansi Blockchain (Polygon)** — Setiap aliran dana dicatat secara permanen dan dapat diaudit publik. Dana donasi **dikunci di Smart Contract (escrow)** dan hanya cair secara bertahap mengikuti pencapaian *milestone*.
2. **🤖 AI Document Fraud Detection** — Dokumen yayasan, proposal, dan **Rencana Anggaran Biaya (RAB)** divalidasi oleh AI untuk mendeteksi indikasi pemalsuan dokumen dan kewajaran biaya sebelum kampanye tayang dan sebelum dana dicairkan.

Hasilnya: donatur dapat berdonasi dengan tenang karena setiap rupiah **transparan, terlacak, dan tervalidasi**.

---

## 2. Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| 🔐 **Autentikasi** | Login, daftar akun, lupa kata sandi, verifikasi OTP, dan reset kata sandi. |
| 🏠 **Beranda (Home)** | Kampanye mendesak & terverifikasi, kampanye populer, kategori, serta statistik dampak platform. |
| 📋 **Kampanye** | Daftar seluruh kampanye yang dapat ditelusuri donatur. |
| 📄 **Detail Kampanye** | Menampilkan data kampanye sesuai item yang diklik: deskripsi, **RAB**, **milestone**, donatur, *trust score*, dan status verifikasi. |
| 💸 **Alur Donasi** | Pilih nominal & metode pembayaran → instruksi pembayaran → konfirmasi donasi berhasil. |
| 🧾 **Donasi Berhasil** | Bukti donasi lengkap dengan **transaction hash on-chain** dan status dana terkunci di escrow. |
| 📊 **Lacak Donasi** | Memantau pencairan dana per milestone secara bertahap (real-time tracking). |
| 🔖 **Tersimpan** | Menyimpan/bookmark kampanye favorit. |
| 👤 **Profil** | Halaman akun pengguna. |

---

## 3. Teknologi & Arsitektur

### Stack
| Komponen | Teknologi |
|----------|-----------|
| **Framework** | Flutter (Dart SDK `^3.11.0`) |
| **State Management, Routing & DI** | [GetX](https://pub.dev/packages/get) (`get ^4.7.3`) |
| **Responsive UI** | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) (design size **393 × 852**) |
| **Tipografi** | [google_fonts](https://pub.dev/packages/google_fonts) |
| **Ikon Aplikasi** | [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) |
| **Target Platform** | Android, iOS, Web, Desktop (Linux/macOS/Windows) |

### Pola Arsitektur (GetX Modular)
Aplikasi mengikuti struktur **modular GetX** — setiap layar adalah sebuah *module* yang terdiri dari `bindings` (dependency injection), `controllers` (logika & state), dan `views` (tampilan).

```
lib/
├── main.dart                     # Entry point (GetMaterialApp + ScreenUtilInit)
└── app/
    ├── core/
    │   ├── theme/                # Warna, spasi, gaya teks, tema aplikasi
    │   └── utils/                # Helper (mis. dialog)
    ├── data/
    │   ├── models/              # Model data (Campaign, RAB, Milestone, Receipt, dll.)
    │   └── repositories/        # CampaignRepository (sumber data in-memory)
    ├── modules/                  # Fitur per layar (login, home, campaign_detail, donation, dll.)
    │   └── <fitur>/
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    ├── routes/                   # Definisi rute (app_pages.dart, app_routes.dart)
    └── widgets/                  # Komponen UI reusable (kartu, tombol, skeleton, dll.)
```

### Lapisan Data — "Seolah Sudah Terhubung Database"
Inti dari kesan *real* aplikasi ini ada pada **`CampaignRepository`** (`lib/app/data/repositories/campaign_repository.dart`):

- Merupakan **singleton in-memory** yang meniru perilaku backend.
- Seluruh tampilan (Beranda, Kampanye, Detail, Tersimpan) **diproyeksikan dari satu sumber data yang sama** (`_all`). Artinya, kampanye apa pun yang diklik donatur — baik dari Beranda maupun halaman Kampanye — akan **selalu membuka Detail Kampanye dengan data yang konsisten dan cocok** (`fetchDetailById(id)`).
- Method async sengaja diberi **jeda buatan** (`±700 ms` untuk daftar, `±900 ms` untuk detail) untuk **memicu loading/skeleton state**, sehingga aplikasi terasa seperti benar-benar memuat data dari server.
- Daftar kampanye tersimpan (`savedIds`) bersifat **reaktif** dan dibagikan ke seluruh aplikasi.

### Identitas Visual
- **Warna utama (brand):** Biru `#2563EB` dengan aksen *gradient*.
- **Warna sukses:** Hijau `#16A34A` · **Peringatan:** `#D97706` · **Bahaya:** `#DC2626`.
- **Latar beranda:** `#F5F5FB` (lavender lembut).
- Logo & ikon tersedia di `assets/logo/`.

---

## 4. Panduan Menjalankan (Demo)

### Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart `^3.11.0`)
- Emulator/perangkat Android atau iOS, atau browser (untuk mode web)

### Langkah
```bash
# 1. Masuk ke folder project
cd trustfund

# 2. Pasang dependensi
flutter pub get

# 3. (Opsional) Generate ikon aplikasi
dart run flutter_launcher_icons

# 4. Jalankan aplikasi
flutter run
```

### 🔑 Akun Demo

Aplikasi build ini hanya menerima **satu akun demo**:

| Field | Nilai |
|-------|-------|
| **Email** | `gilangns@gmail.com` |
| **Password** | `gilang123` |

> Jika email/kata sandi salah atau kosong, aplikasi akan menampilkan notifikasi error. Login yang berhasil akan langsung membawa Anda ke menu utama (bottom navigation).

### Alur Demo yang Disarankan
1. **Splash → Login** — masuk dengan akun demo di atas.
2. **Bottom Navigation** terbuka dengan tab **Beranda** terpilih secara default.
3. **Pilih kampanye mana pun** (dari Beranda atau tab Kampanye) → berpindah ke **Detail Kampanye** dengan data (nama, total terkumpul, target, RAB, milestone) yang **sesuai item yang diklik**.
4. Tekan **Donasi** → pilih nominal & metode pembayaran.
5. **Instruksi Pembayaran** (mis. BCA Virtual Account) → tekan konfirmasi.
6. **Donasi Berhasil** — tampil bukti donasi + *transaction hash* on-chain.
7. **Lacak Donasi** — pantau pencairan dana per milestone.
8. Jelajahi tab **Tersimpan** dan **Profil**.

---

## 5. Bagaimana Pilar Blockchain & AI Ditampilkan

Karena ini adalah **prototipe UI untuk demo**, pilar Blockchain dan AI direpresentasikan melalui elemen antarmuka berikut:

- **Blockchain / Smart Contract:** badge "Verified Fund", *transaction hash* pada layar Donasi Berhasil, status **"Dana Terkunci di Escrow"**, serta halaman **Lacak Donasi** yang menampilkan pencairan dana bertahap per milestone.
- **AI:** *trust score* per kampanye, status **terverifikasi** pada yayasan, dan validasi **RAB** pada halaman detail kampanye.

---

## 6. Batasan Saat Ini (Current Limitations) ⚠️

Build ini berfokus pada **alur & antarmuka (front-end prototype)**. Hal-hal berikut **belum** diimplementasikan secara penuh:

1. **Data masih mock (in-memory).** Tidak ada backend/database nyata. Seluruh data berasal dari `CampaignRepository` dan **akan kembali ke kondisi awal saat aplikasi di-restart** (termasuk kampanye yang disimpan).
2. **Belum terhubung blockchain sungguhan.** *Transaction hash* hanya contoh tampilan, dan tombol **"Lihat di Explorer"** belum membuka tautan apa pun (masih *stub*).
3. **Belum ada AI sungguhan.** *Trust score*, status verifikasi, dan validasi RAB merupakan data statis untuk keperluan demo.
4. **Autentikasi terbatas.** Hanya satu akun demo yang valid (hardcoded). Alur **daftar, lupa kata sandi, OTP, dan reset kata sandi** tersedia sebagai antarmuka, namun belum terhubung ke layanan autentikasi nyata.
5. **Pembayaran simulasi.** Nomor Virtual Account dan instruksi pembayaran bersifat *dummy*; belum terintegrasi dengan payment gateway/QRIS sungguhan.
6. **Tanpa notifikasi real-time & sesi pengguna.** Belum ada push notification, manajemen sesi, atau sinkronisasi multi-perangkat.

### Rencana Pengembangan Lanjutan
- Integrasi backend & database nyata (REST/GraphQL).
- Penerapan Smart Contract di jaringan **Polygon** beserta deep-link ke block explorer.
- Mesin **AI Document Fraud Detection** untuk verifikasi dokumen & RAB.
- Integrasi payment gateway lokal (QRIS, Virtual Account, e-wallet).
- Onboarding & verifikasi yayasan terdaftar Kemenkumham.

---

<p align="center"><strong>TrustFund — Transparan & Terpercaya.</strong><br/>NexTrust · Digdaya x Hackathon BI 2026</p>
