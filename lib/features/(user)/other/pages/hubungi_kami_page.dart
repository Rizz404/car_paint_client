import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter/material.dart';

class HubungiKamiPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const HubungiKamiPage());

  const HubungiKamiPage({Key? key}) : super(key: key);

  @override
  State<HubungiKamiPage> createState() => _HubungiKamiPageState();
}

class _HubungiKamiPageState extends State<HubungiKamiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hubungi Kami'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tampilan gambar/logo PT
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/konosuba.jpg'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Nama PT
            const ListTile(
              leading: Icon(Icons.business),
              title: Text('PT. Contoh Indonesia'),
            ),
            const Divider(),
            // Kontak WhatsApp PT
            ListTile(
              leading: SvgPicture.asset(
                'assets/images/whatsapp.svg',
                width: 24,
                height: 24,
              ),
              title: const Text('WhatsApp'),
              subtitle: const Text('+62 812-3456-7890'),
              onTap: () {
                // Tambahkan logika untuk membuka WhatsApp jika diperlukan
              },
            ),
            const Divider(),
            // Lokasi PT
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Lokasi'),
              subtitle: Text('Jl. Contoh No. 123, Jakarta, Indonesia'),
            ),
            const Divider(),
            // Informasi lainnya (misal, Email, Website, dll)
            const ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text('info@ptcontoh.com'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.web),
              title: Text('Website'),
              subtitle: Text('www.ptcontoh.com'),
            ),
          ],
        ),
      ),
    );
  }
}
