import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_cubit.dart';
import 'package:pomodoro_timer_task_management/cubit/timer_logic/timer_event.dart';
import 'package:pomodoro_timer_task_management/models/task.dart';
import 'package:pomodoro_timer_task_management/models/timer_task.dart';
import 'package:pomodoro_timer_task_management/services/task_service.dart';

import '../../core/values/keys.dart';

part 'task_work_state.dart';

class TaskWorkCubit extends Cubit<TaskWorkState> {
  TaskWorkCubit() : super(TaskWorkState.initial());

  TimerTask? _timerTask;
  late final Box<TimerTask> _timerTaskBox;
  TaskService? _taskService;

  void init() async {
    _timerTaskBox = await Hive.openBox<TimerTask>(kTimerTaskBox);
    if (_timerTaskBox.isNotEmpty) {
      _timerTask = _timerTaskBox.values.first;
      _taskService = TaskService(
        boxName: _timerTask!.boxName,
        projectKey: _timerTask!.projectKey,
      );
      await _taskService!.init();
      emit(state.copyWith(task: _timerTask!.task));
    }
  }

  void lisenStream(Stream<TimerEvent> stream) async {
    stream.listen(_mapTimerEventToState);
  }

  Future<bool> trySetTimerTask(TimerTask timerTask) async {
    if (_timerTask != null) {
      return false;
    }

    _taskService = TaskService(
      boxName: timerTask.boxName,
      projectKey: timerTask.projectKey,
    );
    await _taskService!.init();

    _timerTask = timerTask;
    await _timerTaskBox.put(kTimerTaskBox, timerTask);

    emit(state.copyWith(task: timerTask.task));

    return true;
  }

  bool isEqual(TimerTask timerTask) {
    return _timerTask == timerTask;
  }

  void _mapTimerEventToState(TimerEvent event) {
    if (event is TimerStoppedEvent) {
      _saveChanges();
    } else if (event is TimerCycleCompletedEvent) {
      if (event.mode.isWork == false) {
        return;
      }

      final task = state.task;

      final workTime = state.workTime + event.duration;
      final workCycle = state.workCycle + 1;

      emit(
        state.copyWith(
          workTime: workTime,
          workCycle: workCycle,
          task: task?.copyWith(
            workedTime: workTime,
            workedInterval: workCycle,
          ),
        ),
      );
    } else if (event is TimerCompletedEvent) {
      _saveChanges(taskIsDone: true);
    }
  }

  Future<void> _updateTask(bool taskIsDone) async {
    final oldTask = _timerTask!.task;

    final newTask = _timerTask!.task.copyWith(
      workedTime: (oldTask.workedTime ?? 0) + state.workTime,
      workedInterval: (oldTask.workedInterval ?? 0) + state.workCycle,
      isDone: taskIsDone,
    );

    await _taskService!.tryUpdateTask(oldTask, newTask);
  }

  void _saveChanges({bool taskIsDone = false}) async {
    if (_taskService != null) {
      await _updateTask(taskIsDone);
    }

    _reset();

    if (_timerTaskBox.isNotEmpty) {
      await _timerTaskBox.delete(kTimerTaskBox);
    }
  }

  void _reset() {
    _timerTask = null;
    _taskService = null;
    emit(TaskWorkState.initial());
  }
}
