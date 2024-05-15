import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sudia_events/data/model/services_model.dart';
import 'package:sudia_events/data/services/fetch_data.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit() : super(ServicesInitial());
  List<ServicesModel>? servicesModel;
  Future<void> getServicesCubitfun() async {
    emit(ServicesLoading());
    try {
      servicesModel = await fetchServicesData();
      emit(ServicesSuccess());
    } catch (e) {
      print("error in services cubit ${e.toString()}");
      emit(ServicesFail());
    }
  }
}
