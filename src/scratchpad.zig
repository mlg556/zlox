const std = @import("std");

pub fn doubler(a: isize) isize {
    return a * 2;
}

pub fn func(a: isize) isize {
    return doubler(if (a > 2) 3 else 2);
}

pub fn main() !void {
    std.debug.print("{d}", .{func(10)});
}
