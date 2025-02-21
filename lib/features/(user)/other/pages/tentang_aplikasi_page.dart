import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class TentangAplikasiPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const TentangAplikasiPage());

  const TentangAplikasiPage({Key? key}) : super(key: key);

  @override
  State<TentangAplikasiPage> createState() => _TentangAplikasiPageState();
}

class _TentangAplikasiPageState extends State<TentangAplikasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(
        "Tentang Aplikasi",
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              text: 'Tentang Aplikasi',
              extent: Large(),
            ),
            SizedBox(height: 16),
            MainText(
              text:
                  'Aplikasi Cat Mobil adalah platform yang menghubungkan pemilik mobil dengan bengkel cat profesional. '
                  'Dengan integrasi payment gateway (Xendit), aplikasi ini menyediakan proses transaksi yang mudah dan aman.',
              maxLines: 100,
            ),
            SizedBox(height: 24),
            MainText(
              text: 'Fitur Utama:',
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.person),
              title: MainText(text: 'Registrasi & Login'),
              subtitle: MainText(
                text: 'Pengguna mendaftar dan masuk ke aplikasi dengan mudah.',
                maxLines: 100,
              ),
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: MainText(text: 'Create User Car'),
              subtitle: MainText(
                text: 'Pengguna dapat menambahkan data mobil yang ingin dicat.',
                maxLines: 100,
              ),
            ),
            ListTile(
              leading: Icon(Icons.store_mall_directory),
              title: MainText(text: 'Workshop Page'),
              subtitle: MainText(
                text: 'Cari bengkel cat mobil yang terpercaya.',
                maxLines: 100,
              ),
            ),
            ListTile(
              leading: Icon(Icons.build),
              title: MainText(text: 'Pilih Panel Mobil'),
              subtitle: MainText(
                text: 'Tentukan panel atau bagian mobil yang akan dicat.',
                maxLines: 100,
              ),
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: MainText(text: 'Payment Method & Transactions'),
              subtitle: MainText(
                text:
                    'Pilih metode pembayaran dan selesaikan transaksi melalui Xendit.',
                maxLines: 100,
              ),
            ),
            SizedBox(height: 24),
            MainText(
              text: 'User Flow:',
              extent: Large(),
            ),
            SizedBox(height: 16),
            MainText(
              text:
                  '1. Registrasi: Pengguna mendaftar menggunakan data yang valid.\n'
                  '2. Login: Pengguna masuk ke aplikasi setelah registrasi.\n'
                  '3. Create User Car: Pengguna menambahkan mobil yang ingin dicat.\n'
                  '4. Order: Pengguna melakukan pemesanan layanan cat mobil.\n'
                  '5. Workshop Page: Pengguna mencari bengkel yang sesuai dengan kebutuhan.\n'
                  '6. Pilih Panel: Pengguna memilih panel atau bagian mobil yang akan dicat.\n'
                  '7. Pilih Mobil: Pengguna menentukan mobil yang akan dicat dari daftar mobil yang telah didaftarkan.\n'
                  '8. Payment Method: Pengguna memilih metode pembayaran.\n'
                  '9. Transactions Page: Pengguna diarahkan ke halaman transaksi dan menyelesaikan pembayaran melalui payment gateway Xendit.\n',
              maxLines: 100,
            ),
            SizedBox(height: 24),
            MainText(
              text:
                  'Dengan aplikasi ini, kami berkomitmen untuk menyediakan layanan pengecatan mobil yang profesional, '
                  'mudah diakses, dan aman melalui sistem pembayaran terintegrasi. Selamat mencoba!',
              maxLines: 100,
            ),
          ],
        ),
      ),
    );
  }
}
