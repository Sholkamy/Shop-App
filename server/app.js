var paypal = require('paypal-rest-sdk');
var express = require('express');
var app = express();

paypal.configure({
    'mode': 'sandbox', //sandbox or live
    'client_id': 'AcAY44CO-TBO7SgrFgUOt6rwVN1f9RAPh-syi-iRdqK5ci0WXtLEPPFXAC3YiUqt7yrkrv3XPqNC_Pm8',
    'client_secret': 'EO9qVj1WjfjvQWOzJBVQbdfVYtBioABlY0DKRwT7-a9hnYKi91-vqiRXyuOBnjCvi_f4c-e-7-T86I1V'
  });

  app.get('/pay',(req,res) => {
    var create_payment_json = {
        "intent": "sale",
        "payer": {
            "payment_method": "paypal"
        },
        "redirect_urls": {
            "return_url": "http://10.0.2.2:8000/success",
            "cancel_url": "http://cancel.url"
        },
        "transactions": [{
            "item_list": {
                "items": [{
                    "name": "item",
                    "sku": "item",
                    "price": "100",
                    "currency": "USD",
                    "quantity": 1
                }]
            },
            "amount": {
                "currency": "USD",
                "total": "100"
            },
            "description": "This is the payment description."
        }]
    };
    
    
    paypal.payment.create(create_payment_json, (error, payment) => {
        if (error) {
            throw error;
        } else {
            console.log("Create Payment Response");
            console.log(payment);
            for(let i=0;i<payment.links.length;i++) 
            {
                if(payment.links[i].rel=="approval_url") 
                {
                    res.redirect(payment.links[i].href);
 
                }
            }
        }
    });    
  })

  app.get("/success",(req,res) =>
  {
    var execute_payment_json = {
        "payer_id": req.query.PayerID,
        "transactions": [{
            "amount": {
                "currency": "USD",
                "total": "100"
            }
        }]
    };
    
    var paymentId = req.query.paymentId;
    
    paypal.payment.execute(paymentId, execute_payment_json, (error, payment) => {
        if (error) {
            console.log(error.response);
            throw error;
        } else {
            console.log("Get Payment Response");
            console.log(JSON.stringify(payment));
        }
    });  
  })

app.listen(8000,'127.0.0.1',(req,res) => {
    console.log('server started');
});