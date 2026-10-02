const https = require("https");

exports.handler = async (event) => {
  console.log("Incoming event:", JSON.stringify(event, null, 2));

  const webhookUrl = process.env.SLACK_WEBHOOK_URL;

  if (!webhookUrl) {
    console.error("Missing SLACK_WEBHOOK_URL");
    throw new Error("No webhook URL configured");
  }

  // ✅ Extract SNS message properly
  const snsMessage = event.Records?.[0]?.Sns?.Message || "No message";

  const payload = JSON.stringify({
    text: `🚨 *ALERT RECEIVED*\n\n${snsMessage}`
  });

  const url = new URL(webhookUrl);

  const options = {
    hostname: url.hostname,
    path: url.pathname + url.search, // ✅ include search just in case
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Content-Length": Buffer.byteLength(payload),
    },
  };

  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      console.log("Slack response status:", res.statusCode);

      let body = "";
      res.on("data", chunk => body += chunk);
      res.on("end", () => {
        console.log("Slack response body:", body);
        resolve(res.statusCode);
      });
    });

    req.on("error", (err) => {
      console.error("Error sending to Slack:", err);
      reject(err);
    });

    req.write(payload);
    req.end();
  });
};