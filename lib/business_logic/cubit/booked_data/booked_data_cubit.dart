import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudia_events/data/services/fetch_data.dart';

import '../../../data/model/booked_services.dart';

part 'booked_data_state.dart';

class BookedDataCubit extends Cubit<BookedDataState> {
  BookedDataCubit() : super(BookedDataInitial());

  List<BookedServicesModel>? bookedServices;

  Future<void> getBookedDataCubitfun() async {
    emit(BookedDataLoading());
    try {
      bookedServices = await fetchBookedData();
      emit(BookedDataSuccess());
    } catch (e) {
      print("error in booked cubit ${e.toString()}");
      emit(BookedDataFail());
    }
  }
}
