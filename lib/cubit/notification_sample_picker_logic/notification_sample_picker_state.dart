part of 'notification_sample_picker_cubit.dart';

class NotificationSamplePickerState {
  final List<String> sampleNames;
  final int? selectedSampleIndex;

  NotificationSamplePickerState({
    required this.sampleNames,
    this.selectedSampleIndex,
  });

  factory NotificationSamplePickerState.inital() =>
      NotificationSamplePickerState(
        sampleNames: List.generate(14, (index) => 'sample${index + 1}'),
      );

  NotificationSamplePickerState copyWith({
    List<String>? sampleNames,
    int? selectedSampleIndex,
  }) {
    return NotificationSamplePickerState(
      sampleNames: sampleNames ?? this.sampleNames,
      selectedSampleIndex: selectedSampleIndex ?? this.selectedSampleIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationSamplePickerState &&
        listEquals(other.sampleNames, sampleNames) &&
        other.selectedSampleIndex == selectedSampleIndex;
  }

  @override
  int get hashCode => sampleNames.hashCode ^ selectedSampleIndex.hashCode;
}
