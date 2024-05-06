part of 'family_filter_cubit.dart';

@immutable
sealed class FamilyFilterState {}

final class FamilyFilterInitial extends FamilyFilterState {}
final class FamilyFilterLoading extends FamilyFilterState {}
final class FamilyFilterSuccess extends FamilyFilterState {}
final class FamilyFilterFail extends FamilyFilterState {}
