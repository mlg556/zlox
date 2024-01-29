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
// I do believe we can still use indexes, so lets do that.
pub const Token = struct {
    token_type: TokenType,
    start: usize,
    length: isize,
    line: isize,
};

pub const Scanner = struct {
    source: z.string,
    start: usize,
    current: usize,
    line: usize,

    pub fn init(source: z.string) Scanner {
        return Scanner{ .source = source, .start = 0, .line = 1 };
    }

    pub fn scan_token(self: *Scanner) Token {
        self.start = self.current;

        if (self.is_at_end())
            return make_token(.EOF);

        return error_token("Unexpected character.");
    }

    fn is_at_end(self: *Scanner) bool {
        return self.source[self.current] == '0';
    }

    fn make_token(sc: *Scanner, typ: TokenType) Token {
        return Token{
            .token_type = typ,
            .start = sc.start,
            .length = sc.current - sc.start,
            .line = sc.line,
        };
    }

    fn error_token(sc: *Scanner, typ: TokenType) Token {
        return Token {
            .token_type = .ERROR,
            .start = 

        }
    }
};
