import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:m2/services/api_services/api_services.dart';
import 'package:m2/services/state_management/token/token.dart';
import 'package:m2/utilities/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2/services/route_services.dart' as routes;

void main() async {
  await initHiveForFlutter();
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, this.signIn = false}) : super(key: key);
  final bool signIn;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? key = sharedPreferences.getString('key');
    final authToken = Provider.of<AuthToken>(context);
    if (key != null) {
      authToken.putLoginToken(key);
    }
    ;
  }

  @override
  void initState() {
    // getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<AuthToken>(
      create: (context) => AuthToken(),
      builder: (context, child) {
        final loginToken = Provider.of<AuthToken>(context);

        Link link;
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
        );
      },
    );
  }
}
