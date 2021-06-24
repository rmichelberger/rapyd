function RapydPay() {


    RapydPay.prototype.createCheckout = function (walletId, merchantReferenceId, amount, currency, success, failure, logo_url, products) {
        console.log(walletId, amount, currency, success, failure, logo_url, products);

        let data = { "walletId": walletId, "merchantReferenceId": merchantReferenceId, "totalPrice": { "amount": amount, "currency": currency }, "products": products, "country": "US", "successUrl": success, "errorUrl": failure, "mechantLogoUrl": logo_url };

        // fetch("http://localhost:5001/rapyd-pay/us-central1/api/checkouts", {
        fetch("https://us-central1-rapyd-pay.cloudfunctions.net/api/checkouts", {
            method: "POST",
            body: JSON.stringify(data),
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
            }
        })
            .then(response => response.json())
            .then(res => {
                console.log("Request complete! response:", res);
                if (res.checkoutId) {
                    window.location.href = "https://rapyd-pay.web.app/checkout/checkout.html?id=" + res.checkoutId
                    // window.location.href = "http://localhost:5000/checkout/checkout.html?id=" + res.checkoutId
                }
            });

        // window.location.href = "http://localhost:5000/?id=" + walletId;
    };


}