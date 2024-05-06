import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tribe_filter_state.dart';

class TribeFilterCubit extends Cubit<TribeFilterState> {
  TribeFilterCubit() : super(TribeFilterInitial());
}
