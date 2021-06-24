import * as functions from "firebase-functions";
import * as express from "express";
import {createUser, getUser} from "./userController";
import {addFund, getWallet, getWalletBalance, moveFund} from "./walletController";
import {completePayment, createPayment, getPayment, getPaymentType} from "./paymentController";
import * as cors from "cors";
import {createCheckout, getCheckout} from "./checkoutController";
import {getWalletTransactions} from "./transactionController";

const app = express();
app.use(cors({origin: true}));

app.post("/user", createUser);
app.get("/user", getUser);
app.get("/wallet", getWallet);
app.get("/balance", getWalletBalance);
app.get("/transactions", getWalletTransactions);
app.get("/payments", getPayment);
app.post("/payments", createPayment);
app.post("/checkouts", createCheckout);
app.get("/checkouts", getCheckout);
app.get("/paymenttype", getPaymentType);
app.post("/completePayment", completePayment);
app.post("/transfer", moveFund);
app.post("/deposit", addFund);

exports.api = functions.https.onRequest(app);
