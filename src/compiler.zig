const std = @import("std");
const z = @import("zlox.zig");

pub fn compile(source: z.string) void {
    var scanner = z.Scanner.init(source);

    var line: isize = -1;

    while (true) {
        const token: z.Token = scanner.scan_token();

        if (token.line != line) {
            z.print("{d:0>4} ", .{line});
            line = token.line;
        } else {
            z.print("   | ", .{});
        }

        // That %.*s in the format string is a neat feature. Usually, you set the output precision—the number of characters to show—by placing a number inside the format string. Using * instead lets you pass the precision as an argument. So that printf() call prints the first token.length characters of the string at token.start. We need to limit the length like that because the lexeme points into the original source string and doesn’t have a terminator at the end.

        // printf("%2d '%.*s'\n", token.type, token.length, token.start);
        z.print("{s} '{s}'\n", .{ @tagName(token.token_type), token.value });

        if (token.token_type == .EOF) break;
    }
}
