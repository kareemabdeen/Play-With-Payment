# Play With Payment 💳

A Flutter project demonstrating the integration of various payment methods, designed to show how to structure payment logic using clean architecture principles and factory patterns.

## 🌟 Features

- **Stripe Integration**: Secure credit card payments using `flutter_stripe`.
- **Vodafone Cash (Simulation)**: Simulated mobile wallet payment flow.
- **Credit Card (Simulation)**: Simulated logic for generic credit card payments.
- **Factory Pattern**: Demonstrates the use of the Factory Design Pattern to create payment methods dynamically.
- **Secure Configuration**: Uses `.env` to securely manage API keys.

---

## 📸 Screenshots

### ✅ Stripe Payment Integration Done

| | |
|---|---|
| <img src="https://github.com/user-attachments/assets/dc700497-57b3-401a-94bd-ae0922498c3c" width="300" /> | <img src="https://github.com/user-attachments/assets/e94339b6-0380-4589-948e-04c6cf93db98" width="300" /> |

---

## 🏗️ Project Architecture

This project implements the **Factory Method Design Pattern** to handle payment method creation. This ensures that the client code (UI) remains decoupled from the specific implementation details of each payment provider.

### Key Components

- **`IPaymentMethod` (Interface)**  
  Defines the contract (`pay` method) that all payment methods must implement.

- **`PaymentFactory`**  
  A factory class that resolves and returns the correct payment implementation based on `PaymentType`.

- **Concrete Strategies**
  - `StripePayment` (Real integration)
  - `CreditCardPayment` (Simulation)
  - `VodafoneWalletPayment` (Simulation)

---

## 📐 Class Diagram

```mermaid
classDiagram
    class PaymentFactory {
        +createPaymentMethod(PaymentType type) IPaymentMethod
    }

    class IPaymentMethod {
        <<interface>>
        +pay(int amount, String currency) Future<void>
    }

    class StripePayment {
        +pay(int amount, String currency) Future<void>
    }

    class CreditCardPayment {
        +pay(int amount, String currency) Future<void>
    }

    class VodafoneWalletPayment {
        +pay(int amount, String currency) Future<void>
    }

    IPaymentMethod <|.. StripePayment
    IPaymentMethod <|.. CreditCardPayment
    IPaymentMethod <|.. VodafoneWalletPayment
    PaymentFactory ..> IPaymentMethod : Creates
