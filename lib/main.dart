import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/state_management/wishlist/wishlist_dart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/route_services.dart' as routes;

import 'services/api_services/api_services.dart';
import 'services/state_management/cache_clear/cache_manager.dart';
import 'services/state_management/cart/cart_data.dart';
import 'services/state_management/categories/categories_data.dart';
import 'services/state_management/home/home_data.dart';
import 'services/state_management/token/token.dart';
import 'services/state_management/user/user_data.dart';
import 'utilities/app_colors.dart';
import 'utilities/app_style.dart';

void main() async {
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  // To store token even when app closed
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? key = sharedPreferences.getString('token');
  String? cart = sharedPreferences.getString('cartId');

  runApp(
    MultiProvider(providers: [
      // Initializing state management models
      Provider<AuthToken>(create: (context) => AuthToken(key)),
      Provider<CartData>(create: (context) => CartData(cart)),
      Provider<CategoriesData>(create: (context) => CategoriesData()),
      Provider<HomeData>(create: (context) => HomeData()),
      Provider<UserData>(create: (context) => UserData()),
      Provider<CacheManager>(create: (context) => CacheManager()),
      Provider<WishlistData>(create: (context) => WishlistData()),
    ], child: MyApp(token: key, cartId: cart)),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.signIn = false, this.token, this.cartId});
  final bool signIn;
  final String? token;
  final String? cartId;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getToken() {
    final loginToken = Provider.of<AuthToken>(context, listen: false);
    final cartData = Provider.of<CartData>(context, listen: false);
    loginToken.putLoginToken(widget.token);
    cartData.putCartId(widget.cartId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getToken());
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Link link;
      final loginToken = Provider.of<AuthToken>(context);

      // Initialising graphql
      final HttpLink httpLink = HttpLink(ApiServices.path, defaultHeaders: {'Content-Type': 'application/json'});

      if (loginToken.loginToken != null) {
        print('auth key initiated');
        final AuthLink authLink = AuthLink(
          getToken: () => 'Bearer ${loginToken.loginToken}',
        );
        link = authLink.concat(httpLink);
      } else {
        print('no auth key');
        link = httpLink;
      }

      ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(
          link: link,
          cache: GraphQLCache(
            store: InMemoryStore(),
          ),
        ),
      );
      return GraphQLProvider(
        key: ValueKey<int>(Random(100).nextInt(50)),
        client: client,
        child: Portal(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'M Ecommerce',
            theme: ThemeData(
              // primarySwatch: AppColors.primaryColor,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
              drawerTheme: DrawerThemeData(scrimColor: AppColors.fadedText),
              scaffoldBackgroundColor: AppColors.scaffoldColor,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashFactory: NoSplash.splashFactory,
              tooltipTheme: TooltipThemeData(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.containerColor,
                  boxShadow: AppStyles.defaultShadow,
                ),
              ),
            ),
            routerConfig: routes.router,

            // home: signIn ? const Auth() : const Wrapper(),
          ),
        ),
      );
    });
  }
}
