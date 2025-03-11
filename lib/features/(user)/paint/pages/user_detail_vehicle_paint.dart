// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/features/(user)/paint/widgets/checkbox_paint_panel.dart';
import 'package:paint_car/features/(user)/paint/widgets/select_field_vehicle.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';

// ! design example
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
  String selectedBrand = "Toyota";
  String selectedModel = "Pajero";
  String selectedTahun = "2020";
  String selectedWarnaMobil = "Black - 601-5050";
  final brands = ["Toyota", "Honda", "Suzuki", "Mitsubishi", "Daihatsu"];
  final models = ["Pajero", "Xpander", "Outlander", "Eclipse Cross"];
  final tahun = ["2020", "2021", "2022", "2023"];
  final warnaMobil = [
    "Black - 601-5050",
    "White - 601-5050",
    "Red - 601-5050",
    "Blue - 601-5050"
  ];
  bool isFullBodySelected = false;
  bool isHoodSelected = false;
  bool isDoorSelected = false;
  bool isFenderSelected = false;
  bool isRoofSelected = false;
  bool isTrunkSelected = false;
  bool isBumperSelected = false;
  bool isFrontBumperSelected = false;

  @override
  Widget build(BuildContext context) {
    final divider = const Divider(
      color: CustomColors.gray,
      thickness: 1,
    );
    return Scaffold(
      appBar: mainAppBar("Detail Vehicle Paint"),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          spacing: 24,
          children: [
            const MainText(
              text: "Detail Kendaraan Dan Pengecatan",
              extent: Large(),
            ),
            Column(
              children: [
                Column(
                  children: [
                    SelectFieldVehicle(
                      field: "Merk Mobil*",
                      value: selectedBrand,
                      options: brands,
                      onSelected: (value) {
                        setState(() {
                          selectedBrand = value;
                        });
                      },
                    ),
                    divider,
                  ],
                ),
                Column(
                  children: [
                    SelectFieldVehicle(
                      field: "Model / Tipe*",
                      value: selectedModel,
                      options: models,
                      onSelected: (value) {
                        setState(() {
                          selectedModel = value;
                        });
                      },
                    ),
                    divider,
                  ],
                ),
                Column(
                  children: [
                    SelectFieldVehicle(
                      field: "Tahun*",
                      value: selectedTahun,
                      options: tahun,
                      onSelected: (value) {
                        setState(() {
                          selectedTahun = value;
                        });
                      },
                    ),
                    divider,
                  ],
                ),
                Column(
                  children: [
                    SelectFieldVehicle(
                      field: "Warna Mobil*",
                      value: selectedWarnaMobil,
                      options: warnaMobil,
                      onSelected: (value) {
                        setState(() {
                          selectedWarnaMobil = value;
                        });
                      },
                    ),
                    divider,
                  ],
                ),
                GestureDetector(
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
                ),
              ],
            ),
            Column(
              spacing: 16,
              children: [
                const MainText(
                  text: "Pilih Bagian yang Ingin di Cat",
                  extent: const Large(),
                ),
                // TODO: TAMBAHIN CHECKBOX, BACKGROUND COLOR, BORDER, FUNCTIONALITY CHECKBOX
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_full_body.png",
                  title: "Full Body",
                  value: isFullBodySelected,
                  onChanged: (value) {
                    setState(() {
                      isFullBodySelected = value!;
                    });
                  },
                ),
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_hood.png",
                  title: "Hood",
                  value: isHoodSelected,
                  onChanged: (value) {
                    setState(() {
                      isHoodSelected = value!;
                    });
                  },
                ),
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_door.png",
                  title: "Door",
                  value: isDoorSelected,
                  onChanged: (value) {
                    setState(() {
                      isDoorSelected = value!;
                    });
                  },
                ),
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_fender.png",
                  title: "Fender",
                  value: isFenderSelected,
                  onChanged: (value) {
                    setState(() {
                      isFenderSelected = value!;
                    });
                  },
                ),
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_roof.png",
                  title: "Roof",
                  value: isRoofSelected,
                  onChanged: (value) {
                    setState(() {
                      isRoofSelected = value!;
                    });
                  },
                ),
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_bumper.png",
                  title: "Bumper",
                  value: isBumperSelected,
                  onChanged: (value) {
                    setState(() {
                      isBumperSelected = value!;
                    });
                  },
                ),
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_front_bumper.png",
                  title: "FrontBumper",
                  value: isFrontBumperSelected,
                  onChanged: (value) {
                    setState(() {
                      isFrontBumperSelected = value!;
                    });
                  },
                ),
                CheckboxPaintPanel(
                  imageAsset: "assets/images/car/black_car_roof.png",
                  title: "Roof",
                  value: isRoofSelected,
                  onChanged: (value) {
                    setState(() {
                      isRoofSelected = value!;
                    });
                  },
                ),
              ],
            ).paddingSymmetric(
              horizontal: 16,
            ),
            MainElevatedButton(
              onPressed: () {},
              text: "Selanjutnya",
              bgColor: CustomColors.blue,
              borderRadius: 10,
            )
          ],
        )
            .paddingSymmetric(
              horizontal: 16,
            )
            .paddingOnly(top: 16, bottom: 16),
      ),
    );
  }

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
              Align(
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
              ),
              const Center(
                child: MainText(
                  text: "Lokasi Kode Warna Mobil",
                  extent: Large(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
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
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
