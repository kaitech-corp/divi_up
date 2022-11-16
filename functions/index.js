const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

//  Function to disable user account
exports.disableAccount = functions.https.onCall((data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Unable to perform action."
    );
  }
  const uid = context.auth.uid;
  return admin.auth().updateUser(uid, {
    disabled: true,
  });
});
//  Log errors
exports.logError = functions.https.onCall((data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "Unable to perform action."
    );
  }
  const error = data.error;
  console.log(error);
});
