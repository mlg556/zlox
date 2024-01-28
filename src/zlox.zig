const std = @import("std");

pub const DEBUG_TRACE_EXECUTION = false;

pub const string = []const u8;
pub const print = std.debug.print;

pub const chunk = @import("chunk.zig");
pub const debug = @import("debug.zig");
pub const value = @import("value.zig");
pub const vm = @import("vm.zig");

// export

pub const Chunk = chunk.Chunk;
pub const Code = chunk.Code;
pub const OpCode = chunk.OpCode;

pub const disassembleChunk = debug.disassembleChunk;
pub const disassembleInstruction = debug.disassembleInstruction;

pub const Value = value.Value;
pub const Values = value.Values;
pub const ValueArray = value.ValueArray;
pub const printValue = value.printValue;

pub const VM = vm.VM;
