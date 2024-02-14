import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../app/constants/app_asset.dart';
import '../../../../../app/constants/app_const.dart';
import '../../../../../app/managers/navigation.dart';
import '../../../../../app/themes/app_color.dart';
import '../../../../../app/themes/app_text_theme.dart';
import '../../../../../app/translations/translations.dart';
import '../../../../../app/utils/image_picker.dart';
import '../../../../../app/widgets/border_dropdown_field.dart';
import '../../../../../app/widgets/border_text_field.dart';
import '../../../../../app/widgets/bottom_sheet_custom.dart';
import '../../../../../app/widgets/cached_network_image.dart';
import '../../../../../app/widgets/gap.dart';
import '../../../../../app/widgets/text.dart';
import '../../../../../core/extensions/build_context.dart';
import '../../../../../core/extensions/date_time.dart';
import '../../../../../core/extensions/string.dart';
import '../../../domain/entities/user_entity.dart';
import '../../cubits/user_data/user_data_cubit.dart';

enum EGender { male, female, other }

extension EGenderExt on EGender {
  String get value => switch (this) {
        EGender.male => "Male",
        EGender.female => "Female",
        EGender.other => "Other"
      };
}

class ProfileEditPersonalInfoPage extends StatefulWidget {
  const ProfileEditPersonalInfoPage({
    super.key,
    required this.userEntity,
  });

  final UserEntity userEntity;

  @override
  State<ProfileEditPersonalInfoPage> createState() =>
      _ProfileEditPersonalInfoPageState();
}

class _ProfileEditPersonalInfoPageState
    extends State<ProfileEditPersonalInfoPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdayController;

  ValueNotifier<XFile?> selectedImage = ValueNotifier(null);
  String _selectedGender = EGender.values.first.value;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userEntity.name);
    _phoneController =
        TextEditingController(text: widget.userEntity.phone ?? '');
    _birthdayController = TextEditingController(
      text: (widget.userEntity.birthday ?? DateTime.now()).ddMMyyyy,
    );

    _selectedGender = widget.userEntity.gender ?? EGender.values.first.value;
  }

  Future<void> _onPickImage() async {
    final image = await ImagePickerUtil().pickImage();
    if (image == null) {
      Navigators().showMessage(
        LocaleKeys.profile_no_file_selected.tr(),
        type: MessageType.error,
      );
    } else {
      final imageLength = await image.length();
      if (imageLength > AppValueConst.maxImgUploadSize) {
        const maxSize = AppValueConst.maxImgUploadSize ~/ 1024 ~/ 1024;
        Navigators().showMessage(
          LocaleKeys.profile_file_size_less_than.tr(
            args: [maxSize.toString()],
          ),
          type: MessageType.error,
          duration: 5,
        );
      } else {
        selectedImage.value = image;
      }
    }
  }

  Future<void> _onSelectDatePicker() async {
    final DateTime? result = await context.showDatePickerPopup(
      initDate: _birthdayController.text.toDate,
    );
    if (result != null) {
      _birthdayController.text = result.ddMMyyyy;
    }
  }

  Future<void> _onSavePressed() async {
    final updateEntity = widget.userEntity.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      birthday: _birthdayController.text.trim().toDate,
      gender: _selectedGender,
    );
    if (context.read<UserDataCubit>().state is UserDataLoadedState) {
      await Navigators().showLoading(
        delay: Durations.medium1,
        task: context.read<UserDataCubit>().updateUserProfile(
              updateEntity,
              selectedImage.value,
            ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetCustom(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      textTitle: LocaleKeys.profile_edit_profile.tr(),
      onAction: _onSavePressed,
      children: [
        _buildAvatar(widget.userEntity.avatar),
        _buildInputBody(),
        const Gap(height: 10),
      ],
    );
  }

  Widget _buildInputBody() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldItem(
            controller: _nameController,
            label: LocaleKeys.profile_display_name.tr(),
            hintText: LocaleKeys.profile_enter_display_name.tr(),
            icon: AppAssets.profileIconOutline,
            inputType: TextInputType.name,
          ),
          _buildFieldItem(
            controller: _phoneController,
            label: LocaleKeys.profile_phone.tr(),
            hintText: LocaleKeys.profile_enter_phone_number.tr(),
            icon: AppAssets.phoneOutline,
            inputType: TextInputType.phone,
            maxLength: 12,
          ),
          _buildFieldItem(
            controller: _birthdayController,
            onTap: _onSelectDatePicker,
            label: LocaleKeys.profile_birthday.tr(),
            hintText: '',
            enable: false,
            icon: AppAssets.calendarOutline,
          ),
          _buildDropdownItem(
            initialValue: _selectedGender,
            values: EGender.values.map((e) => e.value).toList(),
            icon: AppAssets.genderOutline,
            label: LocaleKeys.profile_gender.tr(),
            onChanged: (value) {
              _selectedGender = value ?? _selectedGender;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem({
    required String icon,
    required String label,
    required String initialValue,
    required List<String> values,
    required Function(String? value) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
          child: TextCustom(
            label,
            style: context.textStyle.labelL.bold.grey,
          ),
        ),
        BorderDropdownField(
          icon: icon,
          initialValue: initialValue,
          items: values,
          onChanged: onChanged,
        ),
        const Gap(height: 12),
      ],
    );
  }

  Widget _buildFieldItem({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String icon,
    int? maxLength,
    TextInputType inputType = TextInputType.text,
    bool enable = true,
    Color? hintColor,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
          child: TextCustom(
            label,
            style: context.textStyle.labelL.bold.grey,
          ),
        ),
        BorderTextField(
          controller: controller,
          inputType: inputType,
          hintText: hintText,
          hintColor: hintColor,
          maxLength: maxLength,
          enable: enable,
          icon: icon,
          onTap: onTap,
        ),
        const Gap(height: 12),
      ],
    );
  }

  Widget _buildAvatar(String? url) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      child: Align(
        alignment: Alignment.topCenter,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            ValueListenableBuilder(
              valueListenable: selectedImage,
              builder: (context, XFile? img, _) {
                return CachedNetworkImageCustom(
                  url: img?.path ?? url,
                  size: 72,
                );
              },
            ),
            GestureDetector(
              onTap: _onPickImage,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  color: context.colors.grey200,
                ),
                child: SvgPicture.asset(
                  AppAssets.camera,
                  colorFilter: ColorFilter.mode(
                    context.colors.grey600,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
