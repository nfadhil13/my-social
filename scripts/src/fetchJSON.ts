import * as http from "http";
import * as https from "https";
import { URL } from "url";

import type { OpenAPISpec } from "./types";

export async function fetchJson(url: string): Promise<OpenAPISpec> {
  return new Promise((resolve, reject) => {
    const urlObj = new URL(url);
    const client = urlObj.protocol === "https:" ? https : http;

    const req = client.get(url, (res) => {
      let data = "";

      res.on("data", (chunk) => {
        data += chunk;
      });

      res.on("end", () => {
        try {
          resolve(JSON.parse(data));
        } catch (e) {
          reject(new Error(`Failed to parse JSON: ${e}`));
        }
      });
    });

    req.on("error", (e) => {
      reject(e);
    });
  });
}
