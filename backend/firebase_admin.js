const admin = require('firebase-admin');

let firestore = null;

try {
  if (process.env.GOOGLE_APPLICATION_CREDENTIALS || process.env.FIREBASE_PROJECT_ID) {
    const initOptions = {};
    if (process.env.FIREBASE_PROJECT_ID) {
      initOptions.projectId = process.env.FIREBASE_PROJECT_ID;
    }
    admin.initializeApp({
      credential: admin.credential.applicationDefault(),
      ...initOptions,
    });
    firestore = admin.firestore();
    console.log('✅ Firebase Admin initialized successfully');
  } else {
    console.warn('⚠️ Firebase Admin not initialized: missing GOOGLE_APPLICATION_CREDENTIALS or FIREBASE_PROJECT_ID.');
  }
} catch (error) {
  console.warn('⚠️ Firebase Admin initialization failed:', error && error.message ? error.message : error);
}

module.exports = { admin, firestore };