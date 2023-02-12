import 'dart:math';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/state_management/cart/cart_data.dart';
import 'package:m2/services/state_management/categories/categories_data.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2/services/route_services.dart' as routes;

void main() async {
  await initHiveForFlutter();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(providers: [
      Provider<AuthToken>(create: (context) => AuthToken()),
      Provider<CartData>(create: (context) => CartData()),
      Provider<CategoriesData>(create: (context) => CategoriesData()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.signIn = false}) : super(key: key);
  final bool signIn;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getToken(AuthToken authToken, CartData cartData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? key = sharedPreferences.getString('key');
    String? cart = sharedPreferences.getString('cartId');

    // final authToken = Provider.of<AuthToken>(context);
    if (key != null) {
      authToken.putLoginToken(key);
    }
    if (cart != null) {
      cartData.putCartId(cart);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      Link link;
      final loginToken = Provider.of<AuthToken>(context);
      final cartData = Provider.of<CartData>(context);
      getToken(loginToken, cartData);

      final HttpLink httpLink = HttpLink(ApiServices.path, defaultHeaders: {'Content-Type': 'application/json'});

      // print('My app: ${loginToken.loginToken}');
      if (loginToken.loginToken != null) {
        print('auth key initiated');
        final AuthLink authLink = AuthLink(
          getToken: () => 'Bearer ${loginToken.loginToken}',
        );
        link = authLink.concat(httpLink);
      } else {
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
              primarySwatch: AppColors.primaryColor,
              drawerTheme: DrawerThemeData(scrimColor: AppColors.fadedText),
              scaffoldBackgroundColor: AppColors.scaffoldColor,
            ),
            routerConfig: routes.router,

            // home: signIn ? const Auth() : const Wrapper(),
          ),
        ),
      );
    });
  }
}
