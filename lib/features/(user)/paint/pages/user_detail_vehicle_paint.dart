// ignore_for_file: require_trailing_commas
import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/user_detail_vehicle_paint_model.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/paint/widgets/checkbox_paint_panel.dart';
import 'package:paint_car/features/(user)/paint/widgets/select_field_vehicle.dart';
import 'package:paint_car/features/(user)/workshop/pages/user_workshops_page.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';

/// Kelas utama halaman pengecatan kendaraan
class UserDetailVehiclePaintPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) => const UserDetailVehiclePaintPage());

  const UserDetailVehiclePaintPage({super.key});

  @override
  State<UserDetailVehiclePaintPage> createState() =>
      _UserDetailVehiclePaintPageState();
}

class _UserDetailVehiclePaintPageState
    extends State<UserDetailVehiclePaintPage> {
  // Data kendaraan
  late VehicleData _vehicleData;

  // Bagian-bagian yang dapat dicat
  late PaintableParts _paintableParts;

  // Daftar model mobil yang tersedia berdasarkan merek yang dipilih
  List<String> get _availableModels => _models[_vehicleData.brand] ?? [];

  // Daftar warna mobil yang tersedia berdasarkan merek dan model yang dipilih
  List<String> get _availableColors {
    List<CarColor> brandColors = _carColorsByBrand[_vehicleData.brand] ?? [];

    if (_vehicleData.model.isEmpty) {
      // Jika model belum dipilih, tampilkan semua warna untuk merek tersebut
      return brandColors.map((color) => color.name).toList();
    } else {
      // Filter warna berdasarkan model yang dipilih
      return brandColors
          .where((color) => color.availableModels.contains(_vehicleData.model))
          .map((color) => color.name)
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _vehicleData = VehicleData(
      brand: "Toyota",
      model: "Innova",
      year: "2020",
      color: "",
    );

    // Set warna default ke warna pertama yang tersedia
    if (_availableColors.isNotEmpty) {
      _vehicleData.color = _availableColors.first;
    }

    _paintableParts = PaintableParts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar("Detail Vehicle Paint"),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          child: Column(
            spacing: 24,
            children: [
              _buildHeader(),
              _buildVehicleDetailsSection(),
              _buildPaintSelectionSection(),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk header halaman
  Widget _buildHeader() {
    return const MainText(
      text: "Detail Kendaraan Dan Pengecatan",
      extent: Large(),
    );
  }

  /// Widget untuk bagian detail kendaraan
  Widget _buildVehicleDetailsSection() {
    final divider = const Divider(
      color: CustomColors.gray,
      thickness: 1,
    );

    return Column(
      children: [
        _buildBrandSelectField(divider),
        _buildModelSelectField(divider),
        _buildYearSelectField(divider),
        _buildColorSelectField(divider),
        _buildColorCodeHelpText(),
      ],
    );
  }

  /// Widget untuk select field merek
  Widget _buildBrandSelectField(Widget divider) {
    return Column(
      children: [
        SelectFieldVehicle(
          field: "Merk Mobil*",
          value: _vehicleData.brand,
          options: _brands,
          onSelected: (value) {
            setState(() {
              _vehicleData.brand = value;

              // Reset model ke yang pertama tersedia untuk merek baru
              if (_availableModels.isNotEmpty) {
                _vehicleData.model = _availableModels.first;
              } else {
                _vehicleData.model = "";
              }

              // Reset warna ke yang pertama tersedia untuk merek dan model baru
              if (_availableColors.isNotEmpty) {
                _vehicleData.color = _availableColors.first;
              } else {
                _vehicleData.color = "";
              }
            });
          },
        ),
        divider,
      ],
    );
  }

  /// Widget untuk select field model
  Widget _buildModelSelectField(Widget divider) {
    return Column(
      children: [
        SelectFieldVehicle(
          field: "Model / Tipe*",
          value: _vehicleData.model,
          options: _availableModels,
          onSelected: (value) {
            setState(() {
              _vehicleData.model = value;

              // Update warna sesuai dengan model yang dipilih
              if (_availableColors.isNotEmpty) {
                _vehicleData.color = _availableColors.first;
              } else {
                _vehicleData.color = "";
              }
            });
          },
        ),
        divider,
      ],
    );
  }

  /// Widget untuk select field tahun
  Widget _buildYearSelectField(Widget divider) {
    return Column(
      children: [
        SelectFieldVehicle(
          field: "Tahun*",
          value: _vehicleData.year,
          options: _years,
          onSelected: (value) {
            setState(() {
              _vehicleData.year = value;
            });
          },
        ),
        divider,
      ],
    );
  }

  /// Widget untuk select field warna
  Widget _buildColorSelectField(Widget divider) {
    return Column(
      children: [
        SelectFieldVehicle(
          field: "Warna Mobil*",
          value: _vehicleData.color,
          options: _availableColors,
          onSelected: (value) {
            setState(() {
              _vehicleData.color = value;
            });
          },
        ),
        divider,
      ],
    );
  }

  /// Widget untuk bantuan kode warna
  Widget _buildColorCodeHelpText() {
    return GestureDetector(
      onTap: () => _showColorCodeModal(context),
      child: const MainText(
        text: "Cara menemukan kode warna mobil Anda",
        customTextStyle: TextStyle(
          fontSize: 16,
          decoration: TextDecoration.underline,
          decorationColor: CustomColors.tertiaryBlue,
          color: CustomColors.tertiaryBlue,
        ),
      ),
    );
  }

  /// Widget untuk bagian pemilihan area pengecatan
  Widget _buildPaintSelectionSection() {
    return Column(
      spacing: 16,
      children: [
        const MainText(
          text: "Pilih Bagian yang Ingin di Cat",
          extent: Large(),
        ),
        _buildPaintCheckboxes(),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  /// Widget untuk checkbox pemilihan bagian
  Widget _buildPaintCheckboxes() {
    return Column(
      spacing: 12,
      children: [
        _buildCheckboxPaintPanel(
          "assets/images/car/black_car_full_body.png",
          "Full Body",
          _paintableParts.isFullBodySelected,
          (value) =>
              setState(() => _paintableParts.isFullBodySelected = value!),
        ),
        _buildCheckboxPaintPanel(
          "assets/images/car/black_car_hood.png",
          "Hood",
          _paintableParts.isHoodSelected,
          (value) => setState(() => _paintableParts.isHoodSelected = value!),
        ),
        _buildCheckboxPaintPanel(
          "assets/images/car/black_car_door.png",
          "Door",
          _paintableParts.isDoorSelected,
          (value) => setState(() => _paintableParts.isDoorSelected = value!),
        ),
        _buildCheckboxPaintPanel(
          "assets/images/car/black_car_fender.png",
          "Fender",
          _paintableParts.isFenderSelected,
          (value) => setState(() => _paintableParts.isFenderSelected = value!),
        ),
        _buildCheckboxPaintPanel(
          "assets/images/car/black_car_roof.png",
          "Roof",
          _paintableParts.isRoofSelected,
          (value) => setState(() => _paintableParts.isRoofSelected = value!),
        ),
        _buildCheckboxPaintPanel(
          "assets/images/car/black_car_bumper.png",
          "Bumper",
          _paintableParts.isBumperSelected,
          (value) => setState(() => _paintableParts.isBumperSelected = value!),
        ),
        _buildCheckboxPaintPanel(
          "assets/images/car/black_car_front_bumper.png",
          "FrontBumper",
          _paintableParts.isFrontBumperSelected,
          (value) =>
              setState(() => _paintableParts.isFrontBumperSelected = value!),
        ),
      ],
    );
  }

  /// Widget untuk panel checkbox
  Widget _buildCheckboxPaintPanel(
    String imageAsset,
    String title,
    bool isSelected,
    void Function(bool?) onChanged,
  ) {
    return CheckboxPaintPanel(
      imageAsset: imageAsset,
      title: title,
      value: isSelected,
      onChanged: onChanged,
    );
  }

  /// Widget untuk tombol selanjutnya
  Widget _buildNextButton() {
    return MainElevatedButton(
      onPressed: _handleNextButton,
      text: "Selanjutnya",
      bgColor: CustomColors.blue,
      borderRadius: 10,
    );
  }

  /// Menangani aksi tombol selanjutnya
  void _handleNextButton() {
    // Implementasi logika untuk tombol selanjutnya
    LogService.i("Vehicle Data: $_vehicleData, $_paintableParts");
    Navigator.of(context).push(UserWorkshopsPage.route(
      vehicleData: _vehicleData,
      paintableParts: _paintableParts,
    ));
  }

  /// Menampilkan modal kode warna
  void _showColorCodeModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModalCloseButton(context),
              _buildModalTitle(),
              const SizedBox(height: 16),
              _buildModalImages(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk tombol tutup modal
  Widget _buildModalCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.close,
            color: CustomColors.tertiaryGray,
          ),
        ),
      ),
    );
  }

  /// Widget untuk judul modal
  Widget _buildModalTitle() {
    return const Center(
      child: MainText(
        text: "Lokasi Kode Warna Mobil",
        extent: Large(),
      ),
    );
  }

  /// Widget untuk gambar dalam modal
  Widget _buildModalImages() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "assets/images/car/location_code_color_car_1.png",
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/images/car/location_code_color_car_2.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

// Daftar opsi untuk dropdown
final _brands = ["Toyota", "Mitsubishi", "Suzuki", "Honda"];
final _models = {
  "Toyota": [
    "Innova",
    "Avanza",
    "Fortuner",
    "Yaris",
    "Calya",
    "Agya",
    "Rush",
    "Alphard"
  ],
  "Mitsubishi": ["Xpander", "Outlander", "Pajero", "Mirage"],
  "Suzuki": ["Ertiga", "XL7", "APV", "Ignis", "Baleno", "Karimun", "Swift"],
  "Honda": ["Jazz", "HRV", "CRV", "Mobilio", "Brio", "BRV", "Accord"],
};
final List<String> _years = ["2020", "2021", "2022", "2023"];

// Database warna mobil berdasarkan merek
final Map<String, List<CarColor>> _carColorsByBrand = {
  "Toyota": [
    CarColor(name: "Attitude Black 218", availableModels: [
      "Innova",
      "Yaris",
      "Fortuner",
      "Vios",
      "Camry",
      "Altis"
    ]),
    CarColor(
        name: "Avant Garde Brown 4V8", availableModels: ["Innova", "Fortuner"]),
    CarColor(
        name: "Black 202",
        availableModels: ["Calya", "Agya", "Alphard", "Land Cruiser"]),
    CarColor(name: "Black Mica 209", availableModels: [
      "Avanza",
      "Rush",
      "Altis",
      "Fortuner",
      "Innova",
      "Yaris",
      "Vios"
    ]),
    CarColor(
        name: "Dark Blue Mica 8N8",
        availableModels: ["Avanza", "Innova", "Agya", "Vios"]),
    CarColor(name: "Dark Grey Mica 1G3", availableModels: [
      "Innova",
      "Calya",
      "Avanza",
      "Sienta",
      "Yaris",
      "Agya"
    ]),
    CarColor(name: "Super White II 040", availableModels: [
      "Avanza",
      "Calya",
      "Agya",
      "Rush",
      "Vios",
      "Land Cruiser"
    ]),
  ],
  "Mitsubishi": [
    CarColor(
        name: "Cool Silver A66",
        availableModels: ["Xpander", "Outlander", "Pajero", "Mirage"]),
    CarColor(
        name: "Diamond Black Mica X37",
        availableModels: ["Xpander", "Outlander", "Pajero", "Mirage"]),
    CarColor(
        name: "Titanium Grey",
        availableModels: ["Xpander", "Outlander", "Pajero", "Mirage"]),
    CarColor(
        name: "White Pearl",
        availableModels: ["Xpander", "Outlander", "Pajero", "Mirage"]),
    CarColor(
        name: "Red Metallic",
        availableModels: ["Xpander", "Outlander", "Pajero", "Mirage"]),
    CarColor(
        name: "Deep Bronze MET",
        availableModels: ["Xpander", "Outlander", "Pajero", "Mirage"]),
  ],
  "Suzuki": [
    CarColor(
        name: "Burgundy Red ZLL",
        availableModels: ["Ertiga", "APV", "Karimun"]),
    CarColor(
        name: "Cool Black ZBD",
        availableModels: ["XL7", "Ertiga", "APV", "Ignis", "Baleno"]),
    CarColor(
        name: "UC Snow Pearl White ZHJ",
        availableModels: ["Ertiga", "APV", "Karimun", "Swift"]),
    CarColor(
        name: "Graphite Grey ZDL",
        availableModels: ["Ertiga", "Ignis", "Karimun", "Baleno"]),
    CarColor(
        name: "Silky Silver Z2S",
        availableModels: ["Ertiga", "Ignis", "Karimun", "APV", "Carry"]),
  ],
  "Honda": [
    CarColor(
        name: "Crystal Black NH731P",
        availableModels: ["Jazz", "HRV", "CRV", "Mobilio", "Brio"]),
    CarColor(
        name: "Tafeta White NH 578",
        availableModels: ["Brio", "Mobilio", "BRV"]),
    CarColor(
        name: "Modern Steel MET NH 797M",
        availableModels: ["Brio", "Mobilio", "BRV", "CRV", "Jazz", "Accord"]),
    CarColor(
        name: "UC Orchid White NH 788 P",
        availableModels: ["Jazz", "CRV", "HRV", "Mobilio", "Brio"]),
    CarColor(
        name: "Rallye Red R513",
        availableModels: ["Jazz", "CRV", "HRV", "Mobilio", "Brio"]),
  ],
};
