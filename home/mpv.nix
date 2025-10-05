{ config, pkgs, ...}:
{
  programs.mpv = {
    enable = true;
    
    config = {
      screenshot-directory = "~/Pictures/mpv-screenshots";
      save-position-on-quit = true;
      cache = true;
      demuxer-max-bytes = "512MiB";
      audio-channels = "stereo";
    };

    bindings = {
      "T" = "add sub-pos -1";
      "r" = "cycle_values video-rotate 90 180 270 0";
      
      "+" = "add video-zoom +0.25";
      "-" = "add video-zoom -0.25";
      "Ctrl++" = "add video-zoom +0.1";
      "Ctrl+-" = "add video-zoom -0.1";
      "Ctrl+?" = "add video-zoom +0.01";
      "Ctrl+_" = "add video-zoom -0.01";
      "Ctrl+0" = "set video-zoom 0";
      
      "Alt+Shift+left" = "add video-pan-x  0.01";
      "Alt+Shift+right" = "add video-pan-x -0.01";
      "Alt+Shift+up" = "add video-pan-y  0.01";
      "Alt+Shift+down" = "add video-pan-y -0.01";
    };
  };

  home.packages = [ pkgs.yt-dlp ];
}
