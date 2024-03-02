// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en_US = {
  "app_language": {
    "english": "English",
    "vietnamese": "Vietnamese"
  },
  "app_log": {
    "on_restart": "Welcome back!"
  },
  "auth": {
    "already_have_an_account": "Already have an account?",
    "are_you_want_to_sign_out": "Are you sure you want to sign out?",
    "confirm_password": "Confirm password",
    "create_an_account": "Create an account",
    "enter_email": "Enter email",
    "enter_password": "Enter password",
    "forgot_password": "Forgot password?",
    "invalid_email": "Email could only contains . - _ as the special characters",
    "invalid_password": "Password must contains 8 characters and numbers.",
    "or_sign_in_with": "Or sign in with:",
    "password_does_not_match": "Password does not match",
    "please_enter_and_password": "Please enter email and password!",
    "sign_in": "Sign in",
    "sign_in_as_email": "Sign in as {email}",
    "sign_out": "Sign out",
    "sign_up": "Sign up",
    "welcome": "Welcome",
    "change_password": "Change password",
    "enter_current_password": "Enter the current password",
    "enter_new_password": "Enter the new password",
    "change_password_sub_title": "Please enter your password information below.",
    "change_password_success": "Changed password successfully",
    "please_re_login": "Please re-login to update the new changes.",
    "enter_new_pass_below": "Enter your new password below.",
    "we_sent_verfication_code_to_email": "We have just sent you a verification code into your email: {}",
    "enter_verification_code": "Enter verification code",
    "enter_email_to_reset_password": "Enter your email address below, we will send you a verification code to reset your password."
  },
  "common": {
    "accept": "Accept",
    "browse": "Browse",
    "cancel": "Cancel",
    "close": "Close",
    "done": "Done",
    "error": "Error",
    "is_copied_to_clipboard": "'{word}' is copied to clipboard.",
    "next": "Next",
    "okay": "Okay",
    "other_k": "Other",
    "retry": "Retry",
    "save": "Save",
    "select": "Select",
    "skip": "Skip"
  },
  "on_board": {
    "get_started": "Get started",
    "onboard_body": "We will help you learn English vocabulary everyday, effectively. Trust me, this is really fun!",
    "onboard_title": "Let's learn!",
    "select_language": "Select language",
    "select_language_content": "Don't worry! You can change it later on Settings."
  },
  "page": {
    "activity": "Activity",
    "home": "Home",
    "profile": "Profile",
    "search": "Search",
    "setting": "Setting",
    "favourite": "Favourite"
  },
  "profile": {
    "birthday": "Birthday",
    "completion_progress": "Completion progress",
    "created_date": "Created date",
    "display_name": "Display name",
    "edit_profile": "Edit profile",
    "enter_display_name": "Enter your display name",
    "enter_phone_number": "Enter your phone number",
    "gender": "Gender",
    "no_info": "No info",
    "personal_info": "Personal info",
    "phone": "Phone",
    "profile_title": "My profile",
    "update_success": "Update successful",
    "invalid_phone_number": "Invalid phone number.",
    "no_empty_display_name": "Display name can not be empty.",
    "everything_is_up_to_date": "Everything is up to date.",
    "no_file_selected": "No file selected.",
    "file_size_less_than": "File's size should be less than {}MB.",
    "attendance": "Attendance"
  },
  "search": {
    "are_you_looking_for": "Are you looking for?",
    "not_found": "Not found",
    "search_for_words": "Search for words",
    "type_something": "Type something",
    "show_more": "Show more"
  },
  "user_data": {
    "point": {
      "many": "{} points",
      "one": "1 point",
      "other": "{} points",
      "zero": "No points"
    }
  },
  "utils": {
    "check_your_internet_connection": "Check your internet connection",
    "no_internet_connection": "No internet connection",
    "you_back_online": "Woohoo! You are back online."
  },
  "home": {
    "tab_points": "Points",
    "tab_attendances": "Attendances",
    "day": {
      "many": "{} days",
      "one": "1 day",
      "other": "{} days",
      "zero": "0 day"
    },
    "general": "General",
    "every_day_new_word": "Every day a new word",
    "leaderboard": "Leaderboard",
    "check_in": "Check-in",
    "this_week": "This week",
    "this_month": "This month",
    "time": {
      "zero": "0 times",
      "one": "1 time",
      "other": "{} times",
      "many": "{} times"
    },
    "learn_more": "Learn more",
    "check_in_success": "Yay! Check-in successful."
  },
  "word_detail": {
    "examples": {
      "zero": "Examples",
      "one": "Example",
      "many": "Examples",
      "other": "Examples"
    },
    "synonyms": {
      "zero": "Synonyms",
      "one": "Synonym",
      "many": "Synonyms",
      "other": "Synonyms"
    },
    "definitions": {
      "zero": "Definitions",
      "many": "Definitions",
      "other": "Definitions",
      "one": "Definition"
    },
    "antonyms": {
      "zero": "Antonyms",
      "many": "Antonyms",
      "other": "Antonyms",
      "one": "Antonym"
    }
  },
  "setting": {
    "general": "General",
    "others": "Others",
    "danger_zone": "Danger zone",
    "language": "Language",
    "theme_mode": "Theme mode",
    "turn_on_notification": "Turn on notifications",
    "rate_app": "Rate app",
    "check_for_update": "Check for update",
    "privacy_policy": "Privacy & policy",
    "about_us": "About us",
    "delete_acc": "Delete account",
    "theme_system": "System",
    "theme_light": "Light",
    "theme_dark": "Dark",
    "noti_permission_not_allow": "Please allow notification permission to use this feature.",
    "time_to_learn_notification": "Hey! It's time to learn something new.",
    "new_word_today": "New word today: {}.\\nDefinition: {}",
    "remind_at": "Remind at: {}",
    "notification_set_to": "Notification will show at {} every day.",
    "cancel_all_noti": "Canceled all notifications."
  },
  "favourite": {
    "add_to_favourite": "Added \"{}\" into your favourite list.",
    "remove_from_favourite": "Removed \"{}\" from your favourite list.",
    "favourites": "Favourites",
    "clear_all_favourites": "Are you sure you want to clear all your favourite word list.",
    "clear_all_fav_title": "Clear all favourite words",
    "clear_all": "Clear all favourites",
    "sync_data": "Sync data",
    "sync_data_success": "Data sync successfully"
  }
};
static const Map<String,dynamic> vi_VN = {
  "app_language": {
    "english": "Tiếng Anh",
    "vietnamese": "Tiếng Việt"
  },
  "app_log": {
    "on_restart": "Mừng bạn quay lại!"
  },
  "auth": {
    "already_have_an_account": "Bạn đã có tài khoản chưa?",
    "are_you_want_to_sign_out": "Bạn có chắc chắn muốn đăng xuất?",
    "confirm_password": "Xác nhận mật khẩu",
    "create_an_account": "Tạo một tài khoản",
    "enter_email": "Nhập email",
    "enter_password": "Nhập mật khẩu",
    "forgot_password": "Quên mật khẩu?",
    "invalid_email": "Email chỉ có thể chứa . - _ là ký tự đặc biệt",
    "invalid_password": "Mật khẩu phải bao gồm 8 ký tự và chữ số.",
    "or_sign_in_with": "Hoặc đăng nhập với:",
    "password_does_not_match": "Mật khẩu không khớp",
    "please_enter_and_password": "Hãy nhập email và mật khẩu!",
    "sign_in": "Đăng nhập",
    "sign_in_as_email": "Đăng nhập với {email}",
    "sign_out": "Đăng xuất",
    "sign_up": "Đăng ký",
    "welcome": "Chào mừng",
    "change_password": "Đổi mật khẩu",
    "enter_current_password": "Nhập mật khẩu hiện tại",
    "enter_new_password": "Nhập mật khẩu mới",
    "change_password_sub_title": "Hãy nhập thông tin mật khẩu của bạn bên dưới.",
    "change_password_success": "Đổi mật khẩu thành công",
    "please_re_login": "Hãy đăng nhập lại để cập nhật những thay đổi.",
    "enter_new_pass_below": "Nhập mật khẩu mới của bạn bên dưới.",
    "we_sent_verfication_code_to_email": "Chúng tôi vừa gửi bạn một mã xác nhận vào email của bạn: {}",
    "enter_verification_code": "Nhập mã xác nhận",
    "enter_email_to_reset_password": "Nhập địa chỉ email của bạn bên dưới, chúng tôi sẽ gửi bạn một mã xác minh để đặt lại mật khẩu."
  },
  "common": {
    "accept": "Đồng ý",
    "browse": "Duyệt",
    "cancel": "Huỷ",
    "close": "Đóng",
    "done": "Xong",
    "error": "Lỗi",
    "is_copied_to_clipboard": "'{word}' đã sao chép vào bộ nhớ tạm.",
    "next": "Tiếp tục",
    "okay": "Đồng ý",
    "other_k": "Khác",
    "retry": "Thử lại",
    "save": "Lưu",
    "select": "Chọn",
    "skip": "Huỷ"
  },
  "on_board": {
    "get_started": "Bắt đầu",
    "onboard_body": "Chúng tôi sẽ giúp bạn học từ vựng tiếng Anh mỗi ngày. Tin tôi đi, nó sẽ rất vui đấy!",
    "onboard_title": "Học nào!",
    "select_language": "Chọn ngôn ngữ",
    "select_language_content": "Đừng lo! Bạn có thể thay đổi nó sau trong phần Cài đặt."
  },
  "page": {
    "activity": "Hoạt động",
    "home": "Trang chủ",
    "profile": "Hồ sơ",
    "search": "Tìm kiếm",
    "setting": "Cài đặt",
    "favourite": "Yêu thích"
  },
  "profile": {
    "birthday": "Sinh nhật",
    "completion_progress": "Tiến độ hoàn thành",
    "created_date": "Ngày tạo",
    "display_name": "Tên hiển thị",
    "edit_profile": "Chỉnh sửa hồ sơ",
    "enter_display_name": "Nhập tên hiển thị",
    "enter_phone_number": "Nhập số điện thoại của bạn",
    "gender": "Giới tính",
    "no_info": "Không có thông tin",
    "personal_info": "Thông tin cá nhân",
    "phone": "Số điện thoại",
    "profile_title": "Hồ sơ của tôi",
    "update_success": "Cập nhật thành công",
    "invalid_phone_number": "Số điện thoại không hợp lệ.",
    "no_empty_display_name": "Tên hiển thị không được để trống.",
    "everything_is_up_to_date": "Mọi thứ đều được cập nhật.",
    "no_file_selected": "Không có tập tin nào được chọn.",
    "file_size_less_than": "Kích thước tập tin không được vượt quá {}MB.",
    "attendance": "Điểm danh"
  },
  "search": {
    "are_you_looking_for": "Có phải bạn đang tìm?",
    "not_found": "Không tìm thấy",
    "search_for_words": "Tìm từ vựng",
    "type_something": "Nhập gì đó",
    "show_more": "Hiển thị thêm"
  },
  "user_data": {
    "point": {
      "many": "{} điểm",
      "one": "1 điểm",
      "other": "{} điểm",
      "zero": "0 điểm"
    }
  },
  "utils": {
    "check_your_internet_connection": "Kiểm tra kết nối mạng của bạn",
    "no_internet_connection": "Không có kết nối mạng",
    "you_back_online": "Hú hú! Đã có kết nối mạng."
  },
  "home": {
    "tab_points": "Điểm",
    "tab_attendances": "Điểm danh",
    "day": {
      "many": "{} ngày",
      "one": "1 ngày",
      "other": "{} ngày",
      "zero": "0 ngày"
    },
    "general": "Chung",
    "every_day_new_word": "Mỗi ngày một từ mới",
    "leaderboard": "Bảng xếp hạng",
    "check_in": "Điểm danh",
    "this_week": "Tuần này",
    "this_month": "Tháng này",
    "time": {
      "zero": "0 lần",
      "one": "1 lần",
      "other": "{} lần",
      "many": "{} lần"
    },
    "learn_more": "Học thêm",
    "check_in_success": "Ye! Điểm danh thành công."
  },
  "word_detail": {
    "examples": {
      "zero": "Ví dụ",
      "one": "Ví dụ",
      "many": "Ví dụ",
      "other": "Ví dụ"
    },
    "synonyms": {
      "zero": "Đồng nghĩa",
      "one": "Đồng nghĩa",
      "many": "Đồng nghĩa",
      "other": "Đồng nghĩa"
    },
    "definitions": {
      "zero": "Định nghĩa",
      "many": "Định nghĩa",
      "other": "Định nghĩa",
      "one": "Định nghĩa"
    },
    "antonyms": {
      "zero": "Trái nghĩa",
      "many": "Trái nghĩa",
      "other": "Trái nghĩa",
      "one": "Trái nghĩa"
    }
  },
  "setting": {
    "general": "Chung",
    "others": "Khác",
    "danger_zone": "Vùng nguy hiểm",
    "language": "Ngôn ngữ",
    "theme_mode": "Chế độ chủ đề",
    "turn_on_notification": "Bật thông báo",
    "rate_app": "Đánh giá ứng dụng",
    "check_for_update": "Kiểm tra cập nhật",
    "privacy_policy": "Quyền riêng tư & chính sách",
    "about_us": "Về chúng tôi",
    "delete_acc": "Xoá tài khoản",
    "theme_system": "Hệ thống",
    "theme_light": "Sáng",
    "theme_dark": "Tối",
    "noti_permission_not_allow": "Hãy cho phép quyền gửi thông báo để sử dụng tính năng này.",
    "time_to_learn_notification": "Này! Đến lúc học gì đó mới rồi.",
    "new_word_today": "Từ mới hôm nay: {}.\\nĐịnh nghĩa: {}",
    "remind_at": "Nhắc nhở lúc: {}",
    "notification_set_to": "Thông báo sẽ hiển thị lúc {} mỗi ngày.",
    "cancel_all_noti": "Huỷ tất cả thông báo."
  },
  "favourite": {
    "add_to_favourite": "Đã thêm \"{}\" vào danh sách yêu thích của bạn.",
    "remove_from_favourite": "Đã xoá \"{}\" khỏi danh sách yêu thích của bạn.",
    "favourites": "Yêu thích",
    "clear_all_favourites": "Bạn có chắc muốn xoá tất cả từ vựng yêu thích.",
    "clear_all_fav_title": "Xoá tất cả yêu thích",
    "clear_all": "Xoá tất cả yêu thích",
    "sync_data": "Đồng bộ dữ liệu",
    "sync_data_success": "Dữ liệu đồng bộ thành công"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_US": en_US, "vi_VN": vi_VN};
}
