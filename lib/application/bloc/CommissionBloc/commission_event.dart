part of 'commission_bloc.dart';

abstract class CommissionEvent extends Equatable {
  const CommissionEvent();

  @override
  List<Object> get props => [];
}

class RequestPayment extends CommissionEvent {
  @override
  List<Object> get props => [];
}

class GetMyAccount extends CommissionEvent {
  @override
  List<Object> get props => [];
}
