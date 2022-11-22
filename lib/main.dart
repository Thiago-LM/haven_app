import 'package:haven_app/bootstrap.dart';
import 'package:haven_app/haven_app.dart';
import 'package:haven_app/wallhaven/wallhaven.dart';

void main() =>
    bootstrap(() => HavenApp(wallhavenRepository: WallhavenRepository()));
