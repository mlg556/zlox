const std = @import("std");
const z = @import("zlox.zig");

pub const Parser = struct {
    current: z.Token,
    previous: z.Token,

    pub fn advance(p: *Parser) void {
        _ = p;
    }

    pub fn expression(p: *Parser) void {
        _ = p;
    }

    pub fn consume(p: *Parser, token_type: z.TokenType, message: z.string) void {
        _ = token_type; // autofix
        _ = message; // autofix
        _ = p;
    }
};

pub fn compile(source: z.string, chunk: *z.Chunk) bool {
    _ = chunk; // autofix
    var scanner = z.Scanner.init(source);
    _ = scanner; // autofix
    var parser = Parser{
        .current = undefined,
        .previous = undefined,
    };

    parser.advance();
    parser.expression();
    parser.consume(.EOF, "Expect end of expression.");
}
