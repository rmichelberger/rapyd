import * as crypto from "crypto-js";

const API_DOMAIN = "https://sandboxapi.rapyd.net";

class APIRequestHeader {
  constructor(private access_key: string,
        private contentType: string,
        private salt: string,
        private signature: string,
        private timestamp: string) { }

  config(): any {
    return {
      headers: {
        "access_key": this.access_key,
        "content-type": this.contentType,
        "salt": this.salt,
        "signature": this.signature,
        "timestamp": this.timestamp,
      },
    };
  }
}

function apiUrl(path: string): string {
  return API_DOMAIN + "/" + path;
}

function signature(method: string, path: string, data: any): APIRequestHeader {
  const salt = "" + crypto.lib.WordArray.random(12);
  const timestamp = (Math.floor(new Date().getTime() / 1000) - 10).toString();
  // Current Unix time.
  const access_key = "EEC9BA5716628019CB00";
  const secret_key = "2fb92f55df9a20dcd71c7271ee7407f2af223881b9bbca61a9b9bd1e782f134c1caa408d3f9eca3b";
  let body = "";

  if (JSON.stringify(data) !== "{}" && data !== "") {
    body = JSON.stringify(data);
  }

  const to_sign = method.toLowerCase() + "/" + path + salt + timestamp + access_key + secret_key + body;
  const signature = crypto.enc.Hex.stringify(crypto.HmacSHA256(to_sign, secret_key));

  const base64 = crypto.enc.Base64.stringify(crypto.enc.Utf8.parse(signature));
  return new APIRequestHeader(access_key, "application/json", salt, base64, timestamp);
}

export {apiUrl, signature};
