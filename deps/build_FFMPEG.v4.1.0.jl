using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = true
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    ExecutableProduct(prefix, "ffmpeg", :ffmpeg),
    ExecutableProduct(prefix, "ffprobe", :ffprobe),
    ExecutableProduct(prefix, "x264", :x264),
    ExecutableProduct(prefix, "x265", :x265),
    LibraryProduct(prefix, ["libavcodec","avcodec"], :libavcodec),
    LibraryProduct(prefix, ["libavformat","avformat"], :libavformat),
    LibraryProduct(prefix, ["libavutil","avutil"], :libavutil),
    LibraryProduct(prefix, ["libswscale","swscale"], :libswscale),
    LibraryProduct(prefix, ["libavfilter","avfilter"], :libavfilter),
    LibraryProduct(prefix, ["libpostproc", "postproc"], :libpostproc),
    LibraryProduct(prefix, ["libswresample", "swresample"], :libswresample),
    LibraryProduct(prefix, ["libavresample", "avresample"], :libavresample),
    LibraryProduct(prefix, ["libavdevice","avdevice"], :libavdevice),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/giordano/FFMPEGBuilder/releases/download/fix-windows"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Windows(:i686) => ("$bin_prefix/FFMPEG.v4.1.0.i686-w64-mingw32.tar.gz", "5d466674f17cccb44b883aa74f71b3233005e12b4eb3a64f38506c1bc88a8966"),
    Windows(:x86_64) => ("$bin_prefix/FFMPEG.v4.1.0.x86_64-w64-mingw32.tar.gz", "f0be0f6e0ee4b6491953e76f0288300d513e6852245bfd64eb5d49382b6ab942"),
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
