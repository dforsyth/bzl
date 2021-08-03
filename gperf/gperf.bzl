def _gperf_impl(ctx):
    outputs = []
    for f in ctx.files.srcs:
        outp = "{}.{}".format(f.basename, ctx.attr.suffix)
        out = ctx.actions.declare_file(outp)
        ctx.actions.run_shell(
            command = "gperf --output-file={} {}".format(out.path, f.path),
            outputs = [out],
            inputs = depset([f]),
        )
        outputs.append(out)
    return [CcInfo(
        compilation_context = cc_common.create_compilation_context(
            headers = depset(outputs),
        ),
    )]

gperf = rule(
    implementation = _gperf_impl,
    output_to_genfiles = True,
    attrs = {
        "srcs": attr.label_list(allow_files = [".gperf"]),
        "suffix": attr.string(default = "out"),
    },
)
