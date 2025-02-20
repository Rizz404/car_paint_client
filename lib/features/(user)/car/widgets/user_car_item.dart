import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_car/data/models/user_car.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(user)/car/cubit/user_car_cubit.dart';
import 'package:paint_car/features/(user)/car/pages/upsert_user_car_page.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
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
    if (userCar.carImages == null || userCar.carImages!.isEmpty) {
      return Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: const Icon(Icons.directions_car, size: 40, color: Colors.grey),
      );
    }

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: userCar.carImages!.length,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ImageNetwork(
                    src: userCar.carImages![index]!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          if (userCar.carImages!.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  userCar.carImages!.length,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context)
            .push(
              UpsertUserCarPage.route(
                userCar: userCar,
              ),
            )
            .then((_) => widget.onRefresh()),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              _buildCarImage(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      text: userCar.licensePlate,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
