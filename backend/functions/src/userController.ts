import axios from "axios";
import {Request, Response} from "express";
// import {db, admin} from "./config/firebase";
import {logger} from "firebase-functions";
import {apiUrl, signature} from "./config/rapyd";
import {createWallet} from "./walletController";

// const usersCollection = db.collection("users");

class User {
  constructor(
    public email: string,
    public firstName: string,
    public lastName: string,
    public birthday: number,
    public address: Address,
    // public createdAt?: admin.firestore.FieldValue,
    public walletId?: string,
    public id?: string,
  ) { }

  static from(id: string, user: User): User {
    return new this(user.email, user.firstName, user.lastName, user.birthday, user.address, /* user.createdAt,*/ user.walletId, id);
  }
}

class Address {
  constructor(
    public countryCode: string,
    public state: string,
    public city: string,
    public zip: string,
    public street: string
  ) { }
}

type CreateUserRequest = {
  body: User
}

const createUser = async (req: CreateUserRequest, res: Response) => {
  logger.info("createUser", req.body);

  try {
    // todo: check if email address is already taken

    // create wallet
    const walletId = await createWallet(req.body);
    if (walletId) {
      res.status(201).json({id: walletId});
      // const docRef = usersCollection.doc();
      // req.body.createdAt = admin.firestore.FieldValue.serverTimestamp();
      // req.body.walletId = walletId;

      // await docRef.set(req.body);
      // const user = User.from(docRef.id, req.body);
      // res.status(201).json(user);
    } else {
      res.sendStatus(400);
    }
  } catch (error) {
    logger.error(error);
    res.status(500).json(error);
  }
};

const getUser = async (req: Request, res: Response) => {
  try {
    const id = req.query["id"];
    logger.info("getUser", id);
    const path = "v1/ewallets/" + id + "/contacts";
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


export {createUser, User, getUser};
