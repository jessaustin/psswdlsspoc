passwordless = require 'passwordless'
DynamoStore = require 'passwordless-dynamostore'
{SES} = require 'aws-sdk'

ses = new SES
  region: 'us-west-2'
  params: Source: 'passwordless@hmamail.com'

app = passwordless.init new DynamoStore
  dynamoOptions: region: 'us-west-2'

passwordless.addDelivery (tokenToSend, uidToSend, recipient, callback) ->
  ses.sendEmail
    Destination: ToAddresses: [ recipient ]
    Message:
      Subject: Data: "Passwordless Login"
      Body: Text: Data:
        "your account here:
         http://#{host}?token=#{tokenToSend}&uid=#{encodeURIComponent uidToSend}"
  , callback

app.use passwordless.sessionSupport()
app.use passwordless.acceptToken
  successRedirect: '/'
