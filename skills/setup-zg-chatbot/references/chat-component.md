# ZGChat Reference Implementation

Complete, working React component for the ZG chatbot with streaming SSE support. Adapt the styling to match the user's design system but keep all the logic intact.

## Component Code

```tsx
import { useState, useRef, useEffect, useCallback } from 'react';
import ReactMarkdown from 'react-markdown';

interface ChatMessage {
  id: string;
  role: 'user' | 'assistant';
  content: string;
  isStreaming?: boolean;
  error?: boolean;
}

export function ZGChat() {
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const [conversationId, setConversationId] = useState<string | null>(null);
  const [isStreaming, setIsStreaming] = useState(false);
  const scrollRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    scrollRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const sendMessage = useCallback(async (retryMessage?: string) => {
    const text = retryMessage || input.trim();
    if (!text || isStreaming) return;

    if (!retryMessage) setInput('');

    const userMsgId = crypto.randomUUID();
    const assistantMsgId = crypto.randomUUID();

    if (!retryMessage) {
      setMessages(prev => [...prev, { id: userMsgId, role: 'user', content: text }]);
    }

    setMessages(prev => [...prev, { id: assistantMsgId, role: 'assistant', content: '', isStreaming: true }]);
    setIsStreaming(true);

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: text, conversationId }),
      });

      if (!response.ok) {
        const err = await response.json().catch(() => ({ error: 'Request failed' }));
        throw new Error(err.error || `HTTP ${response.status}`);
      }

      const reader = response.body!.getReader();
      const decoder = new TextDecoder();
      let buffer = '';
      let fullText = '';
      let eventType = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop()!;

        for (const line of lines) {
          if (line.startsWith('event: ')) {
            eventType = line.slice(7).trim();
          } else if (line.startsWith('data: ') && eventType) {
            try {
              const data = JSON.parse(line.slice(6));

              if (eventType === 'delta') {
                fullText += data.content;
                setMessages(prev =>
                  prev.map(m => m.id === assistantMsgId
                    ? { ...m, content: fullText }
                    : m
                  )
                );
              } else if (eventType === 'done') {
                setConversationId(data.conversationId);
              } else if (eventType === 'error') {
                throw new Error(data.error || 'Stream error');
              }
            } catch (parseErr) {
              if (parseErr instanceof SyntaxError) continue;
              throw parseErr;
            }
            eventType = '';
          }
        }
      }

      setMessages(prev =>
        prev.map(m => m.id === assistantMsgId
          ? { ...m, isStreaming: false }
          : m
        )
      );
    } catch (err: any) {
      setMessages(prev =>
        prev.map(m => m.id === assistantMsgId
          ? { ...m, content: err.message || 'Something went wrong', isStreaming: false, error: true }
          : m
        )
      );
    } finally {
      setIsStreaming(false);
      inputRef.current?.focus();
    }
  }, [input, conversationId, isStreaming]);

  return (
    <div className="zg-chat" style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
      {/* Message List */}
      <div style={{ flex: 1, overflowY: 'auto', padding: '1rem' }}>
        {messages.length === 0 && (
          <div style={{ textAlign: 'center', color: '#999', marginTop: '2rem' }}>
            Send a message to start chatting
          </div>
        )}
        {messages.map(msg => (
          <div
            key={msg.id}
            style={{
              display: 'flex',
              justifyContent: msg.role === 'user' ? 'flex-end' : 'flex-start',
              marginBottom: '0.75rem',
            }}
          >
            <div
              style={{
                maxWidth: '80%',
                padding: '0.75rem 1rem',
                borderRadius: '1rem',
                ...(msg.role === 'user'
                  ? { backgroundColor: '#2563eb', color: '#fff', borderBottomRightRadius: '0.25rem' }
                  : msg.error
                    ? { backgroundColor: '#fef2f2', color: '#991b1b', border: '1px solid #fecaca', borderBottomLeftRadius: '0.25rem' }
                    : { backgroundColor: '#f3f4f6', color: '#111', borderBottomLeftRadius: '0.25rem' }
                ),
              }}
            >
              {msg.role === 'assistant' && !msg.error ? (
                <div className="prose prose-sm max-w-none">
                  <ReactMarkdown>{msg.content || (msg.isStreaming ? '...' : '')}</ReactMarkdown>
                </div>
              ) : (
                <span>{msg.content}</span>
              )}
              {msg.error && (
                <button
                  onClick={() => {
                    setMessages(prev => prev.filter(m => m.id !== msg.id));
                    const lastUserMsg = [...messages].reverse().find(m => m.role === 'user');
                    if (lastUserMsg) sendMessage(lastUserMsg.content);
                  }}
                  style={{
                    display: 'block',
                    marginTop: '0.5rem',
                    fontSize: '0.8rem',
                    textDecoration: 'underline',
                    cursor: 'pointer',
                    background: 'none',
                    border: 'none',
                    color: '#991b1b',
                    padding: 0,
                  }}
                >
                  Try again
                </button>
              )}
            </div>
          </div>
        ))}
        {isStreaming && messages[messages.length - 1]?.content === '' && (
          <div style={{ color: '#999', fontSize: '0.875rem', marginLeft: '0.5rem' }}>Thinking...</div>
        )}
        <div ref={scrollRef} />
      </div>

      {/* Input Area */}
      <div style={{ display: 'flex', gap: '0.5rem', padding: '0.75rem 1rem', borderTop: '1px solid #e5e7eb' }}>
        <input
          ref={inputRef}
          type="text"
          value={input}
          onChange={e => setInput(e.target.value)}
          onKeyDown={e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(); } }}
          placeholder="Type a message..."
          disabled={isStreaming}
          style={{
            flex: 1,
            padding: '0.625rem 0.875rem',
            borderRadius: '0.5rem',
            border: '1px solid #d1d5db',
            outline: 'none',
            fontSize: '0.9rem',
          }}
          data-testid="input-chat-message"
        />
        <button
          onClick={() => sendMessage()}
          disabled={isStreaming || !input.trim()}
          style={{
            padding: '0.625rem 1.25rem',
            borderRadius: '0.5rem',
            backgroundColor: isStreaming || !input.trim() ? '#93c5fd' : '#2563eb',
            color: '#fff',
            border: 'none',
            cursor: isStreaming || !input.trim() ? 'default' : 'pointer',
            fontSize: '0.9rem',
            fontWeight: 500,
          }}
          data-testid="button-send-chat"
        >
          Send
        </button>
      </div>
    </div>
  );
}
```

## Adapting Styles

- **Tailwind/shadcn**: Replace inline `style` objects with Tailwind classes. Use the project's existing Card, Button, Input components if available.
- **Dark mode**: If the project supports dark mode, add dark variants for the bubble colors (e.g., `dark:bg-gray-800` for assistant, `dark:bg-blue-600` for user).
- **Floating widget**: Wrap in a fixed-position container with a toggle button:
  ```tsx
  <div style={{ position: 'fixed', bottom: 24, right: 24, width: 400, height: 500, zIndex: 50 }}>
    <ZGChat />
  </div>
  ```
- **Full page**: Give the parent container `height: 100vh` or use flex layout.

## SSE Event Reference

```
event: delta
data: {"content":"Hello"}

event: delta
data: {"content":" there!"}

event: delta
data: {"content":" How can"}

event: citations
data: {"citations":[{"fileName":"faq.txt","text":"relevant excerpt..."}]}

event: done
data: {"conversationId":"abc-123","messageId":"msg-456"}
```

On error:
```
event: error
data: {"error":"Rate limit exceeded","retryable":true}
```

## Type Definitions

```typescript
interface StreamDelta {
  content: string;
}

interface StreamCitations {
  citations: Array<{ fileName: string; text: string }>;
}

interface StreamDone {
  conversationId: string;
  messageId: string;
}

interface StreamError {
  error: string;
  retryable: boolean;
}
```
