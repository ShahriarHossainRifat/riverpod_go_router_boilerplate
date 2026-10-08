import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';
import 'package:riverpod_go_router_boilerplate/l10n/generated/app_localizations.dart';

/// Login page for user authentication.
///
/// Uses [HookConsumerWidget] to manage local form state via hooks,
/// avoiding the boilerplate of `ConsumerStatefulWidget` + `dispose`.
///
/// Navigation after login is handled automatically by the GoRouter redirect
/// guard in `appRouterProvider` — no explicit `context.go` call is needed.
class LoginPage extends HookConsumerWidget {
  /// Creates a [LoginPage] instance.
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    final theme = context.theme;
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    // Track screen view once on mount
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(analyticsServiceProvider).logScreenView(screenName: 'login');
      });
      return null;
    }, const []);

    // Show error snackbar when auth fails.
    // Navigation on success is handled by the GoRouter redirect guard —
    // watching authProvider causes the router to re-evaluate and redirect.
    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          if (context.mounted) {
            context.showErrorSnackBar(error.toString());
          }
        },
      );
    });

    Future<void> handleLogin() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      await ref
          .read(authProvider.notifier)
          .login(emailController.text.trim(), passwordController.text);
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusXXL,
                        ),
                      ),
                      child: Icon(
                        Icons.flutter_dash,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    // Title
                    Text(
                      l10n.welcomeBack,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace.sm(),
                    Text(
                      l10n.signInToContinue,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace.xl(),

                    // Email field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      validator: Validators.compose([
                        Validators.required(l10n.emailRequired),
                        Validators.email(l10n.emailInvalid),
                      ]),
                    ),
                    const VerticalSpace.md(),

                    // Password field
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword.value,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      autofillHints: const [AutofillHints.password],
                      onFieldSubmitted: (_) => handleLogin(),
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          tooltip: obscurePassword.value
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: () {
                            obscurePassword.value = !obscurePassword.value;
                          },
                        ),
                      ),
                      validator: Validators.compose([
                        Validators.required(l10n.passwordRequired),
                        Validators.strongPassword(l10n.passwordWeak),
                      ]),
                    ),
                    const VerticalSpace.lg(),

                    // Login button
                    AppButton(
                      size: AppButtonSize.large,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : handleLogin,
                      label: l10n.login,
                    ),
                    const VerticalSpace.md(),

                    // Forgot password
                    AppButton(
                      variant: AppButtonVariant.text,
                      onPressed: isLoading
                          ? null
                          : () {
                              // TODO(auth): Navigate to forgot password screen.
                            },
                      label: l10n.forgotPassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
