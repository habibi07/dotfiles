import json
from pathlib import Path
'''
[[colors.indexed_colors]]
color = "0xff9e64"
index = 16

[[colors.indexed_colors]]
color = "0xdb4b4b"
index = 17

[colors.bright]
black = "0x414868"
blue = "0x7aa2f7"
cyan = "0x7dcfff"
green = "0x9ece6a"
magenta = "0xbb9af7"
red = "0xf7768e"
white = "0xc0caf5"
yellow = "0xe0af68"

[colors.normal]
black = "0x1D202F"
blue = "0x7aa2f7"
cyan = "0x7dcfff"
green = "0x9ece6a"
magenta = "0xbb9af7"
red = "0xf7768e"
white = "0xa9b1d6"
yellow = "0xe0af68"

[colors.primary]
background = "0x24283b"
foreground = "0xc0caf5"
'''
WAL_COLORS_PATH = '/home/habibi/.cache/wal/colors.json'
ALACRITTY_COLORS_PATH = '/home/habibi/.config/alacritty/colors.toml'

if Path(WAL_COLORS_PATH).exists():
    wal_colors = json.load(open(WAL_COLORS_PATH, 'r'))
    bg = wal_colors['special']['background']
    fg = wal_colors['special']['foreground']
    cursor = wal_colors['special']['cursor']

    alacritty_toml = f'''
[colors.primary]
background = "{bg}"
foreground = "{fg}"

[colors.cursor]
text = "{cursor}"
cursor = "{cursor}"

[colors.normal]
black = "{wal_colors['colors']['color0']}"
blue = "{wal_colors['colors']['color1']}"
cyan = "{wal_colors['colors']['color2']}"
green = "{wal_colors['colors']['color3']}"
magenta = "{wal_colors['colors']['color4']}"
red = "{wal_colors['colors']['color5']}"
white = "{wal_colors['colors']['color6']}"
yellow = "{wal_colors['colors']['color7']}"

[colors.bright]
black = "{wal_colors['colors']['color8']}"
blue = "{wal_colors['colors']['color9']}"
cyan = "{wal_colors['colors']['color10']}"
green = "{wal_colors['colors']['color11']}"
magenta = "{wal_colors['colors']['color12']}"
red = "{wal_colors['colors']['color13']}"
white = "{wal_colors['colors']['color14']}"
yellow = "{wal_colors['colors']['color15']}"


'''
    f = open(ALACRITTY_COLORS_PATH, 'w')
    f.write(alacritty_toml)
    f.close()



