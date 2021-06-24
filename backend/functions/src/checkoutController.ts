import {logger} from "firebase-functions";
import {Request, Response} from "express";
import {apiUrl, signature} from "./config/rapyd";
import axios from "axios";
import {create, Payment} from "./paymentController";

class Checkout {
  constructor(public totalPrice: Price,
    public walletId: string,
    public merchantReferenceId: string,
    public country: string,
    public products: Product[],
    public mechantLogoUrl: string,
    public successUrl: string,
    public errorUrl: string) { }
}

class Price {
  constructor(public amount: number,
    public currency: string) { }
}

class Product {
  constructor(public name: string, public amount: number,
    public quantity: number, public image?: string,) { }
}

type CreateCheckoutRequest = {
  body: Checkout
}

// type CompleteCheckoutRequest = {
//     body: { token: string }
// }

const getCheckout = async (req: Request, res: Response) => {
  try {
    const id = req.query["id"];
    logger.info("getCheckout", id);
    const path = "v1/checkout/" + id;
    const url = apiUrl(path);
    const s = signature("get", path, "");
    const result = await axios.get(url, s.config())
        .then(function(response) {
          console.log("response", response.data);
          return response.data.data;
        })
        .catch(function(error) {
          console.log("Error", error);
          return null;
        });

    if (result) {
      res.status(200).json(result);
    } else {
      res.sendStatus(500);
    }
  } catch (error) {
    logger.error(error);
    res.status(500).json(error);
  }
};

const createCheckout = async (req: CreateCheckoutRequest, res: Response) => {
  console.log("createCheckout", req.body);

  try {
    const totalPrice = new Price(req.body.totalPrice.amount, req.body.totalPrice.currency);
    const payment = new Payment(totalPrice, req.body.walletId);
    const paymentId = await create(payment);
    // const paymentId = "payment_4cd7bf5988d242b41b3588e82ecbbac8";

    if (paymentId) {
      const path = "v1/checkout";
      const url = apiUrl(path);
      const data = body(req.body, paymentId);
      const s = signature("post", path, data);

      console.log("body", data);

      const checkoutId = await axios.post(url, data, s.config())
          .then(function(response) {
          // console.log("response", JSON.stringify(response.data));
            console.log("data", response.data);
            return response.data.data.id;
          })
          .catch(function(error) {
            logger.error(error);
            return null;
          });

      if (checkoutId) {
        res.status(201).json({checkoutId: checkoutId});
      } else {
        res.sendStatus(400);
      }
    } else {
      res.sendStatus(400);
    }
  } catch (error) {
    logger.error(error);
    res.status(500).json(error);
  }
};

function body(checkout: Checkout, paymentId: string): any {
  return {
    "description": paymentId,
    "amount": checkout.totalPrice.amount,
    "complete_checkout_url": checkout.successUrl,
    "cancel_checkout_url": checkout.errorUrl,
    "country": checkout.country,
    "currency": checkout.totalPrice.currency,
    "merchant_reference_id": checkout.merchantReferenceId,
    "language": "en",
    "cart_items": checkout.products,
    "metadata": {
      "merchant_defined": true,
    },
    "payment_method_type_categories": [
      "card",
      "cash",
    ],
  };
}


export {getCheckout, createCheckout};
