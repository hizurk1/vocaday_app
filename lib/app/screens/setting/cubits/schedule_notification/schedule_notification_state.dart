part of 'schedule_notification_cubit.dart';

sealed class ScheduleNotificationState extends Equatable {
  const ScheduleNotificationState();

  @override
  List<Object> get props => [];
}

final class ScheduleNotificationInitial extends ScheduleNotificationState {}
