import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../screens/Auth/view_model/auth_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  // ChangeNotifierProvider(create: (_) => HomeProvider()),
  // ChangeNotifierProvider(create: (_) => RegisterProvider()),

  //RegisterProvider
];
