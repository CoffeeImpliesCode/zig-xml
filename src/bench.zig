const std = @import("std");
const string = []const u8;
const xml = @import("root.zig");

pub const std_options = .{
    .log_level = .info,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    if (std.os.argv.len < 2) {
        std.log.err("Benchmark needs a path to an XML file as argument.", .{});
        return;
    }
    const path = std.mem.sliceTo(std.os.argv[1], 0);
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    var timer = try std.time.Timer.start();
    var doc = try xml.parse(gpa.allocator(), path, file.reader());
    defer doc.deinit();
    std.log.info("{s}: {d}μs", .{ path, timer.read() / std.time.ns_per_us });
}
