part of 'notification_cubit.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationSuccess extends NotificationState {
  final List<NotificationModel> data;

  const NotificationSuccess(this.data);

  @override
  List<Object> get props => [data];
}

final class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);
}
