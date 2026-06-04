# TrustFund

TrustFund adalah aplikasi mobile **galang dana & donasi (crowdfunding sosial)**
yang dibangun dengan Flutter. Aplikasi ini menampilkan daftar kampanye amal,
detail kampanye lengkap dengan rincian penggunaan dana, alur donasi, hingga
pelacakan penyaluran dana — dengan fokus pada **kepercayaan dan transparansi**
(tercermin dari logo perisai + tangan yang memegang hati).

> Catatan: Versi ini adalah **prototipe UI/UX**. Seluruh data masih bersifat
> contoh (dummy) dan belum terhubung ke server/backend sungguhan.

---

## Daftar Isi
- [Fitur Utama](#fitur-utama)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Struktur Proyek](#struktur-proyek)
- [Cara Menjalankan](#cara-menjalankan)
- [Panduan Demo](#panduan-demo)
- [Akun Login Demo](#akun-login-demo)
- [Ikon Aplikasi (Launcher Icon)](#ikon-aplikasi-launcher-icon)
- [Batasan Saat Ini](#batasan-saat-ini)

---

## Fitur Utama

- **Splash screen** dengan logo TrustFund.
- **Autentikasi (UI)**: halaman Login, Register, Lupa Kata Sandi, OTP, dan
  Reset Kata Sandi.
- **Beranda (Home)**: sapaan pengguna, kampanye populer, dan kampanye mendesak.
- **Daftar Kampanye**: jelajah seluruh kampanye dengan **pengurutan** (terbaru,
  donasi terbanyak, segera berakhir) melalui bottom sheet.
- **Simpan Kampanye (Bookmark)**: tandai/lepas kampanye favorit. Status
  tersimpan tersinkron secara langsung di semua kartu, halaman detail, dan tab
  "Tersimpan".
- **Detail Kampanye**: progres donasi, rincian anggaran (RAB), milestone, dan
  informasi penggalang dana.
- **Alur Donasi**: pilih nominal & metode pembayaran → instruksi pembayaran →
  halaman sukses → pelacakan penyaluran dana (track donation).
- **Profil**: identitas pengguna, ringkasan dampak donasi, serta menu akun.
- **Popup "Segera Hadir"**: fitur yang belum dibangun menampilkan dialog
  terpadu, sehingga tidak ada tombol yang "mati".

---

## Teknologi yang Digunakan

| Kategori           | Teknologi / Paket                                   |
|--------------------|-----------------------------------------------------|
| Framework          | **Flutter** (Dart SDK `^3.11.0`)                    |
| State management & routing | **GetX** (`get`) — controller, binding, routing, dialog/snackbar |
| Tipografi          | **google_fonts** — *Plus Jakarta Sans*              |
| Responsif          | **flutter_screenutil** — penyesuaian ukuran (`.w/.h/.r/.sp`), `designSize` 393×852 |
| Ikon               | `cupertino_icons` + Material Icons                  |
| Generator ikon app | **flutter_launcher_icons** (dev dependency)         |
| Linting            | `flutter_lints`                                     |

**Arsitektur**: pola **GetX MVC modular**. Setiap fitur berada di
`lib/app/modules/<fitur>/` dan terdiri dari `controllers/`, `views/`, dan
`bindings/`. Logika data dipisah ke lapisan `data/` (models + repositories),
sedangkan komponen UI yang dapat dipakai ulang berada di `widgets/`, dan tema
terpusat di `core/theme/`.

**Tema terpusat**: warna, gaya teks, dan jarak diakses lewat `AppColors`,
`AppTextStyles`, dan `AppSpacing` (tidak ada nilai yang di-hardcode di UI).
Warna brand utama adalah biru (`#2563EB`) dengan gradien biru muda → biru tua.

---

## Struktur Proyek

```
trustfund/
├── assets/
│   └── logo/
│       ├── trustfund_logo.png      # logo lengkap (ikon + tulisan)
│       └── trustfund_icon.png      # ikon saja (tanpa tulisan)
├── lib/
│   ├── main.dart                   # entry point (ScreenUtilInit + GetMaterialApp)
│   └── app/
│       ├── core/
│       │   ├── theme/              # AppColors, AppTextStyles, AppSpacing, AppTheme
│       │   └── utils/              # AppDialogs (popup "Segera Hadir")
│       ├── data/
│       │   ├── models/            # model kampanye, donasi, RAB, milestone, dll.
│       │   └── repositories/      # CampaignRepository (sumber data + bookmark)
│       ├── modules/               # fitur: splash, login, register, home,
│       │                          # campaign, campaign_detail, donation,
│       │                          # payment_instruction, donation_success,
│       │                          # track_donation, saved, profile, botnavbar, dll.
│       ├── routes/                # definisi rute (app_routes.dart, app_pages.dart)
│       └── widgets/               # ±48 widget UI yang dapat dipakai ulang
├── android/ • ios/ • web/         # proyek native per platform
└── pubspec.yaml
```

Navigasi utama menggunakan **bottom navigation bar** dengan 4 tab:
**Beranda → Kampanye → Tersimpan → Profil**.

---

## Cara Menjalankan

Prasyarat: **Flutter SDK** terpasang (channel stable, mendukung Dart `^3.11.0`).

```bash
# 1. Masuk ke folder proyek
cd trustfund

# 2. Ambil dependency
flutter pub get

# 3. (Opsional, sekali saja) generate ikon launcher
dart run flutter_launcher_icons

# 4. Jalankan di emulator / perangkat
flutter run
```

---

## Panduan Demo

1. Buka aplikasi → muncul **splash screen** berlogo, lalu otomatis menuju
   halaman **Login** setelah ~2 detik.
2. **Login** menggunakan akun demo di bawah (lihat
   [Akun Login Demo](#akun-login-demo)).
   - Tombol **Masuk dengan Google / Facebook** akan menampilkan popup
     *"Segera Hadir"* (belum diimplementasikan).
3. Setelah berhasil masuk, Anda berada di **Beranda**:
   - Telusuri kampanye populer & mendesak.
   - Buka tab **Kampanye** untuk melihat semua kampanye dan mencoba fitur
     **urutkan** (ikon sort).
   - Ketuk ikon **bookmark** pada kartu mana pun untuk menyimpan kampanye;
     cek hasilnya di tab **Tersimpan**.
4. Ketuk sebuah kampanye untuk melihat **detail** (progres, RAB, milestone),
   lalu coba alur **Donasi** → pilih nominal & metode → **instruksi
   pembayaran** → **halaman sukses** → **lacak penyaluran dana**.
5. Buka tab **Profil**:
   - Pengguna ditampilkan sebagai **Gilang**.
   - Menu **"Kampanye Tersimpan"** akan membuka tab Tersimpan.
   - Menu lain (Edit Profil, Pengaturan, Riwayat Donasi, dll.) menampilkan
     popup *"Segera Hadir"*.

### Akun Login Demo

Saat ini login **hanya** menerima satu akun berikut:

| Field        | Nilai                 |
|--------------|-----------------------|
| **Email**    | `gilangns@gmail.com`  |
| **Password** | `gilang123`           |

Catatan:
- Email tidak peka huruf besar/kecil dan spasi di awal/akhir akan diabaikan.
- Kombinasi email/password lain akan menampilkan pesan error.

---

## Ikon Aplikasi (Launcher Icon)

Ikon aplikasi diatur lewat paket **flutter_launcher_icons** menggunakan berkas
`assets/logo/trustfund_icon.png`. File ikon native (Android/iOS/Web) **belum
di-generate** dalam paket ini. Untuk membuatnya, jalankan satu kali:

```bash
flutter pub get
dart run flutter_launcher_icons
```

Perintah tersebut akan menulis ikon ke `mipmap-*` (Android), `AppIcon.appiconset`
(iOS), dan `web/icons/` (Web).

---

## Batasan Saat Ini

- **Prototipe UI/UX** — belum ada backend, API, maupun basis data. Semua data
  (kampanye, donasi, dampak) masih berupa data contoh.
- **Login bersifat statis** — hanya menerima satu akun demo; belum ada sistem
  autentikasi/registrasi nyata maupun keamanan token.
- **Login sosial (Google/Facebook) belum berfungsi** — menampilkan popup
  *"Segera Hadir"*.
- **Pembayaran/donasi adalah simulasi** — tidak ada transaksi atau payment
  gateway sungguhan; alur hanya memperagakan tampilan.
- **Data tidak persisten** — kampanye tersimpan dan status login akan hilang
  setiap aplikasi ditutup (belum ada penyimpanan lokal).
- **Sejumlah fitur masih placeholder** — Edit Profil, Pengaturan, Riwayat
  Donasi, Laporan Dampak, Metode Pembayaran, KYC, Notifikasi, Pusat Bantuan,
  dan halaman informasi menampilkan popup *"Segera Hadir"*.
- **Ikon launcher native belum dibuat** sampai perintah generator dijalankan
  (lihat bagian di atas).
