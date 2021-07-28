import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'modules/home/home_module.dart';

// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ModularApp(module: AppModule()));
}

class AppModule extends MainModule {

  @override
  List<Bind> get binds => [
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter('/', module: HomeModule(), transition: TransitionType.fadeIn,),
  ];

  @override
  Widget get bootstrap => AppWidget();
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
      navigatorObservers: [routeObserver],
    );
  }
}
