import 'package:flutter/material.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class SyaratDanKetentuanPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const SyaratDanKetentuanPage());

  const SyaratDanKetentuanPage({Key? key}) : super(key: key);

  @override
  State<SyaratDanKetentuanPage> createState() => _SyaratDanKetentuanPageState();
}

class _SyaratDanKetentuanPageState extends State<SyaratDanKetentuanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syarat dan Ketentuan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            MainText(
              text: "1. Penggunaan Aplikasi\n"
                  "Dengan menggunakan aplikasi ini, Anda menyetujui bahwa seluruh aktivitas harus dilakukan sesuai dengan peraturan yang telah ditetapkan oleh PT Contoh Indonesia.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "2. Kebijakan Privasi\n"
                  "Kami menghargai privasi Anda dan berkomitmen untuk menjaga data pribadi yang Anda berikan dengan aman. Data tersebut tidak akan disebarluaskan tanpa persetujuan.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "3. Pembatasan Tanggung Jawab\n"
                  "PT Contoh Indonesia tidak bertanggung jawab atas kerugian atau kerusakan yang terjadi akibat penggunaan aplikasi, termasuk kehilangan data, gangguan layanan, atau kerugian finansial lainnya.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "4. Perubahan Syarat dan Ketentuan\n"
                  "Kami berhak mengubah syarat dan ketentuan kapan saja tanpa pemberitahuan terlebih dahulu. Versi terbaru akan selalu tersedia pada aplikasi atau situs resmi kami.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "5. Hukum yang Berlaku\n"
                  "Syarat dan ketentuan ini diatur oleh hukum yang berlaku di Indonesia, dan setiap sengketa akan diselesaikan melalui jalur hukum sesuai peraturan yang berlaku.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "6. Penggunaan Data dan Konten\n"
                  "Semua konten dan data yang terdapat dalam aplikasi adalah milik PT Contoh Indonesia atau pihak ketiga yang telah memberikan lisensinya. Penggunaan tanpa izin dapat menimbulkan konsekuensi hukum.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "7. Kewajiban Pengguna\n"
                  "Pengguna bertanggung jawab penuh atas keamanan data dan aktivitas yang dilakukan melalui akun masing-masing. Pelanggaran terhadap syarat dan ketentuan dapat mengakibatkan penonaktifan akun secara permanen.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "8. Kontak dan Informasi\n"
                  "Untuk pertanyaan lebih lanjut atau bantuan terkait syarat dan ketentuan, Anda dapat menghubungi layanan pelanggan kami melalui email atau nomor telepon yang tertera di aplikasi.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "9. Penyelesaian Sengketa\n"
                  "Setiap perselisihan yang timbul akibat penggunaan aplikasi ini akan diselesaikan secara musyawarah terlebih dahulu. Apabila tidak mencapai kesepakatan, sengketa akan diselesaikan melalui mekanisme hukum yang berlaku.",
            ),
            SizedBox(height: 16),
            MainText(
              text: "10. Ketentuan Lain-lain\n"
                  "Ketentuan lain yang belum tercantum dalam dokumen ini akan ditetapkan kemudian sesuai dengan perkembangan dan kebutuhan operasional PT Contoh Indonesia.",
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
