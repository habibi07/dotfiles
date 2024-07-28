import importlib
import json

THEME_NAME = 'SystemTheme'
THEME = getattr(importlib.import_module(f'colors'), THEME_NAME)
THEME_MODE = 'normal'
SCREENS_CONFIG_FILE = '/home/habibi/.config/qtile/screens.json'
BROWSER = 'brave'
EDITOR = 'nvim'
MARGIN_DEFAULT = 20
MARGIN_STEP = 5
BAR_SIZE = 32

FONT = 'JetBrainsMono Nerd Font'
FONT_SIZE = 12

'''
{
    "wallpaper": "/home/habibi/.config/wallpapers/0176.jpg",
    "alpha": "100",
    "special": {
        "background": "#1f1b1f",
        "foreground": "#cfb1c2",
        "cursor": "#cfb1c2"
    },
    "colors": {
        "color0": "#1f1b1f",
        "color1": "#B74150",
        "color2": "#3D4C84",
        "color3": "#49558B",
        "color4": "#546594",
        "color5": "#5A6BA5",
        "color6": "#677DC2",
        "color7": "#cfb1c2",
        "color8": "#907b87",
        "color9": "#B74150",
        "color10": "#3D4C84",
        "color11": "#49558B",
        "color12": "#546594",
        "color13": "#5A6BA5",
        "color14": "#677DC2",
        "color15": "#cfb1c2"
    },
    "normal": [
        "#1f1b1f",
        "#B74150",
        "#3D4C84",
        "#49558B",
        "#546594",
        "#5A6BA5",
        "#677DC2",
        "#cfb1c2"
    ],
    "bright": [
        "#907b87",
        "#B74150",
        "#3D4C84",
        "#49558B",
        "#546594",
        "#5A6BA5",
        "#677DC2",
        "#cfb1c2"
    ]
}
'''
def get_nth_color(n):
    return THEME[THEME_MODE][n]

BG = THEME['special']['background']
FG = THEME['special']['foreground']
LAYOUT_DEFAULTS = {
    'margin': MARGIN_DEFAULT,
    'border_focus': get_nth_color(0)
}
USE_TRANSPARENT_BAR = False

# background="#00000000" - transparent bar color
# background=["#000000", "#FFFFFF"] - gradient 
# BAR_BACKGROUND = [get_nth_color(3), get_nth_color(5)]
BAR_BACKGROUND = BG
BAR_DEFAULTS = {
    'background': "#00000060" if USE_TRANSPARENT_BAR else BAR_BACKGROUND, # gdy podana jest lista kolorow wowczas rysowany jest gradient
    'border_color': '#000000', # [N E S W]
    'border_width': 0, # [N E S W]
    'margin': 0, # [N E S W]
    'opacity': 1,
    'reserve': True # czy bar ma byc rysowany pod oknami
}

WIDGET_DEFAULTS = dict(
    font=FONT,
    fontsize=FONT_SIZE,
    padding=3,
)


VOLUME_STEP = 5
VOLUME_DOWN_COMMAND = f"pactl set-sink-volume @DEFAULT_SINK@ -{VOLUME_STEP}%"
VOLUME_UP_COMMAND = f"pactl set-sink-volume @DEFAULT_SINK@ +{VOLUME_STEP}%"
VOLUME_MUTE_COMMAND = "pactl set-sink-volume @DEFAULT_SINK@ 0%"

