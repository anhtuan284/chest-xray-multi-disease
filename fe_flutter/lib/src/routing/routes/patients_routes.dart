import 'package:go_router/go_router.dart';

import '../../features/patients/presentation/patients_screen.dart';
import '../route_paths.dart';

List<RouteBase> patientRoutes = [
  GoRoute(
    path: RoutePaths.patients,
    builder: (context, state) => const PatientsScreen(),
  ),
];
