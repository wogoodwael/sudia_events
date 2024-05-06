import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sudia_events/data/services/api.dart';

part 'family_filter_state.dart';

class FamilyFilterCubit extends Cubit<FamilyFilterState> {
  FamilyFilterCubit(this.api) : super(FamilyFilterInitial());
  Api api;
  List<Map<String, dynamic>>? familes;
  void loadFamilies(String familyName) async {
    emit(FamilyFilterLoading());

    try {
      // familes = await api.filterByFamily(familyName);
      emit(FamilyFilterSuccess());
    } catch (e) {
      emit(FamilyFilterFail());
    }
  }
}
