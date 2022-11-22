import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'custom_bottom_navigation_state.dart';

class CustomBottomNavigationCubit
    extends HydratedCubit<CustomBottomNavigationState> {
  CustomBottomNavigationCubit() : super(const CustomBottomNavigationState());

  void updateSelectedTabIndex(int selectedTabIndex) =>
      emit(state.copyWith(selectedTabIndex: selectedTabIndex));

  @override
  CustomBottomNavigationState fromJson(Map<String, dynamic> json) =>
      CustomBottomNavigationState.fromJson(json);

  @override
  Map<String, dynamic> toJson(CustomBottomNavigationState state) =>
      state.toJson();
}
