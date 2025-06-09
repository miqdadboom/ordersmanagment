const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

exports.sendOrderNotification = onDocumentCreated("orders/{orderId}", async (event) => {
  const snapshot = event.data;

  if (!snapshot) {
    console.log("No data in snapshot");
    return;
  }

  const orderData = snapshot.data();

  const customerName = orderData.customerName || "Unknown Customer";
  const userRole = orderData.userRole || "Sales Representative";
  const userEmail = orderData.userEmail || "N/A";

  const message = {
    topic: "orders",
    notification: {
      title: " New Order Received",
      body: `A new order has been placed by ${customerName} (${userRole}).`,
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      customerName: customerName,
      userEmail: userEmail,
    },
  };

  try {
    await getMessaging().send(message);
    console.log(" Notification sent successfully");
  } catch (error) {
    console.error(" Error sending notification:", error);
  }
});
