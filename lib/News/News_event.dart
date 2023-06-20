import 'package:equatable/equatable.dart';

sealed class NewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class NewsFetched extends NewsEvent {}

final class NewsRefreshed extends NewsEvent {}
