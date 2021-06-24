import {logger} from "firebase-functions";
import {Request, Response} from "express";
import {apiUrl, signature} from "./config/rapyd";
import axios from "axios";

class Payment {
  constructor(public totalPrice: Price,
    public walletId: string
  ) { }
}

class Price {
  constructor(public amount: number,
    public currency: string) { }
}


type CreatePaymentRequest = {
  body: Payment
}

type CompletePaymentRequest = {
  body: { token: string }
}


const getPaymentType = async (req: Request, res: Response) => {
  try {
    const country = req.query["country"];
    const currency = req.query["currency"];
    logger.info("getPaymentType", country, currency);
    const path = "v1/payment_methods/country?country=" + country;// + "&currency=" + currency
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


const getPayment = async (req: Request, res: Response) => {
  try {
    const id = req.query["id"];
    logger.info("getPayment", id);
    const path = "v1/payments/" + id;
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

async function create(payment: Payment): Promise<string | null> {
  console.log("create", payment);

  try {
    const path = "v1/payments";
    const url = apiUrl(path);
    const data = body(payment);
    const s = signature("post", path, data);

    console.log("create payment body", data);

    const paymentId = await axios.post(url, data, s.config())
        .then(function(response) {
        // console.log("response", JSON.stringify(response.data));
          console.log("data", response.data);
          return response.data.data.id;
        })
        .catch(function(error) {
          logger.error(error);
          return null;
        });

    return paymentId;
  } catch (error) {
    logger.error(error);
    return null;
  }
}

const createPayment = async (req: CreatePaymentRequest, res: Response) => {
  logger.info("createPayment", req.body);

  try {
    const paymentId = await create(req.body);
    if (paymentId) {
      res.status(201).json({id: paymentId});
    } else {
      res.sendStatus(400);
    }
  } catch (error) {
    logger.error(error);
    res.status(500).json(error);
  }
};

function body(payment: Payment): any {
  return {
    "amount": payment.totalPrice.amount,
    "currency": payment.totalPrice.currency,
    "payment_method": {
      "type": "us_multiplestoresother_cash", // `${createPayment.countryCode}_cash_cash`,
      "fields": {},
    },
    "ewallets": [
      {
        "ewallet": payment.walletId,
        "percentage": 100,
      },
    ],
    "metadata": {
      "merchant_defined": false,
    },
  };
}

const completePayment = async (req: CompletePaymentRequest, res: Response) => {
  logger.info("completePayment", req.body);

  try {
    const path = "v1/payments/completePayment";
    const url = apiUrl(path);
    const data = req.body;
    const s = signature("post", path, data);

    console.log("body", data);

    const paymentData = await axios.post(url, data, s.config())
        .then(function(response) {
        // console.log("response", JSON.stringify(response.data));
          console.log("data", response.data);
          return response.data.data;
        })
        .catch(function(error) {
          logger.error(error);
          return null;
        });

    if (paymentData) {
      res.status(201).json(paymentData);
    } else {
      res.sendStatus(400);
    }
  } catch (error) {
    logger.error(error);
    res.status(500).json(error);
  }
};

export {createPayment, getPayment, getPaymentType, completePayment, create, Payment};


// curl --header "Accept: application/json" --header "Content-Type: application/json" --data
// '{"walletId":"ewallet_113761b21ea2a4d77ff35570a7a3fc2c","totalPrice":{"amount":1000,"currency":"USD"},"products":[],"country":"US"}'
// -v http://localhost:5001/rapyd-pay/us-central1/api/payments

// curl --header "Accept: application/json" --header "Content-Type: application/json"
// -v http://localhost:5001/rapyd-pay/us-central1/api/payments?id=payment_b1f3b6f9c58de56a6bd5888422c8b10c

// payment_6c0dbb471d2c3503c76a764eedc10b57
// payment_a51cc20a159dedcf939940d93ec92f1a
// payment_73eaa45ded65a2a759d5d756cb836bb4
// payment_b1f3b6f9c58de56a6bd5888422c8b10c
// payment_a8e0f20e07230c895b5dd8462e943cc5
// payment_a19d45449fb06edd9689fdfddf17b0fd

// curl --header "Accept: application/json" --header "Content-Type: application/json"
// -v http://localhost:5001/rapyd-pay/us-central1/api/paymenttype?country=CH&currency=CHF


// curl --header "Accept: application/json" --header "Content-Type: application/json"
// --data '{"token": "payment_26c0e8bbfd8e43705943116504822629"}' -v http://localhost:5001/rapyd-pay/us-central1/api/completePayment
