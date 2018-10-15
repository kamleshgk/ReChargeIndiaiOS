const functions = require('firebase-functions');
const nodemailer = require('nodemailer');
// Configure the email transport using the default SMTP transport and a GMail account.
// For other types of transports such as Sendgrid see https://nodemailer.com/transports/
// TODO: Configure the `gmail.email` and `gmail.password` Google Cloud environment variables.
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;
const mailTransport = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});


// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions


exports.sendTestEmail = functions.database.ref('/comments/{commentid}')
  .onWrite((change, context) => {
    console.log('keyId=', context.params.commentid);

    const updated = change.after.val();
    console.log(updated);
    const oldVal = change.before.val();
    console.log(oldVal);    

    const recordId = context.params.commentid;    
    const emails = ['kamlesh@pluginindia.com', 'damnish.kumar@hytechpro.com', 'raphae@pluginindia.com'];

    return sendTestEmail(emails,recordId, updated);
  })
// [END onWrite]

// Sends a welcome email to the given user.
function sendTestEmail(emails, recordId, updated) {
  const mailOptions = {
    from: 'ReChargeIndia <noreply@example.com>',
    to: emails
  };
  // The user subscribed to the newsletter.
  mailOptions.subject = 'Someone left a comment for a community charge point! ';
  mailOptions.text = 'Hey there! Someone left a comment in ReChargeIndia app for RecordID - ' + recordId + ' BLOB : ' + JSON.stringify(updated, null, 4);
  return mailTransport.sendMail(mailOptions).then(() => {
    console.log('New welcome email sent to multiple receipients');
  });

}

// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
