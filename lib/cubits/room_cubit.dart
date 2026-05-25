import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/room_state.dart';
import 'package:mobile_labs/repositories/room_repository.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository _roomRepository;

  RoomCubit(this._roomRepository)
      : super(const RoomInitial());

  Future<void> loadRooms() async {
    emit(const RoomLoading());
    try {
      final rooms = await _roomRepository.getRooms();
      emit(RoomLoaded(rooms));
    } on Exception catch (e) {
      emit(RoomError(e.toString()));
    }
  }
}
