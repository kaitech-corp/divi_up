class CreateItemState {
  CreateItemState(
      {
        required this.isRestaurant,
        required this.hasTotal,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure});

  factory CreateItemState.restaurant() {
    return CreateItemState(
      isRestaurant: true,
      hasTotal: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory CreateItemState.notRestaurant() {
    return CreateItemState(
      isRestaurant: false,
      hasTotal: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }
  factory CreateItemState.initial() {
    return CreateItemState(
      isRestaurant: true,
      hasTotal: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory CreateItemState.loading() {
    return CreateItemState(
      isRestaurant: true,
      hasTotal: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  factory CreateItemState.failure() {
    return CreateItemState(
      isRestaurant: true,
      hasTotal: false,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
    );
  }

  factory CreateItemState.success() {
    return CreateItemState(
      isRestaurant: true,
      hasTotal: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
    );
  }
  final bool hasTotal;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isRestaurant;

  bool get isFormValid => hasTotal;

  CreateItemState update({
  bool? hasTotal,
}) {
    return copyWith(
      hasTotal:hasTotal,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
    );
  }

  CreateItemState copyWith({
    bool? isRestaurant,
    bool? hasTotal,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return CreateItemState(
      isRestaurant: isRestaurant ?? this.isRestaurant,
      hasTotal: hasTotal ?? this.hasTotal,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }
}
