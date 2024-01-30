const std = @import("std");
const z = @import("zlox.zig");

pub const TokenType = enum(u8) {
    // Single-character tokens.
    LEFT_PAREN,
    RIGHT_PAREN,
    LEFT_BRACE,
    RIGHT_BRACE,
    COMMA,
    DOT,
    MINUS,
    PLUS,
    SEMICOLON,
    SLASH,
    STAR,
    // One or two character tokens.
    BANG,
    BANG_EQUAL,
    EQUAL,
    EQUAL_EQUAL,
    GREATER,
    GREATER_EQUAL,
    LESS,
    LESS_EQUAL,
    // Literals.
    IDENTIFIER,
    STRING,
    NUMBER,
    // Keywords.
    AND,
    CLASS,
    ELSE,
    FALSE,
    FOR,
    FUN,
    IF,
    NIL,
    OR,
    PRINT,
    RETURN,
    SUPER,
    THIS,
    TRUE,
    VAR,
    WHILE,

    ERROR,
    EOF,
};

// typedef struct {
//   TokenType type;
//   const char* start;
//   int length;
//   int line;
// } Token;

// the book says:
// Instead, we use the original source string as our character store. We represent a lexeme by a pointer to its first character and the number of characters it contains.

// we kinda dont have pointer arithmetic in zig, so lets use indexes?
// I do believe we can still use indexes, so lets do that.
// but we still have to keep source? confusing

pub const Token = struct {
    token_type: TokenType,
    value: z.string,
    line: isize,
};

pub const Scanner = struct {
    source: z.string,
    start: usize,
    current: usize,
    line: usize,

    pub fn init(source: z.string) Scanner {
        return Scanner{ .source = source, .start = 0, .current = 0, .line = 1 };
    }

    pub fn scan_token(scanner: *Scanner) Token {
        scanner.start = scanner.current;

        if (scanner.is_at_end())
            return make_token(.EOF);

        const ch = scanner.advance();

        switch (ch) {
            '(' => return scanner.make_token(.LEFT_PAREN),
            ')' => return scanner.make_token(.RIGHT_PAREN),
            '{' => return scanner.make_token(.LEFT_BRACE),
            '}' => return scanner.make_token(.RIGHT_BRACE),
            ';' => return scanner.make_token(.SEMICOLON),
            ',' => return scanner.make_token(.COMMA),
            '.' => return scanner.make_token(.DOT),
            '-' => return scanner.make_token(.MINUS),
            '+' => return scanner.make_token(.PLUS),
            '/' => return scanner.make_token(.SLASH),
            '*' => return scanner.make_token(.STAR),

            // a bit hard to read, but book does it ternary
            '!' => return scanner.make_token(if (scanner.match('=')) .BANG_EQUAL else .BANG),
            '=' => return scanner.make_token(if (scanner.match('=')) .EQUAL_EQUAL else .EQUAL),
            '<' => return scanner.make_token(if (scanner.match('=')) .LESS_EQUAL else .LESS),
            '>' => return scanner.make_token(if (scanner.match('=')) .GREATER_EQUAL else .GREATER),

            else => return error_token("Unexpected character."),
        }
    }

    fn is_at_end(scanner: *Scanner) bool {
        return scanner.source[scanner.current] == '0';
    }

    fn make_token(scanner: *Scanner, typ: TokenType) Token {
        return Token{
            .token_type = typ,
            .value = scanner.source[scanner.start..scanner.current],
            .line = scanner.line,
        };
    }

    fn error_token(scanner: *Scanner, message: z.string) Token {
        return Token{ .token_type = .ERROR, .value = message, .line = scanner.line };
    }

    fn advance(scanner: *Scanner) u8 {
        defer scanner.current += 1;
        return scanner.source[scanner.current];
    }

    fn match(scanner: *Scanner, expected: u8) bool {
        if (scanner.is_at_end())
            return false;

        if (scanner.source[scanner.current] != expected)
            return false;

        // note how we consume only if match:
        // > After consuming the first character, we look for an =. If found, we consume it and return the corresponding two-character token. Otherwise, we leave the current character alone (so it can be part of the next token)
        scanner.current += 1;
        return true;
    }
};
