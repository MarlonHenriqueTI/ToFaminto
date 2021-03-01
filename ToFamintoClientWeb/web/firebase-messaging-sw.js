importScripts("https://www.gstatic.com/firebasejs/8.1.2/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.1.2/firebase-messaging.js");
firebase.initializeApp({
    apiKey: "AIzaSyC2AjVAaRUa75gM-5a4pHjbaLrNLSW03S4",
    authDomain: "tofamintoagosto.firebaseapp.com",
    databaseURL: "https://tofamintoagosto.firebaseio.com",
    projectId: "tofamintoagosto",
    storageBucket: "tofamintoagosto.appspot.com",
    messagingSenderId: "995212478601",
    appId: "1:995212478601:web:f436003bbe026208eb5e58",
    measurementId: "G-5741Q1Y4LP"
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
