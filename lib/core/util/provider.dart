import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../screens/Auth/view_model/auth_provider.dart';
import '../../screens/add_feeds_view/view_model/add_feeds_provider.dart';
import '../../screens/home/view_model/home_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => HomeProvider()),
  ChangeNotifierProvider(create: (_) => AddFeedsProvider()),

  //RegisterProvider
];
