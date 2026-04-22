import type { Request, Response, NextFunction } from "express";

export interface AuthUser {
  id: string;
  handle: string;
  email: string;
  roles: string[];
  profileImage?: string;
  isAdmin: boolean;
}

declare global {
  namespace Express {
    interface Request {
      user: AuthUser | null;
    }
  }
}

const EMAIL_DOMAIN = process.env.AUTH_EMAIL_DOMAIN || "zillowgroup.com";

function parseAdminEmails(): Set<string> {
  const raw = process.env.ADMIN_EMAILS || "";
  return new Set(
    raw
      .split(/[,;\s]+/)
      .map((s) => s.trim().toLowerCase())
      .filter(Boolean),
  );
}

let adminEmails = parseAdminEmails();
if (adminEmails.size === 0) {
  console.warn(
    "[auth] ADMIN_EMAILS is not set or empty — no users will have admin permissions.",
  );
}

export function refreshAdminEmails() {
  adminEmails = parseAdminEmails();
}

function header(req: Request, name: string): string {
  const v = req.headers[name.toLowerCase()];
  if (Array.isArray(v)) return v[0] || "";
  return (v as string) || "";
}

export function buildUserFromRequest(req: Request): AuthUser | null {
  const id = header(req, "x-replit-user-id");
  const handle = header(req, "x-replit-user-name");
  if (!id || !handle) return null;

  const email = `${handle.toLowerCase()}@${EMAIL_DOMAIN}`;
  const roles = header(req, "x-replit-user-roles")
    .split(",")
    .map((r) => r.trim())
    .filter(Boolean);
  const profileImage = header(req, "x-replit-user-profile-image") || undefined;

  return {
    id,
    handle,
    email,
    roles,
    profileImage,
    isAdmin: adminEmails.has(email),
  };
}

export function authMiddleware(req: Request, _res: Response, next: NextFunction) {
  req.user = buildUserFromRequest(req);
  next();
}

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  if (!req.user) {
    return res
      .status(401)
      .json({ error: "Sign in with Replit to perform this action." });
  }
  next();
}

export function requireAdmin(req: Request, res: Response, next: NextFunction) {
  if (!req.user) {
    return res
      .status(401)
      .json({ error: "Sign in with Replit to perform this action." });
  }
  if (!req.user.isAdmin) {
    return res
      .status(403)
      .json({ error: "Admin permission required." });
  }
  next();
}
