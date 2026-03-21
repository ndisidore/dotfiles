# Media streaming functions

# Stream Twitch live channels or VODs through mpv via its built-in yt-dlp integration
#
# Usage:
#   twitch <channel>             # Live stream by channel name
#   twitch <vod-id>              # VOD by numeric ID (auto-detected)
#   twitch --vod <vod-id>        # VOD explicitly
#   twitch <full-url>            # Any full twitch.tv URL
#   twitch -q 480p <channel>     # With quality selection
#
# Quality options: best (default), 720p60, 480p, 360p, 160p, audio_only
function twitch --description "Stream Twitch live channels or VODs through mpv"
    argparse 'v/vod' 'q/quality=' -- $argv
    or return 1

    if test (count $argv) -eq 0
        echo "Usage: twitch [--vod] [-q QUALITY] <channel|vod-id|url>"
        echo ""
        echo "Examples:"
        echo "  twitch kitboga                       # Watch live stream"
        echo "  twitch --vod 2720492584              # Watch VOD by ID"
        echo "  twitch 2720492584                    # VOD auto-detected (numeric ID)"
        echo "  twitch https://twitch.tv/kitboga     # Full URL"
        echo "  twitch -q 480p kitboga               # With quality selection"
        echo ""
        echo "Quality options: best (default), 720p60, 480p, 360p, 160p, audio_only"
        return 0
    end

    set -l input $argv[1]
    set -l ytdl_url

    # Resolve ytdl:// URL from input
    if string match -qr '^https?://' $input
        # Full URL: strip scheme so mpv uses its ytdl hook
        set ytdl_url "ytdl://"(string replace -r 'https?://' '' $input)
    else if set -q _flag_vod; or string match -qr '^\d+$' $input
        # Explicit --vod flag or numeric ID auto-detection
        set ytdl_url "ytdl://twitch.tv/videos/$input"
    else
        # Channel name
        set ytdl_url "ytdl://twitch.tv/$input"
    end

    # Build mpv args
    set -l mpv_args --really-quiet --no-audio-display --hwdec=auto
    if set -q _flag_quality
        set -a mpv_args --ytdl-format=$_flag_quality
    end

    # Live-stream optimizations: reduce buffering, disable useless backward seek buffer
    if not set -q _flag_vod; and not string match -qr '^\d+$' $input; and not string match -qr '^https?://.*/videos/' $input
        set -a mpv_args --video-latency-hacks=yes --demuxer-max-back-bytes=0
    end

    mpv $mpv_args $ytdl_url
end
