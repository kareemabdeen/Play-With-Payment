abstract class IPaymentMethod {
  Future<void> pay({required int amount, required String currency});
}
