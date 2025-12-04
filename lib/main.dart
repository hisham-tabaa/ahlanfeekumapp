import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'firebase_options.dart';
import 'core/utils/responsive_utils.dart';
import 'core/utils/web_scroll_behavior.dart';
import 'core/utils/web_error_handler.dart';
import 'core/services/fcm_service.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/di/injection.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/error_handler.dart';
import 'core/network/dio_factory.dart';
import 'theming/app_theme.dart';
import 'features/auth/presentation/pages/initial_splash_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/search/presentation/bloc/search_event.dart';
import 'features/search/presentation/pages/search_screen.dart';
import 'features/search/presentation/pages/search_results_screen.dart';
import 'features/search/presentation/pages/filter_screen.dart';
import 'features/search/data/models/search_filter.dart';
import 'features/rent_create/presentation/pages/rent_create_flow_screen.dart';
import 'features/rent_create/presentation/bloc/rent_create_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/navigation/presentation/pages/main_navigation_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/property_detail/presentation/pages/property_detail_screen.dart';
import 'features/property_detail/presentation/bloc/property_detail_bloc.dart';
import 'features/property_detail/presentation/bloc/property_detail_event.dart';
import 'features/payments_summary/presentation/pages/payment_summary_screen.dart';
import 'features/payments_summary/presentation/bloc/payment_summary_bloc.dart';
import 'core/services/performance_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize FCM (only on mobile platforms)
    if (!kIsWeb) {
      await FCMService.initialize();
    }

    // Initialize Stripe
    Stripe.publishableKey = AppConstants.stripePublishableKey;
    await Stripe.instance.applySettings();

    // Set up web error handling
    if (kIsWeb) {
      FlutterError.onError = (FlutterErrorDetails details) {
        WebErrorHandler.handleWebError(details.exception, details.stack);
      };
    }

    // Enable edge-to-edge mode and handle system UI properly (mobile only)
    if (!kIsWeb) {
      try {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
          ),
        );
      } catch (e) {
      }
    }

    // Initialize EasyLocalization
    await EasyLocalization.ensureInitialized();

    // Initialize dependencies
    await initializeDependencies();

    // Initialize performance optimizations
    await PerformanceService.initialize();

    // Clear any invalid authentication tokens
    await _clearInvalidTokens();

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );
  } catch (e) {
    // Still try to run the app with a minimal error widget
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'App Initialization Error',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Helper function to clear invalid authentication tokens
Future<void> _clearInvalidTokens() async {
  try {
    final authLocalDataSource = getIt<AuthLocalDataSource>();
    await authLocalDataSource.clearInvalidTokens();
  } catch (e) {
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthBloc _authBloc;
  
  @override
  void initState() {
    super.initState();
    _authBloc = getIt<AuthBloc>();
    
    // Listen to authentication errors from DioFactory
    DioFactory.authErrorStream.listen((hasError) {
      if (hasError) {
        _authBloc.add(const LogoutEvent());
      }
    });
  }
  
  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
      ],
      child: kIsWeb
          ? _buildMaterialApp(context)
          : ScreenUtilInit(
              designSize: const Size(375, 812), // iPhone 12 Pro design size
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) => _buildMaterialApp(context),
            ),
    );
  }

  Widget _buildMaterialApp(BuildContext context) {
    return MaterialApp(
      title: 'Ahlan Feekum',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/',
      navigatorKey:
          ErrorHandler.navigatorKey, // Global navigator key for 401 handling
      onGenerateRoute: AppRouter.onGenerateRoute,
      scrollBehavior: WebScrollBehavior(),
      builder: (context, widget) {
        return ResponsiveWrapper(child: widget ?? const SizedBox());
      },
    );
  }
}

class RoleProtectedRentCreateScreen extends StatelessWidget {
  const RoleProtectedRentCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Check if user has permission to create rent (roleId 1 for host or 0 for admin)
        if (authState is AuthAuthenticated) {
          final roleId = authState.user.roleId;
          final canCreateRent = roleId == 1 || roleId == 0;

          if (canCreateRent) {
            return const RentCreateFlowScreen();
          } else {
            // User doesn't have permission, show access denied screen
            return Scaffold(
              appBar: AppBar(
                title: const Text('Access Denied'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.spacing(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 32,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: ResponsiveUtils.fontSize(
                          context,
                          mobile: 80,
                          tablet: 96,
                          desktop: 120,
                        ),
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 24,
                          tablet: 32,
                          desktop: 40,
                        ),
                      ),
                      Text(
                        'Access Denied',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 24,
                            tablet: 28,
                            desktop: 32,
                          ),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 16,
                          tablet: 20,
                          desktop: 24,
                        ),
                      ),
                      Text(
                        'You don\'t have permission to create rent listings. Only hosts and administrators can access this feature.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(
                            context,
                            mobile: 16,
                            tablet: 18,
                            desktop: 20,
                          ),
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(
                          context,
                          mobile: 32,
                          tablet: 40,
                          desktop: 48,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveUtils.spacing(
                              context,
                              mobile: 32,
                              tablet: 40,
                              desktop: 48,
                            ),
                            vertical: ResponsiveUtils.spacing(
                              context,
                              mobile: 12,
                              tablet: 16,
                              desktop: 20,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.radius(
                                context,
                                mobile: 8,
                                tablet: 10,
                                desktop: 12,
                              ),
                            ),
                          ),
                        ),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          // User is not authenticated, redirect to login
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveUtils.spacing(
                    context,
                    mobile: 20,
                    tablet: 24,
                    desktop: 32,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.login,
                      size: ResponsiveUtils.fontSize(
                        context,
                        mobile: 80,
                        tablet: 96,
                        desktop: 120,
                      ),
                      color: Colors.grey[400],
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 24,
                        tablet: 32,
                        desktop: 40,
                      ),
                    ),
                    Text(
                      'Authentication Required',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 16,
                        tablet: 20,
                        desktop: 24,
                      ),
                    ),
                    Text(
                      'Please log in to access this feature.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(
                          context,
                          mobile: 16,
                          tablet: 18,
                          desktop: 20,
                        ),
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.spacing(
                        context,
                        mobile: 32,
                        tablet: 40,
                        desktop: 48,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.spacing(
                            context,
                            mobile: 32,
                            tablet: 40,
                            desktop: 48,
                          ),
                          vertical: ResponsiveUtils.spacing(
                            context,
                            mobile: 12,
                            tablet: 16,
                            desktop: 20,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ResponsiveUtils.radius(
                              context,
                              mobile: 8,
                              tablet: 10,
                              desktop: 12,
                            ),
                          ),
                        ),
                      ),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (kDebugMode) {
      debugPrint('🔧 Navigating to: ${settings.name}');
      debugPrint('🔧 Route arguments: ${settings.arguments}');
    }

    switch (settings.name) {
      case '/search':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SearchBloc>(),
            child: const SearchScreen(),
          ),
        );

      case '/search-results':
        return MaterialPageRoute(
          settings: settings, // Pass settings to make arguments available
          builder: (context) => BlocProvider.value(
            value: getIt<SearchBloc>(),
            child: const SearchResultsScreen(),
          ),
        );

      case '/filter':
        final currentFilter = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SearchBloc>(),
            child: FilterScreen(
              currentFilter: currentFilter?['filter'] ?? const SearchFilter(),
            ),
          ),
        );

      case '/rent-create':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<RentCreateBloc>()),
              BlocProvider.value(
                value: getIt<SearchBloc>()..add(const LoadLookupsEvent()),
              ),
              BlocProvider.value(value: getIt<AuthBloc>()),
            ],
            child: const RoleProtectedRentCreateScreen(),
          ),
        );

      case '/main-navigation':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<HomeBloc>()..add(const LoadHomeDataEvent()),
              ),
              BlocProvider(create: (_) => getIt<SearchBloc>()),
              BlocProvider.value(value: getIt<AuthBloc>()),
            ],
            child: const MainNavigationScreen(),
          ),
        );

      case '/guest-navigation':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) =>
                    getIt<HomeBloc>()..add(const LoadHomeDataEvent()),
              ),
              BlocProvider(create: (_) => getIt<SearchBloc>()),
              BlocProvider.value(value: getIt<AuthBloc>()),
            ],
            child: const MainNavigationScreen(),
          ),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => getIt<HomeBloc>()..add(const LoadHomeDataEvent()),
            child: const HomeScreen(),
          ),
        );

      case '/payment-summary':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => getIt<PaymentSummaryBloc>(),
            child: const PaymentSummaryScreen(),
          ),
        );

      case '/property-detail':
        final propertyId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                getIt<PropertyDetailBloc>()
                  ..add(LoadPropertyDetailEvent(propertyId ?? '')),
            child: const PropertyDetailScreen(),
          ),
        );

      case '/':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<AuthBloc>(),
            child: const InitialSplashScreen(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<AuthBloc>(),
            child: const InitialSplashScreen(),
          ),
        );
    }
  }
}

// Responsive wrapper - now allows full width on web
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final bool allowFullWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth,
    this.allowFullWidth = true, // Default to full width
  });

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child; // No wrapping on mobile
    }

    // If full width is allowed, return child without constraints
    if (allowFullWidth && maxWidth == null) {
      return child;
    }

    // Determine max width based on screen size if not specified
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveMaxWidth = maxWidth ?? _getDefaultMaxWidth(screenWidth);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: child,
      ),
    );
  }

  double _getDefaultMaxWidth(double screenWidth) {
    if (screenWidth >= 1600) {
      return 1200; // Large desktop
    } else if (screenWidth >= 1200) {
      return 1000; // Desktop
    } else if (screenWidth >= 900) {
      return 800; // Tablet landscape
    } else {
      return 600; // Tablet portrait and mobile
    }
  }
}
