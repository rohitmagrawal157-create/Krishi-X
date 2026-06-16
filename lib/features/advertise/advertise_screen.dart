// lib/features/advertise/advertise_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:krishix/core/constants/app_colors.dart';

const Color _kOrange = Color(0xFFFF6B00);

class AdvertiseScreen extends StatefulWidget {
  const AdvertiseScreen({super.key});

  @override
  State<AdvertiseScreen> createState() => _AdvertiseScreenState();
}

class _AdvertiseScreenState extends State<AdvertiseScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtr    = TextEditingController();
  final _phoneCtr   = TextEditingController();
  final _emailCtr   = TextEditingController();
  final _companyCtr = TextEditingController();
  final _msgCtr     = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted    = false;

  @override
  void dispose() {
    _nameCtr.dispose();
    _phoneCtr.dispose();
    _emailCtr.dispose();
    _companyCtr.dispose();
    _msgCtr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    // TODO: send to backend / Firebase
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _submitted    = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Advertise with us',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _submitted
          ? _SuccessView()
          : _FormView(
              formKey:      _formKey,
              nameCtr:      _nameCtr,
              phoneCtr:     _phoneCtr,
              emailCtr:     _emailCtr,
              companyCtr:   _companyCtr,
              msgCtr:       _msgCtr,
              isSubmitting: _isSubmitting,
              onSubmit:     _submit,
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Form view
// ─────────────────────────────────────────────────────────────
class _FormView extends StatelessWidget {
  const _FormView({
    required this.formKey,
    required this.nameCtr,
    required this.phoneCtr,
    required this.emailCtr,
    required this.companyCtr,
    required this.msgCtr,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final GlobalKey<FormState>  formKey;
  final TextEditingController nameCtr;
  final TextEditingController phoneCtr;
  final TextEditingController emailCtr;
  final TextEditingController companyCtr;
  final TextEditingController msgCtr;
  final bool                  isSubmitting;
  final VoidCallback          onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── Banner ───────────────────────────────────
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
                      Icons.campaign_rounded,
                      size: 28, color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grow your business',
                          style: TextStyle(
                            color:      Colors.white,
                            fontSize:   16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Reach lakhs of farmers & rural buyers on KrishiX',
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

            // ── Full Name ────────────────────────────────
            const _FieldLabel(
                label: 'Full Name',
                icon:  Icons.person_outline),
            const SizedBox(height: 8),
            _Field(
              controller:     nameCtr,
              hint:           'Enter your full name',
              capitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Name is required' : null,
            ),

            const SizedBox(height: 18),

            // ── Mobile Number — fix: prefix widget not prefixText ──
            const _FieldLabel(
                label: 'Mobile Number',
                icon:  Icons.phone_iphone),
            const SizedBox(height: 8),
            TextFormField(
              controller:      phoneCtr,
              keyboardType:    TextInputType.phone,
              maxLength:       10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                // ── prefix widget = no gap ──────────────
                prefix: const Text(
                  '+91 ',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize:   16,
                    color:      Color(0xFF1A2E1A),
                  ),
                ),
                hintText:  '10-digit mobile number',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400, fontSize: 14),
                filled:         true,
                fillColor:      Colors.white,
                counterText:    '',
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: _kOrange, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.red, width: 2),
                ),
              ),
              validator: (v) => (v == null || v.trim().length != 10)
                  ? 'Enter a valid 10-digit number' : null,
            ),

            const SizedBox(height: 18),

            // ── Email ────────────────────────────────────
            const _FieldLabel(
                label: 'Email Address',
                icon:  Icons.email_outlined),
            const SizedBox(height: 8),
            _Field(
              controller:   emailCtr,
              hint:         'example@company.com',
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Email is required';
                }
                final re = RegExp(r'^[\w\.\-]+@[\w\-]+\.\w{2,}$');
                if (!re.hasMatch(v.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 18),

            // ── Company Name ─────────────────────────────
            const _FieldLabel(
                label: 'Company / Brand Name',
                icon:  Icons.business_outlined),
            const SizedBox(height: 8),
            _Field(
              controller:     companyCtr,
              hint:           'Your company or brand name',
              capitalization: TextCapitalization.words,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Company name is required' : null,
            ),

            const SizedBox(height: 18),

            // ── Message ──────────────────────────────────
            const _FieldLabel(
                label: 'Message / Ad Requirements',
                icon:  Icons.message_outlined),
            const SizedBox(height: 8),
            TextFormField(
              controller:   msgCtr,
              maxLines:     5,
              minLines:     4,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Describe your advertising needs, '
                    'target audience, budget, etc.',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400, fontSize: 14),
                filled:         true,
                fillColor:      Colors.white,
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: _kOrange, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.red, width: 2),
                ),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please describe your requirements' : null,
            ),

            const SizedBox(height: 28),

            // ── Submit button ────────────────────────────
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : onSubmit,
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
                child: isSubmitting
                    ? const SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Submit Enquiry',
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

            Center(
              child: Text(
                'Our team will contact you within 24 hours.',
                style: TextStyle(
                    fontSize: 13, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Success view
// ─────────────────────────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_kOrange, Color(0xFFFFB347)]),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:      _kOrange.withOpacity(0.35),
                    blurRadius: 20,
                    offset:     const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                  Icons.check_rounded, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'Enquiry Submitted!',
              style: TextStyle(
                fontSize:   24,
                fontWeight: FontWeight.w800,
                color:      Color(0xFF1A2E1A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Thank you for your interest in advertising with KrishiX. '
              'Our team will reach out to you within 24 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color:    Colors.grey.shade600,
                  height:   1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Field label
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
// Reusable field — no prefixText (phone handled separately)
// ─────────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.maxLength,
    this.inputFormatters,
    this.validator,
  });

  final TextEditingController      controller;
  final String                     hint;
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
        hintText:       hint,
        hintStyle:      TextStyle(
            color: Colors.grey.shade400, fontSize: 14),
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