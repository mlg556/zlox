const std = @import("std");

pub const Value = i32;
pub const Values = std.ArrayList(Value);

pub const ValueArray = struct {
    values: Values,

    pub fn init(alloc: std.mem.Allocator) ValueArray {
        return ValueArray{ .values = Values.init(alloc) };
    }

    pub fn write(self: *ValueArray, val: Value) !void {
        try self.values.append(val);
    }

    pub fn free(self: *ValueArray) void {
        self.values.deinit();
    }
};
