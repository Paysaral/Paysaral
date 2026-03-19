class Validators {

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) return 'Only letters allowed';
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile number is required';
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value.trim())) return 'Enter valid 10-digit mobile number';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) return 'Enter valid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) return 'Must contain at least 1 number';
    if (!RegExp(r'(?=.*[!@#$%^&*])').hasMatch(value)) return 'Must contain at least 1 special character';
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) return 'Must contain at least 1 uppercase letter';
    return null;
  }

  static String? validatePAN(String? value) {
    if (value == null || value.trim().isEmpty) return 'PAN number is required';
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value.trim().toUpperCase())) {
      return 'Enter valid PAN (eg. ABCDE1234F)';
    }
    return null;
  }

  static String? validateAadhaar(String? value) {
    final clean = value?.replaceAll('-', '') ?? '';
    if (clean.isEmpty) return 'Aadhaar number is required';
    if (!RegExp(r'^[2-9]{1}[0-9]{11}$').hasMatch(clean)) return 'Enter valid 12-digit Aadhaar number';
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}
