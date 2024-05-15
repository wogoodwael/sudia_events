import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sudia_events/data/model/booked_services.dart';
import 'package:sudia_events/data/services/fetch_data.dart';

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
