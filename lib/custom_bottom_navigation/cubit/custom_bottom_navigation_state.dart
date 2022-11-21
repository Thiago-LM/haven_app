part of 'custom_bottom_navigation_cubit.dart';

class CustomBottomNavigationState extends Equatable {
  const CustomBottomNavigationState({this.selectedTabIndex = 0});

  factory CustomBottomNavigationState.fromJson(Map<String, dynamic> json) =>
      CustomBottomNavigationState(
        selectedTabIndex: (json['selectedTabIndex'] ?? 0) as int,
      );

  final int selectedTabIndex;

  CustomBottomNavigationState copyWith({int? selectedTabIndex}) {
    return CustomBottomNavigationState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  Map<String, dynamic> toJson() => {
        'selectedTabIndex': selectedTabIndex,
      };

  @override
  List<Object?> get props => [selectedTabIndex];
}
