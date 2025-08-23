load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_DEFAULT_BUN_VERSION = "1.2.20"

BunInfo = provider(fields = {
    "bun": "The label pointing to the bun executable",
})

_BUN_PLATFORMS = {
    ("darwin", "arm64", None): {
        "filename": "bun-darwin-aarch64.zip",
        "strip_prefix": "bun-darwin-aarch64",
        "sha256": "404f5a6dd1f604b40eb3b156d4197bb8d398bb26e0ae4c8ac8e7aa490f7e235f",
    },
    ("darwin", "x86_64", None): {
        "filename": "bun-darwin-x64.zip",
        "strip_prefix": "bun-darwin-x64",
        "sha256": "e1cc2f4b8e4d4172dde107982db42a22f8c5c8d8bb26078c23285704a4b72cd6",
    },
    ("linux", "arm64", "glibc"): {
        "filename": "bun-linux-aarch64.zip",
        "strip_prefix": "bun-linux-aarch64",
        "sha256": "98d2e0b2c09421569172b4d46b6f81378c2dbdd77480ebb27f3989dd4e72e18b",
    },
    ("linux", "x86_64", "glibc"): {
        "filename": "bun-linux-x64.zip",
        "strip_prefix": "bun-linux-x64",
        "sha256": "4e9edc4cba0c7c1623a288be01e53bbde11a4d073f2cf339cab026627858b548",
    },
    ("windows", "x86_64", None): {
        "filename": "bun-windows-x64.zip",
        "strip_prefix": "bun-windows-x64",
        "sha256": "2fb89f7a0593f43e8bc8c40f5ab887488916c4ce45e75b7dc5fc098d84a8d56c",
    },
}

def register_bun_toolchains(base_name):
    """Register the default Bun toolchains for all supported platforms.

    """
    for platform_triple, config in _BUN_PLATFORMS.items():
        os, cpu, libc = platform_triple
        http_archive(
            name = "{}_{}_{}_{}".format(base_name, os, cpu, libc) if os == "linux" else "{}_{}_{}".format(base_name, os, cpu),
            url = "https://github.com/oven-sh/bun/releases/download/bun-v{}/{}".format(
                _DEFAULT_BUN_VERSION,
                config["filename"],
            ),
            strip_prefix = config["strip_prefix"],
            sha256 = config["sha256"],
            build_file_content = """
load("@bazel_skylib//rules:native_binary.bzl", "native_binary")
load("@aspect_rules_js//js/bun:defs.bzl", "bun_toolchain")

exports_files(["bun"])

native_binary(
    name = "bun_bin",
    src = "bun.exe" if "{os}" == "windows" else "bun",
    out = "bun.exe" if "{os}" == "windows" else "bun",
    visibility = ["//visibility:public"],
)

bun_toolchain(
    name = "bun_toolchain_{os}_{cpu}",
    bun = ":bun_bin",
    visibility = ["//visibility:public"],
)

toolchain(
    name = "toolchain",
    toolchain = ":bun_toolchain_{os}_{cpu}",
    exec_compatible_with = [
        "@platforms//os:macos" if "{os}" == "darwin" else "@platforms//os:{os}",
        "@platforms//cpu:{cpu}",
    ],
    toolchain_type = "@aspect_rules_js//js/bun:toolchain_type",
)
""".format(os = os, cpu = cpu),
        )

def _bun_toolchain_impl(ctx):
    return [
        DefaultInfo(
            files = depset([ctx.executable.bun]),
        ),
        platform_common.ToolchainInfo(
            buninfo = BunInfo(
                bun = ctx.executable.bun,
            ),
        ),
    ]

bun_toolchain = rule(
    implementation = _bun_toolchain_impl,
    attrs = {
        "bun": attr.label(
            doc = "The label pointing to the bun executable for this toolchain",
            executable = True,
            mandatory = True,
            cfg = "exec",
        ),
    },
)
