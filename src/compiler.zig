const std = @import("std");
const z = @import("zlox.zig");

pub const Parser = struct {
    scanner: z.Scanner,
    chunk: *z.Chunk,
    current: z.Token,
    previous: z.Token,
    had_error: bool = false,
    panic_mode: bool = false,

    pub fn advance(parser: *Parser) void {
        parser.previous = parser.current;

        while (true) {
            parser.current = parser.scanner.scan_token();
            if (parser.current.token_type != .ERROR)
                break;

            parser.error_at_current(parser.current.value);
        }
    }

    pub fn error_at_current(parser: *Parser, message: z.string) void {
        parser.error_at(&parser.current, message);
    }

    pub fn err(parser: *Parser, message: z.string) void {
        parser.error_at(&parser.previous, message);
    }

    pub fn error_at(parser: *Parser, token: *z.Token, message: z.string) void {
        if (parser.panicMode) return;

        parser.panic_mode = true;
        z.print("ERR: [line {d}] Error", .{token.line});

        switch (token.token_type) {
            .EOF => {
                z.print(" at end", .{});
            },
            .ERROR => {},
            else => {
                z.print(" at '{s}'", .{token.value});
            },
        }

        z.print(": {s}\n", .{message});
        parser.had_error = true;
    }

    pub fn expression(parser: *Parser) void {
        _ = parser;
    }

    pub fn consume(parser: *Parser, token_type: z.TokenType, message: z.string) void {
        if (parser.current.token_type == token_type) {
            parser.advance();
            return;
        }

        parser.error_at_current(message);
    }

    pub fn emit_byte(parser: *Parser, byte: u8) void {
        parser.current_chunk().write(byte, parser.previous.line);
    }

    pub fn emit_bytes(parser: *Parser, byte1: u8, byte2: u8) void {
        parser.emit_byte(byte1);
        parser.emit_byte(byte2);
    }

    pub fn end_compiler(parser: *Parser) void {
        parser.emit_return();
    }

    pub fn emit_return(parser: *Parser) void {
        parser.emit_byte(@intFromEnum(z.OpCode.OP_RETURN));
    }

    // idk why this exists really
    pub fn current_chunk(parser: *Parser) *z.Chunk {
        return parser.chunk;
    }
};

pub fn compile(source: z.string, chunk: *z.Chunk) bool {
    const scanner = z.Scanner.init(source);
    // hmm idk if parser should hold scanner, but it is what it is
    var parser = Parser{
        .scanner = scanner,
        .chunk = chunk,
        .current = undefined,
        .previous = undefined,
    };

    parser.advance();
    parser.expression();
    parser.consume(.EOF, "Expect end of expression.");

    parser.end_compiler();

    return !parser.had_error;
}
