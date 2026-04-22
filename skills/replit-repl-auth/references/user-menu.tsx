// Drop into client/src/components/UserMenu.tsx
// Uses Zillow Constellation. Swap Avatar/Popover/Tag/Button/TextButton/Divider
// for the equivalent components in your UI library if you are not on Constellation.
// The auth logic itself lives in client/src/lib/auth.ts — this file is just presentation.

import { Button, Tag, Text, Avatar, Popover, Divider, TextButton } from "@zillow/constellation";
import { Box, Flex } from "@/styled-system/jsx";
import { useAuth, signIn, signOut } from "@/lib/auth";

export function UserMenu() {
  const { user, isLoading } = useAuth();

  if (isLoading) return null;

  if (!user) {
    return (
      <Button size="sm" emphasis="filled" tone="brand" onClick={() => signIn()}>
        Sign in
      </Button>
    );
  }

  const trigger = (
    <button
      type="button"
      aria-label={`Account menu for ${user.handle}`}
      style={{
        background: "transparent",
        border: "none",
        padding: 0,
        cursor: "pointer",
        borderRadius: "50%",
        lineHeight: 0,
      }}
    >
      {user.profileImage ? (
        <Avatar size="sm" src={user.profileImage} alt={user.handle} />
      ) : (
        <Avatar size="sm" fullName={user.handle} />
      )}
    </button>
  );

  return (
    <Popover
      placement="bottom-end"
      modal={false}
      trigger={trigger}
      header={
        <Flex direction="column" gap="200">
          <Flex align="center" gap="200">
            {user.profileImage ? (
              <Avatar size="sm" src={user.profileImage} alt={user.handle} />
            ) : (
              <Avatar size="sm" fullName={user.handle} />
            )}
            <Text textStyle="body-bold">{user.handle}</Text>
            {user.isAdmin && (
              <Tag size="sm" tone="blue" css={{ whiteSpace: "nowrap" }}>
                Admin
              </Tag>
            )}
          </Flex>
          <Text textStyle="body-sm" css={{ color: "text.subtle" }}>
            {user.email}
          </Text>
        </Flex>
      }
      body={
        <Box>
          <Text textStyle="body-sm" css={{ color: "text.subtle", display: "block", mb: "200" }}>
            {user.isAdmin
              ? "You can perform admin actions on this app."
              : "Some actions are limited to admins."}
          </Text>
          <Divider />
          <Box css={{ pt: "200" }}>
            <TextButton size="sm" onClick={() => signOut()}>
              Sign out
            </TextButton>
          </Box>
        </Box>
      }
    />
  );
}
