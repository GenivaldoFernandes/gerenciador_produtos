import 'package:flutter_modular/flutter_modular.dart';

import 'bloC/home_bloc.dart';
import 'views/home.dart';

class HomeModule extends ChildModule{

  @override
  List<Bind> get binds => [
    Bind((_) => HomeBloc()),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter('/', child: (_, __) => Home()),
  ];
}