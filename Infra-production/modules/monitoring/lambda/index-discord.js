const https = require("https");

exports.handler = async (event) => {
  const webhookUrl = process.env.DISCORD_WEBHOOK_URL;

  const message = JSON.stringify({
    content: `🚨 ALERT RECEIVED\n\n${JSON.stringify(event, null, 2)}`
  });

  const url = new URL(webhookUrl);

  const options = {
    hostname: url.hostname,
    path: url.pathname + url.search,
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Content-Length": message.length,
    },
  };

  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => resolve(res.statusCode));
    req.on("error", reject);
    req.write(message);
    req.end();
  });
};