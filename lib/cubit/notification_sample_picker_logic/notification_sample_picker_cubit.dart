// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:TrailApp/core/values/keys.dart';

part 'notification_sample_picker_state.dart';

class NotificationSamplePickerCubit
    extends Cubit<NotificationSamplePickerState> {
  final String sampleKey;

  NotificationSamplePickerCubit({
    required this.sampleKey,
  }) : super(NotificationSamplePickerState.inital());

  late final AudioPlayer _player;
  late final Box<String?> _notificationSampleBox;

  void init() async {
    _player = AudioPlayer();
    _notificationSampleBox =
        await Hive.openBox<String?>(kNotificationSampleBox);

    String? sampleName = _notificationSampleBox.get(sampleKey);
    int? selectedSampleIndex = _parseSampleIndex(sampleName);

    emit(
      state.copyWith(
        selectedSampleIndex: selectedSampleIndex,
      ),
    );
  }

  void changeSeletectedSampleIndex(int? selectedSampleIndex) {
    if (selectedSampleIndex != null) {
      _playSample(selectedSampleIndex);
    }

    emit(state.copyWith(selectedSampleIndex: selectedSampleIndex));
  }

  Future<void> saveSample() async {
    String? sampleName = _getSampleName();
    await _notificationSampleBox.put(sampleKey, sampleName);
  }

  void _playSample(int index) async {
    String url = 'android/app/src/main/res/raw/sample${index + 1}.wav';
    await _player.setAsset(url);
    _player.play();
    await saveSample();
  }

  String? _getSampleName() {
    if (state.selectedSampleIndex == null) {
      return null;
    }

    return state.sampleNames[state.selectedSampleIndex!];
  }

  int? _parseSampleIndex(String? sampleName) {
    if (sampleName == null) {
      return null;
    }

    return int.parse(sampleName.replaceFirst('sample', ''));
  }
}
