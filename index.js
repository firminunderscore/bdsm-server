/*
Copyright 2023 Firmin B.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

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
