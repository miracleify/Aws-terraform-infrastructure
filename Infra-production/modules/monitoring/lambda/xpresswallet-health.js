const https = require("https");
const {
  CloudWatchClient,
  PutMetricDataCommand,
} = require("@aws-sdk/client-cloudwatch");

const cloudwatch = new CloudWatchClient({ region: process.env.AWS_REGION });

exports.handler = async () => {
  const url = `${process.env.XPRESS_BASE_URL}/transfer/banks`;

  let metricValue = 0;
  let reason = "Unknown";

  try {
    await new Promise((resolve, reject) => {
      https
        .get(url, (res) => {
          if (res.statusCode && res.statusCode < 500) {
            metricValue = 1;
            reason = `HTTP ${res.statusCode}`;
            resolve();
          } else {
            reason = `HTTP ${res.statusCode}`;
            reject(new Error(reason));
          }
        })
        .on("error", reject);
    });
  } catch (err) {
    reason = err.message;
    metricValue = 0;
  }

  await cloudwatch.send(
    new PutMetricDataCommand({
      Namespace: process.env.METRIC_NAMESPACE,
      MetricData: [
        {
          MetricName: process.env.METRIC_NAME,
          Unit: "Count",
          Value: metricValue,
        },
      ],
    })
  );

  console.log(
    JSON.stringify({
      provider: "XpressWallet",
      endpoint: url,
      status: metricValue ? "HEALTHY" : "UNHEALTHY",
      reason,
      checked_at: new Date().toISOString(),
    })
  );

  return {
    statusCode: 200,
    body: JSON.stringify({ metricValue, reason }),
  };
};