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
    line: isize,

    pub fn init(source: z.string) Scanner {
        return Scanner{ .source = source, .start = 0, .current = 0, .line = 1 };
    }

    fn is_digit(ch: u8) bool {
        return ch >= '0' and ch <= '9';
    }

    fn is_alpha(ch: u8) bool {
        switch (ch) {
            'a'...'z' => return true,
            'A'...'Z' => return true,
            '_' => return true,
            else => return false,
        }
    }

    pub fn scan_token(scanner: *Scanner) Token {
        scanner.skip_whitespace();

        scanner.start = scanner.current;

        if (scanner.is_at_end())
            return scanner.make_token(.EOF);

        const ch = scanner.advance();

        if (is_alpha(ch))
            return scanner.identifier();
        if (is_digit(ch))
            return scanner.number();

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

            // Number and string tokens are special because they have a runtime value associated with them.
            '"' => return scanner.string(),

            else => return scanner.error_token("Unexpected character."),
        }
    }

    fn is_at_end(scanner: *Scanner) bool {
        return scanner.current == scanner.source.len;
        // return scanner.source[scanner.current] == 0;
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

    fn skip_whitespace(scanner: *Scanner) void {
        // could use std.ascii, but whatever
        while (true) {
            const ch = scanner.peek();
            switch (ch) {
                // common whitespace
                ' ', '\r', '\t' => _ = scanner.advance(),
                // newline, increment linenumber
                '\n' => {
                    scanner.line += 1;
                    _ = scanner.advance();
                },
                // comments
                '/' => {
                    if (scanner.peek_next() == '/') {
                        // A comment goes until the end of the line.
                        while (scanner.peek() != '\n' and !scanner.is_at_end())
                            _ = scanner.advance();
                    } else {
                        return;
                    }
                },
                else => return,
            }
        }
    }

    fn check_keyword(scanner: *Scanner, start: usize, length: usize, rest: z.string, token_type: TokenType) TokenType {
        if (scanner.current - scanner.start == start + length and std.mem.eql(u8, scanner.source[scanner.start .. scanner.start + start], rest))
            return token_type;

        return .IDENTIFIER;
    }

    fn identifier_type(scanner: *Scanner) TokenType {
        switch (scanner.source[scanner.start]) {
            'a' => return scanner.check_keyword(1, 2, "nd", .AND),
            'c' => return scanner.check_keyword(1, 4, "lass", .CLASS),
            'e' => return scanner.check_keyword(1, 3, "lse", .ELSE),
            'f' => {
                if (scanner.current - scanner.start > 1) {
                    switch (scanner.source[scanner.start + 1]) {
                        'a' => return scanner.check_keyword(2, 3, "lse", .FALSE),
                        'o' => return scanner.check_keyword(2, 1, "r", .FOR),
                        'u' => return scanner.check_keyword(2, 1, "n", .FUN),
                        else => {}, // ?
                    }
                }
            },

            'i' => return scanner.check_keyword(1, 1, "f", .IF),
            'n' => return scanner.check_keyword(1, 2, "il", .NIL),
            'o' => return scanner.check_keyword(1, 1, "r", .OR),
            'p' => return scanner.check_keyword(1, 4, "rint", .PRINT),
            'r' => return scanner.check_keyword(1, 5, "eturn", .RETURN),
            's' => return scanner.check_keyword(1, 4, "uper", .SUPER),
            't' => {
                if (scanner.current - scanner.start > 1) {
                    switch (scanner.source[scanner.start + 1]) {
                        'h' => return scanner.check_keyword(2, 2, "is", .THIS),
                        'r' => return scanner.check_keyword(2, 2, "ue", .TRUE),
                        else => {},
                    }
                }
            },
            'v' => return scanner.check_keyword(1, 2, "ar", .VAR),
            'w' => return scanner.check_keyword(1, 4, "hile", .WHILE),
            else => return .IDENTIFIER,
        }

        return .IDENTIFIER;
    }

    fn identifier(scanner: *Scanner) Token {
        while (is_alpha(scanner.peek()) or is_digit(scanner.peek()))
            _ = scanner.advance();

        return scanner.make_token(scanner.identifier_type());
    }

    fn number(scanner: *Scanner) Token {
        while (is_digit(scanner.peek()))
            _ = scanner.advance();

        if (scanner.peek() == '.' and is_digit(scanner.peek_next())) {
            // Consume the ".".
            _ = scanner.advance();

            // consume rest
            while (is_digit(scanner.peek()))
                _ = scanner.advance();
        }

        return scanner.make_token(.NUMBER);
    }

    fn string(scanner: *Scanner) Token {
        while (scanner.peek() != '"' and !scanner.is_at_end()) {
            if (scanner.peek() == '\n')
                scanner.line += 1;
            _ = scanner.advance();
        }

        if (scanner.is_at_end())
            return scanner.error_token("Unterminated string.");

        // The closing quote.
        _ = scanner.advance();
        return scanner.make_token(.STRING);
    }

    fn advance(scanner: *Scanner) u8 {
        defer scanner.current += 1;
        return scanner.source[scanner.current];
    }

    fn peek(scanner: *Scanner) u8 {
        // book doesnt say this, but I think peek has to check if is at end, gives me index error otherwise.
        if (scanner.is_at_end())
            return 0;
        return scanner.source[scanner.current];
    }

    fn peek_next(scanner: *Scanner) u8 {
        if (scanner.is_at_end())
            return 0;
        return scanner.source[scanner.current + 1];
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
