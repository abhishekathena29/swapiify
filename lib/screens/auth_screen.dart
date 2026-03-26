import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  String? _errorMessage;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider auth) async {
    final navigator = Navigator.of(context);
    final error = await auth.login(
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _errorMessage = error);
    if (error == null) {
      navigator.pushReplacementNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return _AuthScaffold(
      eyebrow: 'Welcome back',
      title: 'Trade better, with less noise.',
      subtitle:
          'Sign in to continue browsing curated swaps, saved items, and live conversations.',
      sideNote:
          'Minimal listing flow. Cleaner conversations. Better local matches.',
      footer: TextButton(
        onPressed: () =>
            Navigator.pushReplacementNamed(context, RouteNames.signup),
        child: const Text(
          'Need an account? Create one',
          style: TextStyle(color: AppColors.coralDark),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null) ...[
            _InlineError(message: _errorMessage!),
            const SizedBox(height: 16),
          ],
          _FieldLabel(label: 'Email'),
          const SizedBox(height: 8),
          AppInput(
            controller: _email,
            hintText: 'you@example.com',
            prefixIcon: const Icon(Icons.mail_outline_rounded),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _FieldLabel(label: 'Password'),
          const SizedBox(height: 8),
          AppInput(
            controller: _password,
            hintText: '••••••••',
            obscureText: !_showPassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _showPassword = !_showPassword),
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: AppColors.mutedForeground),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: auth.isLoading ? 'Signing in...' : 'Sign in',
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            onPressed: auth.isLoading ? null : () => _submit(auth),
            size: AppButtonSize.xl,
            fullWidth: true,
          ),
          const SizedBox(height: 18),
          const _AuthDivider(),
          const SizedBox(height: 18),
          const _SocialRow(),
        ],
      ),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _showPassword = false;
  String? _errorMessage;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider auth) async {
    final navigator = Navigator.of(context);
    final error = await auth.signup(
      name: _name.text,
      email: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _errorMessage = error);
    if (error == null) {
      navigator.pushReplacementNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return _AuthScaffold(
      eyebrow: 'Join Swapiify',
      title: 'Build a profile that makes swapping feel trustworthy.',
      subtitle:
          'Create your account to list items, manage offers, and message other swappers with confidence.',
      sideNote:
          'Profiles, ratings, and clear item expectations keep swaps grounded.',
      footer: TextButton(
        onPressed: () =>
            Navigator.pushReplacementNamed(context, RouteNames.login),
        child: const Text(
          'Already have an account? Sign in',
          style: TextStyle(color: AppColors.coralDark),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_errorMessage != null) ...[
            _InlineError(message: _errorMessage!),
            const SizedBox(height: 16),
          ],
          _FieldLabel(label: 'Full name'),
          const SizedBox(height: 8),
          AppInput(
            controller: _name,
            hintText: 'Jordan Ellis',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          _FieldLabel(label: 'Email'),
          const SizedBox(height: 8),
          AppInput(
            controller: _email,
            hintText: 'you@example.com',
            prefixIcon: const Icon(Icons.mail_outline_rounded),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _FieldLabel(label: 'Password'),
          const SizedBox(height: 8),
          AppInput(
            controller: _password,
            hintText: 'At least 8 characters',
            obscureText: !_showPassword,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _showPassword = !_showPassword),
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
              ),
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontSize: 12,
                height: 1.45,
              ),
              children: [
                TextSpan(text: 'By creating an account, you agree to the '),
                TextSpan(
                  text: 'Terms',
                  style: TextStyle(
                    color: AppColors.coralDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.coralDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppButton(
            label: auth.isLoading ? 'Creating account...' : 'Create account',
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            onPressed: auth.isLoading ? null : () => _submit(auth),
            size: AppButtonSize.xl,
            fullWidth: true,
          ),
          const SizedBox(height: 18),
          const _AuthDivider(),
          const SizedBox(height: 18),
          const _SocialRow(),
        ],
      ),
    );
  }
}

class _AuthScaffold extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final String sideNote;
  final Widget child;
  final Widget footer;

  const _AuthScaffold({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.sideNote,
    required this.child,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: wide
                      ? Row(
                          children: [
                            Expanded(
                              child: _AuthIntro(
                                eyebrow: eyebrow,
                                title: title,
                                subtitle: subtitle,
                                sideNote: sideNote,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _AuthCard(footer: footer, child: child),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _AuthIntro(
                              eyebrow: eyebrow,
                              title: title,
                              subtitle: subtitle,
                              sideNote: sideNote,
                            ),
                            const SizedBox(height: 20),
                            _AuthCard(footer: footer, child: child),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AuthIntro extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final String sideNote;

  const _AuthIntro({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.sideNote,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.card.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.coralDark,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'swapiify',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'Playfair Display',
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        AppSectionHeading(eyebrow: eyebrow, title: title, subtitle: subtitle),
        const SizedBox(height: 24),
        AppPanel(
          color: AppColors.plumDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Curated swapping, rethought.',
                style: TextStyle(
                  color: AppColors.cream,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Playfair Display',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                sideNote,
                style: TextStyle(
                  color: AppColors.cream.withValues(alpha: 0.78),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MiniStat(label: 'Local-first'),
                  _MiniStat(label: 'Safer profiles'),
                  _MiniStat(label: 'Clearer chats'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthCard extends StatelessWidget {
  final Widget child;
  final Widget footer;

  const _AuthCard({required this.child, required this.footer});

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 14),
      child: Column(children: [child, const SizedBox(height: 8), footer]),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
    );
  }
}

class _InlineError extends StatelessWidget {
  final String message;

  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.destructive.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.destructive.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(color: AppColors.destructive, fontSize: 12),
      ),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: TextStyle(color: AppColors.mutedForeground, fontSize: 12),
          ),
        ),
        Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Google',
            icon: const Icon(Icons.g_mobiledata_rounded, size: 24),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, RouteNames.home),
            variant: AppButtonVariant.outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'Apple',
            icon: const Icon(Icons.apple_rounded, size: 18),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, RouteNames.home),
            variant: AppButtonVariant.outline,
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;

  const _MiniStat({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.cream.withValues(alpha: 0.9),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
