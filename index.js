const http = require("http"),
  os = require("os"),
  cpuStat = require("cpu-stat");

const servername = "dev",
  password = "password",
  port = 3040;

const server = http.createServer((req, res) => {
  if (req.method === "POST" && req.headers.auth === password) {
    if (req.url === "/update") {
      cpuStat.usagePercent(function (err, cpupercent, seconds) {
        const responseJson = {
          serverId: servername,
          serverUptime: os.uptime(),
          serverHostname: os.hostname(),
          cpuUsage: cpupercent,
          cpuArch: os.arch(),
          cpuName: os.cpus()[0].model,
          cpuList: os.cpus(),
          ramUsage:
            Math.round((os.totalmem() - os.freemem()) / 1024 / 1024 / 100) /
              10 +
            "GB" +
            "/" +
            Math.round(os.totalmem() / 1024 / 1024 / 100) / 10 +
            "GB",
          ramPercent:
            100 - Math.round((os.freemem() / os.totalmem()) * 100) + "%",
          osType: os.type(),
          osPlatform: os.platform(),
          osVersion: os.version(),
          osRelease: os.release(),
          networkInterfaces: os.networkInterfaces(),
        };
        res.setHeader("Content-Type", "application/json");
        res.end(JSON.stringify(responseJson));
      });
    } else {
      res.statusCode = 404;
      res.end("Not Found\n");
    }
  } else {
    res.statusCode = 403;
    res.end("Nothing here\n");
  }
});

server.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
