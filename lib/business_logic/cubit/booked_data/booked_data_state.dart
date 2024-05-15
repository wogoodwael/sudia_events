part of 'booked_data_cubit.dart';

@immutable
sealed class BookedDataState {}

final class BookedDataInitial extends BookedDataState {}
final class BookedDataLoading extends BookedDataState {}
final class BookedDataSuccess extends BookedDataState {}
final class BookedDataFail extends BookedDataState {}
