import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/car/pages/upsert_user_car_page.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/extension/padding.dart';
import 'package:paint_car/ui/shared/delete_confirm_dialog.dart';
import 'package:paint_car/ui/shared/image_network.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class UserCarItem extends StatefulWidget {
  final UserCar userCar;
  final Function() onDelete;
  final Function() onRefresh;

  const UserCarItem({
    super.key,
    required this.userCar,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  State<UserCarItem> createState() => _UserCarItemState();
}

class _UserCarItemState extends State<UserCarItem> {
  late final UserCar userCar;
  late final PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    userCar = widget.userCar;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BlocConsumer<UserCarCubit, BaseState>(
        listener: (context, state) {
          handleFormListenerState(
            context: context,
            state: state,
            onRetry: widget.onDelete,
            onSuccess: () => Navigator.pop(context),
          );
        },
        builder: (context, state) {
          return DeleteConfirmDialog(
            title: "Hapus ${userCar.licensePlate}?",
            description: "Apakah Anda yakin ingin menghapus kendaraan ini?",
            onDelete: widget.onDelete,
          );
        },
      ),
    );
  }

  Widget _buildCarImage() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: userCar.carImages?.isNotEmpty ?? false
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: userCar.carImages!.length,
                    onPageChanged: (index) {
                      setState(() => _currentImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return ImageNetwork(
                        src: userCar.carImages![index]!,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  if (userCar.carImages!.length > 1)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: MainText(
                        text:
                            '${_currentImageIndex + 1}/${userCar.carImages!.length}',
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                ],
              )
            : Container(
                color: Colors.grey[100],
                child: Center(
                  child: Icon(
                    Icons.car_rental,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),
      ),
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const MainText(text: 'Edit'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(
                      UpsertUserCarPage.route(userCar: userCar),
                    )
                    .then((_) => widget.onRefresh());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              title: const MainText(text: 'Hapus'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context)
              .push(
                UpsertUserCarPage.route(userCar: userCar),
              )
              .then((_) => widget.onRefresh());
        },
        child: Row(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarImage(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  MainText(
                    text: userCar.licensePlate,
                    customTextStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  MainText(
                    text:
                        '${userCar.carModelYearColor?.carModelYear!.carModel!.carBrand!.name ?? '-'} '
                        '${userCar.carModelYearColor?.carModelYear!.carModel!.name ?? '-'}',
                    maxLines: 2,
                    extent: const ExtraSmall(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          MainText(
                            text:
                                '${userCar.carModelYearColor?.carModelYear!.year ?? '-'}',
                            extent: const ExtraSmall(),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(
                            Icons.palette_outlined,
                            size: 12,
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          MainText(
                            text: userCar.carModelYearColor?.color!.name ?? '-',
                            extent: const ExtraSmall(),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showActionMenu(context),
              color: colorScheme.onSurface.withValues(
                alpha: 0.6,
              ),
            ),
          ],
        ).paddingAll(),
      ),
    );
  }
}
