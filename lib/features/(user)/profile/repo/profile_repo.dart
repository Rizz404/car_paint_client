import 'dart:io';

import 'package:paint_car/core/common/api_response.dart';
import 'package:paint_car/core/constants/api.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/data/network/api_client.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_api_response.dart';

class ProfileRepo {
  final ApiClient apiClient;
  const ProfileRepo({required this.apiClient});

  static const String keyImageFile = 'profileImage';

  Future<ApiResponse<UserWithProfile>> updateUser(
    UserWithProfile user,
    File? imageFile,
    CancelToken cancelToken,
  ) async {
    final result = await apiClient.patch<UserWithProfile>(
      ApiConstant.updateCurrentUserPath,
      {
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "fullname": user.userProfile?.fullname,
        "phoneNumber": user.userProfile?.phoneNumber,
        "address": user.userProfile?.address,
      },
      isMultiPart: true,
      imageFile: imageFile,
      keyImageFile: keyImageFile,
      fromJson: (json) => UserWithProfile.fromMap(json),
      cancelToken: cancelToken,
    );
    return await handleApiResponse(result, isGet: false);
  }
}
