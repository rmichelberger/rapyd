

import {Request, Response} from "express";
import {apiUrl, signature} from "./config/rapyd";
import {logger} from "firebase-functions";
import axios from "axios";

const getWalletTransactions = async (req: Request, res: Response) => {
  try {
    const id = req.query["id"];
    logger.info("getWalletTransactions", id);
    const path = "v1/user/" + id + "/transactions";
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


export {getWalletTransactions};
