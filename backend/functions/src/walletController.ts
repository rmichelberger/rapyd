import {Request, Response} from "express";
import {apiUrl, signature} from "./config/rapyd";
import {logger} from "firebase-functions";
import {User} from "./userController";
import {dateString} from "./utils";
import axios from "axios";

const getWallet = async (req: Request, res: Response) => {
  try {
    const id = req.query["id"];
    logger.info("getWallet", id);
    const path = "v1/user/" + id;
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
    res.status(500).json(error);
  }
};

const getWalletBalance = async (req: Request, res: Response) => {
  try {
    const id = req.query["id"];
    logger.info("getWalletBalance", id);
    const path = "v1/user/" + id + "/accounts";
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
    res.status(500).json(error);
  }
};


async function createWallet(user: User): Promise<string | null> {
  logger.info("createWallet");

  const path = "v1/user";
  const url = apiUrl(path);
  const data = body(user);
  const s = signature("post", path, data);

  console.log("data", data);

  return axios.post(url, data, s.config())
      .then(function(response) {
        console.log("response", JSON.stringify(response.data));
        console.log("wallet id", response.data.data.id);
        return response.data.data.id;
      })
      .catch(function(error) {
        console.log("Error", error);
        return null;
      });
}

function body(user: User): any {
  const date = new Date(user.birthday);
  const date_of_birth = dateString(date);

  let ewallet_reference_id = "";

  if (user.id) {
    ewallet_reference_id = user.id;
  } else {
    const timeStamp = new Date().getTime();
    ewallet_reference_id = user.firstName + "-" + user.lastName + "-" + timeStamp;
  }

  return {
    "first_name": user.firstName,
    "last_name": user.lastName,
    "email": "",
    "ewallet_reference_id": ewallet_reference_id,
    "metadata": {
      "merchant_defined": true,
    },
    "phone_number": "",
    "type": "person",
    "contact": {
      // "phone_number": "+14155551311",
      "email": user.email,
      "first_name": user.firstName,
      "last_name": user.lastName,
      "mothers_name": "Jane Smith",
      "contact_type": "personal",
      "address": {
        "name": user.firstName + " " + user.lastName,
        "line_1": user.address.street,
        "line_2": "",
        "line_3": "",
        "city": user.address.city,
        "state": user.address.state,
        "country": user.address.countryCode,
        "zip": user.address.zip,
        // "phone_number": "+14155551111",
        "metadata": {},
        "canton": "",
        "district": "",
      },
      // "identification_type": "PA",
      // "identification_number": "1234567890",
      "date_of_birth": date_of_birth,
      "country": "US",
      // "nationality": "FR",
      "metadata": {
        "merchant_defined": true,
      },
    },
  };
}

const moveFund = async (req: Request, res: Response) => {
  try {
    logger.info("moveFund", req.body);
    const path = "v1/account/transfer";
    const url = apiUrl(path);

    const data = {
      "amount": req.body.amount,
      "currency": req.body.currency,
      "source_ewallet": req.body.source,
      "destination_ewallet": req.body.destination,
    };

    const s = signature("post", path, data);

    const result = await axios.post(url, data, s.config())
        .then(async function(response) {
          console.log("response", response.data);
          const id = response.data.data.id;
          if (id) {
            return await confirmTransfer(id);
          }
          return null;
        })
        .catch(function(error) {
          console.log("Error", error);
          return null;
        });

    if (result) {
      res.status(201).json(result);
    } else {
      res.sendStatus(500);
    }
  } catch (error) {
    res.status(500).json(error);
  }
};

async function confirmTransfer(id: string): Promise<string | null> {
  logger.info("confirmTransfer");

  const path = "v1/account/transfer/response";
  const url = apiUrl(path);
  const data = {
    "id": id,
    "status": "accept",
  };
  const s = signature("post", path, data);

  return axios.post(url, data, s.config())
      .then(function(response) {
        console.log("response", JSON.stringify(response.data));
        return response.data.data.id;
      })
      .catch(function(error) {
        console.log("Error", error);
        return null;
      });
}

const addFund = async (req: Request, res: Response) => {
  try {
    logger.info("addFund", req.body);
    const path = "v1/account/deposit";
    const url = apiUrl(path);

    const data = {
      "amount": req.body.amount,
      "currency": req.body.currency,
      "ewallet": req.body.walletId,
    };

    const s = signature("post", path, data);

    const result = await axios.post(url, data, s.config())
        .then(async function(response) {
          console.log("response", response.data);
          const id = response.data.data.id;
          return id;
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
    res.status(500).json(error);
  }
};


export {createWallet, getWallet, moveFund, getWalletBalance, addFund};

// curl --header "Accept: application/json" --header "Content-Type: application/json" --data
// '{"source":"ewallet_113761b21ea2a4d77ff35570a7a3fc2c","amount":10,"currency":"USD","destination":"ewallet_cfc218ff7c742a7d1f632ef69a009de6"}'
// -v http://localhost:5001/rapyd-pay/us-central1/api/transfer

// curl --header "Accept: application/json" --header "Content-Type: application/json"
// -v http://localhost:5001/rapyd-pay/us-central1/api/user?id=ewallet_113761b21ea2a4d77ff35570a7a3fc2c

// 5c90ed92-c392-11eb-b38b-02240218ee6d
