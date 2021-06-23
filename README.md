# Rapyd Pay ⚡️

`Formula 0001: Rapyd Fintech Grand Prix`

__A simple e-wallet app with multiple currency.__

_Fun.Easy.Secure.Rapyd._


__Table of Contents__

- [Demo video](#demo-video)
- [Features](#features)
  * [Onboarding 🤳](#onboarding-)
  * [Add fund to your wallet 💸](#add-fund-to-your-wallet-)
  * [Send / receive money 💬](#send--receive-money-)
  * [Pay Online 👩‍💻](#pay-online-)
  * [Pay In store 🛒](#pay-in-store-)
  * [Forward payment ➡️](#forward-payment-%EF%B8%8F)
  * [Digital receipt 🧾](#digital-receipt-)
  * [Insights 💡](#insights-)
- [Business Model 🤑](#business-model-)
- [Technical description 🤓](#technical-description-)
  * [App 📱](#app-)
  * [Backend 💻](#backend-)
  * [Demo shop 🏬](#demo-shop-)
- [ToDos 📝](#todos-)

# Demo Video

[![Demo Video](http://img.youtube.com/vi/uyVSj8GgWzY/0.jpg)](https://youtu.be/uyVSj8GgWzY)

[![Demo Video](http://img.youtube.com/vi/3MOnhAfINNw/0.jpg)](https://youtu.be/3MOnhAfINNw)


# Features 

## Onboarding 🤳
Create your account on your mobile. Everything online, super fast. Just upload a copy of your ID and you're good to go.

## Add fund to your wallet 💸
You can top up your wallet with either a bank transfer or a card payment. Quick and secure.

## Send / receive money 💬
You can send/receive money to your friends & family as easy as sending a chat message.

- Private: Do you want to give pocket money to your children? No problem.
- Business: Payout your employees with Rapyd? No problem.
- Just create a recurring payment and let the magic happen.__*__
##### (*Feature is under development)

## Pay Online 👩‍💻
Instead of giving your credit card details away, you can pay fast & secure with the Rapyd Pay app.

Online shops can integrate the checkout easily with 2 lines of codes:
   
```javascript
<script src="./rapyd.js" defer></script>
RapydPay.createCheckout("ewallet_xx", "mechant_id", 1498.0, "USD", "complete_url", "failed_url", "merchant_logo", [ {'name': '12.9-inch iPad Pro','amount': 1099.0,'quantity': 1, 'image': 'image_url'},{'name': 'Apple Watch Space Gray Aluminum Case with Sport Loop','amount': 399.0,'quantity': 1, 'image': 'image_url'}]);
```

## Pay In store 🛒
Merchants can easily create a payment. No need to have any expensive card terminal, just a phone or a tablet. Type the amount, and show the QR code. Customer can scan it and pay it quickly through the app.

## Forward payment ➡️
You can forward the payment with just one click. Send it to your daddy or to your boss. They'll pay it 😎

- Private: Your children can make purchases by themself but you still have the control over the payment.

- Business: Don't want to give your company credit card details to all your employees? Don't have the time to make all the orders? No problem. Let them make the order but forward the payment directly to you. You've the full overview and control over all the payments.

## Digital receipt 🧾
All your purchases are stored in the app digitally. No paper waste 🌱

Is your electronic product broken you've bought 8 months ago? No worries. You can always find the receipt later if you need it for warranty.

## Insights 💡
Based on the items you've purchased, the app suggests to you additional services:
- Travel insurance
- Extended warranty
- Cross-merchant marketing campaign based on the product information: e.g. the customer buys Coca Cola product in the supermarket, in the bar and later in the restaurant - the app can detect all the Coca Cola products purchased in different stores and can offer e.g. a coupon for a free Cola after every 5 purchases made

# Business Model 🤑

There are several possibilty to make revenue.
- by wallet top-up a fee for instant payment done with card
- possible small fee for send / receive money transactions
- monthly subscription for Family / Business account
  - scheduled transfers
  - recurring transfers
- additional services offered based on the purchased products
  - marketplease for (travel) insurances
  - digital loyalty programs for brands (cross-store purchases)
  - analytics based on purchase informations

# Technical description 🤓

## App 📱
There is an iOS app developed with Swift and SwiftUI.

Following Rapyd APIs are integrated:

- Rapyd Wallet
  - [Create Wallet](https://docs.rapyd.net/build-with-rapyd/reference/wallet-object#create-wallet)
  - [Retreive Wallet Contact](https://docs.rapyd.net/build-with-rapyd/reference/wallet-contact-object#retrieve-wallet-contact)
  - [Retreive Wallet Balances](https://docs.rapyd.net/build-with-rapyd/reference/wallet-transaction-object#retrieve-wallet-balances)
  - [List Wallet Transactions](https://docs.rapyd.net/build-with-rapyd/reference/wallet-transaction-object#list-wallet-transactions)
  - [Transfer Funds Between Wallets](https://docs.rapyd.net/build-with-rapyd/reference/wallet-transaction-object#transfer-funds-between-wallets)
- Rapyd Collect
  - [Create Payment](https://docs.rapyd.net/build-with-rapyd/reference/payment-object#create-payment)
  - [Retreive Payment](https://docs.rapyd.net/build-with-rapyd/reference/payment-object#retrieve-payment)
  - [Complete Payment](https://docs.rapyd.net/build-with-rapyd/reference/payment-object#complete-payment)
  - [Create Checkout Page](https://docs.rapyd.net/build-with-rapyd/reference/checkout-page-object#create-checkout-page)
  - [Retreive Checkout Page](https://docs.rapyd.net/build-with-rapyd/reference/checkout-page-object#retrieve-checkout-page)
- Testing
  - [Add Funds to Wallet Account](https://docs.rapyd.net/build-with-rapyd/reference/add-funds-and-remove-funds-transactions#add-funds-to-wallet-account)


## Backend 💻
A lightweigth middleware was developed with TypeScript and node js, deployed to firebase. It's used only to not to expose the Rapyd Credentials (secret key). Most probably I could've used the Mobile SDK directly without the backend, but at the time I've started with the project, there was no Rapyd Mobile SDK compatible with latest Xcode version.

## Demo shop 🏬
An demo implementation of online purchase was developed with a simple shop.
It can be also used as a virtual terminal for creating in-store payments.

[Webpage](https://rapyd-pay.web.app)

[Shop](https://rapyd-pay.web.app/shop.html)

[Test payments](https://rapyd-pay.web.app/tests.html)

[Balance of example shop](https://rapyd-pay.web.app/balance.html)

[Example checkout](https://rapyd-pay.web.app/checkout/checkout.html?id=checkout_1d2addfc08cd2a0a34d2d557013e2aa1)

# ToDos 📝
- implement onboarding verification
- add a new `payment_method` for the Rapyd Pay e-wallet payment. Currently `us_multiplestoresother_cash` is used, but it supports only `USD` currency.
- instead of using a custom created checkout page, integrate Rapyd Pay payment method to the existing Rapyd checkout page
- use machine learning to provide insights based on the receipt product items (e.g. travel insurance, extendedd warranty, ..)
- I've created only one account, so in the sandbox mode there is always this `merchant_id` used instead of creating multiple merchant accounts as it would be in the real world
- implement recurring payment sending
