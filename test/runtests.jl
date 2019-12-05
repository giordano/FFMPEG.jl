# using FFMPEG
using FFMPEG_jll
using Test

@show FFMPEG_jll.PATH_list
@show FFMPEG_jll.LIBPATH_list

# function myffmpeg(f::Function; adjust_PATH::Bool = true, adjust_LIBPATH::Bool = true)
#     env_mapping = Dict{String,String}()
#     if adjust_PATH
#         if !isempty(get(ENV, "PATH", ""))
#             env_mapping["PATH"] = string(FFMPEG_jll.PATH, ';', ENV["PATH"])
#         else
#             env_mapping["PATH"] = FFMPEG_jll.PATH
#         end
#     end
#     if adjust_LIBPATH
#         if !isempty(get(ENV, FFMPEG_jll.LIBPATH_env, ""))
#             env_mapping[FFMPEG_jll.LIBPATH_env] = string(FFMPEG_jll.LIBPATH, ';', ENV[FFMPEG_jll.LIBPATH_env])
#         else
#             env_mapping[FFMPEG_jll.LIBPATH_env] = FFMPEG_jll.LIBPATH
#         end
#     end
#     withenv(env_mapping...) do
#         f(FFMPEG_jll.ffmpeg_path)
#     end
# end

ffmpeg() do ffmpeg_path
    run(`$ffmpeg_path -version`)
end

# text_execute(f) = try
#     f()
#     return true
# catch e
#     @warn "can't execute" exception=e
#     return false
# end

# @testset "FFMPEG.jl" begin
#     FFMPEG.versioninfo()
    
#     # Test run and parse output
#     out = FFMPEG.exe(`-version`, collect=true)
#     @test occursin("ffmpeg version ",out[1])
    
#     out = FFMPEG.exe(`-version`, command=FFMPEG.ffprobe, collect=true)
#     @test occursin("ffprobe version ",out[1])
    
#     # Test different invokation methods
#     @test text_execute(() -> FFMPEG.exe("-version"))
#     @test text_execute(() -> FFMPEG.exe(`-version`))
#     @test text_execute(() -> FFMPEG.exe(`-version`, collect=true))
#     @test text_execute(() -> FFMPEG.ffmpeg_exe(`-version`))
#     @test text_execute(() -> FFMPEG.ffprobe_exe(`-version`))
#     @test text_execute(() -> ffmpeg`-version`)
#     @test text_execute(() -> ffprobe`-version`)
#     @test text_execute(() -> @ffmpeg_env run(`$(FFMPEG.ffmpeg_path) -version`))
# end
