import { randomBytes } from "node:crypto";

process.stdout.write(`${randomBytes(14).toString("base64url")}\n`);
