import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/room_state.dart';
import 'package:mobile_labs/repositories/room_repository.dart';
import 'package:mobile_labs/services/connectivity_service.dart';

class RoomCubit extends Cubit<RoomState> {
  final RoomRepository _roomRepository;
  final ConnectivityService _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectSub;
  String? _lastToken;
  bool _wasOffline = false;

  RoomCubit(this._roomRepository, this._connectivity)
    : super(const RoomInitial());

  Future<void> loadRooms(String token) async {
    _lastToken = token;
    emit(const RoomLoading());
    try {
      final rooms = await _roomRepository.getRooms(token);
      emit(RoomLoaded(rooms));
    } on Exception catch (e) {
      emit(RoomError(e.toString()));
    }
  }

  Future<void> watchConnectivity() async {
    if (!await _connectivity.hasConnection()) {
      _wasOffline = true;
    }
    _connectSub = _connectivity.onConnectivityChanged.listen((results) {
      final off = results.contains(ConnectivityResult.none);
      if (!off && _wasOffline && _lastToken != null) {
        _wasOffline = false;
        loadRooms(_lastToken!);
      } else if (off) {
        _wasOffline = true;
      }
    });
  }

  @override
  Future<void> close() {
    _connectSub?.cancel();
    return super.close();
  }
}
