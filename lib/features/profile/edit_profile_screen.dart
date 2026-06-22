// lib/features/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';
import 'package:krishix/core/constants/app_spacing.dart';
import 'package:krishix/core/services/user_auth_service.dart';
import 'package:krishix/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color _kOrange = Color(0xFFFF6B00);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.initialName = '',
    this.initialPhone = '',
    this.onSaved,
  });

  final String initialName;
  final String initialPhone;
  final void Function(String name, String phone)? onSaved;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _formKey  = GlobalKey<FormState>();
  bool _isSaving  = false;

  @override
  void initState() {
    super.initState();
    _nameController  = TextEditingController(text: widget.initialName);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final name  = _nameController.text.trim();
      final phone = UserAuthService.normalizePhone(_phoneController.text);
      final oldSessionPhone =
          UserAuthService.normalizePhone(await UserAuthService.getLoggedInPhone() ?? '');
      final prefs = await SharedPreferences.getInstance();
      final oldSavedPhone =
          UserAuthService.normalizePhone(prefs.getString('user_phone') ?? '');
      final previousPhone = oldSavedPhone.isNotEmpty
          ? oldSavedPhone
          : oldSessionPhone;

      await prefs.setString('user_name',  name);
      await prefs.setString('user_phone', phone);
      if (previousPhone.isNotEmpty && previousPhone != phone) {
        await prefs.setString('user_previous_phone', previousPhone);
      }
      await UserAuthService.registerUser(phone: phone, fullName: name);
      await UserAuthService.saveSession(phone);

      widget.onSaved?.call(name, phone);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully!'),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.editProfile,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Orange gradient banner ────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end:   Alignment.bottomRight,
                    colors: [_kOrange, Color(0xFFFFB347)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color:        Colors.white.withOpacity(0.22),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size:  28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Profile',
                            style: TextStyle(
                              color:      Colors.white,
                              fontSize:   16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Keep your details up to date for the best experience',
                            style: TextStyle(
                              color:    Colors.white,
                              fontSize: 12.5,
                              height:   1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Full Name ─────────────────────────────────
              const _FieldLabel(
                  label: 'Full Name',
                  icon:  Icons.person_outline),
              const SizedBox(height: 8),
              _Field(
                controller:     _nameController,
                hint:           'Enter your full name',
                capitalization: TextCapitalization.words,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name is required' : null,
              ),

              const SizedBox(height: 18),

              // ── Mobile Number ─────────────────────────────
              const _FieldLabel(
                  label: 'Mobile Number',
                  icon:  Icons.phone_iphone),
              const SizedBox(height: 8),
              _Field(
                controller:      _phoneController,
                hint:            '10-digit mobile number',
                prefixText:      '+91 ',
                keyboardType:    TextInputType.phone,
                maxLength:       10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => (v == null || v.trim().length != 10)
                    ? 'Enter a valid 10-digit number' : null,
              ),

              const SizedBox(height: 32),

              // ── Save button ───────────────────────────────
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:         _kOrange,
                    foregroundColor:         Colors.white,
                    disabledBackgroundColor: _kOrange.withOpacity(0.6),
                    elevation:   3,
                    shadowColor: _kOrange.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24, height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_rounded, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Save Profile',
                              style: TextStyle(
                                fontSize:   16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Note
              Center(
                child: Text(
                  'Your info is saved securely on this device.',
                  style: TextStyle(
                    fontSize: 13,
                    color:    Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Field label — identical to advertise_screen
// ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.icon});
  final String   label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _kOrange),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize:   14,
            fontWeight: FontWeight.w700,
            color:      Color(0xFF1A2E1A),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Reusable field — identical to advertise_screen (no prefix icon inside)
// ─────────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.prefixText,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.maxLength,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController      controller;
  final String                     hint;
  final String?                    prefixText;
  final TextInputType?             keyboardType;
  final TextCapitalization         capitalization;
  final int?                       maxLength;
  final List<TextInputFormatter>?  inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:         controller,
      keyboardType:       keyboardType,
      textCapitalization: capitalization,
      maxLength:          maxLength,
      inputFormatters:    inputFormatters,
      decoration: InputDecoration(
        hintText:    hint,
        hintStyle:   TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixText:  prefixText,
        prefixStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          color:      Color(0xFF1A2E1A),
        ),
        filled:         true,
        fillColor:      Colors.white,
        counterText:    '',
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: _kOrange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
