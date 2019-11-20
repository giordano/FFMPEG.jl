using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    ExecutableProduct(prefix, "x264", :x264),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaBinaryWrappers/x264_jll.jl/releases/download/x264-v2019.5.25+0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/x264.v2019.5.25.aarch64-linux-gnu.tar.gz", "fbdef1044d0b42b27a988f6ebe7c0bf465149f3db1b03987ba540f6810162444"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/x264.v2019.5.25.aarch64-linux-musl.tar.gz", "0ba49014df7c1b4e41a1e19c7d66a193537b87d8c80a8f876adcc2cd7ecc6212"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/x264.v2019.5.25.arm-linux-gnueabihf.tar.gz", "0642262f5eed98302f663d2c006597ee8111a76deae767d7ecea6010239decbe"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/x264.v2019.5.25.arm-linux-musleabihf.tar.gz", "df6cbb41e1825c8edff8bda42e07a449c195a48084fdc0c2c47f157d74b04d86"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/x264.v2019.5.25.i686-linux-gnu.tar.gz", "92bec7f9796014d55e93d861bf7846707888ca33c61de0dfb7fa4b698298fdd2"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/x264.v2019.5.25.i686-linux-musl.tar.gz", "ada21f7b051c04d711c43a414851ff59e06caadf0ba2569b45a5d9ee5a4cf2c0"),
    Windows(:i686) => ("$bin_prefix/x264.v2019.5.25.i686-w64-mingw32.tar.gz", "7c402cde586c777061ac7781b993dbe62f8d5303dc5af76bbbfa0751546ab1aa"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/x264.v2019.5.25.powerpc64le-linux-gnu.tar.gz", "b3a5889ec2ad5bd5cc3ee0acb07994e383bb770943ab91653ea0b6802a278adb"),
    MacOS(:x86_64) => ("$bin_prefix/x264.v2019.5.25.x86_64-apple-darwin14.tar.gz", "73ae8223ed88f7fa82d1f2b8725cfeb844ebc9e5b12a770f562ba5ea42677a3c"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/x264.v2019.5.25.x86_64-linux-gnu.tar.gz", "e86444bb0e0b76f97da892a46790ded4139cb57d04c6fa854184e441678e3509"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/x264.v2019.5.25.x86_64-linux-musl.tar.gz", "afcab34bf46d7bd61a2bddc0182f40ff0a977b5fa049b79b916e0db54ce0a62a"),
    FreeBSD(:x86_64) => ("$bin_prefix/x264.v2019.5.25.x86_64-unknown-freebsd11.1.tar.gz", "ac13642480a6637b7046c183e5c83aece920be703a7cb7c0b70a73d9b07b1425"),
    Windows(:x86_64) => ("$bin_prefix/x264.v2019.5.25.x86_64-w64-mingw32.tar.gz", "c6aa645dbfcf11cbc498c8551174fb1170ba6e37d842fb7546a188d86dd59e55"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
