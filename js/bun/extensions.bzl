load("//js/private/bun:toolchains.bzl", "register_bun_toolchains")

_ATTRS = {
    "name": attr.string(
        doc = "Base name for generated bun repositories",
        default = "bun",
    ),
}

def _bun_toolchain_extension(module_ctx):
    toolchains = {}
    for mod in module_ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name not in toolchains:
                toolchains[toolchain.name] = toolchain

    for k in toolchains.keys():
        register_bun_toolchains(
            base_name = k,
        )

bun = module_extension(
    implementation = _bun_toolchain_extension,
    tag_classes = {
        "toolchain": tag_class(attrs = _ATTRS),
    },
)
