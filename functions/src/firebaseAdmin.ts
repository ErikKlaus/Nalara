import * as admin from 'firebase-admin';

const app = admin.apps.length ? admin.app() : admin.initializeApp();

export const db = app.firestore();
export const FieldValue = admin.firestore.FieldValue;
export const Timestamp = admin.firestore.Timestamp;
