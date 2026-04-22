import { useQuery } from "@tanstack/react-query";

export interface AuthUser {
  id: string;
  handle: string;
  email: string;
  roles: string[];
  profileImage?: string;
  isAdmin: boolean;
}

interface AuthResponse {
  user: AuthUser | null;
}

async function fetchMe(): Promise<AuthResponse> {
  const res = await fetch("/api/auth/me", { credentials: "include" });
  if (!res.ok) return { user: null };
  return res.json();
}

export function useAuth() {
  const q = useQuery({
    queryKey: ["/api/auth/me"],
    queryFn: fetchMe,
    staleTime: 60_000,
    refetchOnWindowFocus: true,
  });
  return {
    user: q.data?.user ?? null,
    isLoading: q.isLoading,
    isAuthenticated: !!q.data?.user,
    isAdmin: !!q.data?.user?.isAdmin,
    refresh: q.refetch,
  };
}

export function buildSignInUrl(returnTo?: string): string {
  const here =
    returnTo ||
    (typeof window !== "undefined"
      ? window.location.pathname + window.location.search
      : "/");
  const domain =
    typeof window !== "undefined" ? window.location.host : "";
  return `https://replit.com/auth_with_repl_site?domain=${encodeURIComponent(
    domain,
  )}&path=${encodeURIComponent(here)}`;
}

function navigateTopOrNewTab(url: string) {
  if (typeof window === "undefined") return;
  try {
    if (window.top && window.top !== window.self) {
      window.top.location.href = url;
      return;
    }
  } catch {
    // Cross-origin parent — fall through to new tab.
  }
  try {
    if (window.top && window.top !== window.self) {
      window.open(url, "_blank", "noopener,noreferrer");
      return;
    }
  } catch {
    // Ignore.
  }
  window.location.href = url;
}

export function signIn(returnTo?: string) {
  navigateTopOrNewTab(buildSignInUrl(returnTo));
}

export function signOut() {
  navigateTopOrNewTab("https://replit.com/logout");
}
