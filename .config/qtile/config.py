import os
import subprocess

from libqtile import bar, layout, qtile, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal, send_notification
from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration

from constants import (
    BROWSER,
    VOLUME_DOWN_COMMAND,
    VOLUME_UP_COMMAND,
    VOLUME_MUTE_COMMAND,
    LAYOUT_DEFAULTS,
    BAR_SIZE,
    BAR_DEFAULTS,
    WIDGET_DEFAULTS,
    BG,
    FG,
    FONT_SIZE,
    get_nth_color
)
from screen import get_display_info, setup_screens
from popup import show_power_menu

# TODO: save theme 
# TODO: load theme

mod = "mod4"
terminal = "alacritty"
display_info = get_display_info()

@lazy.function
def screens_setup(_):
    setup_screens(recreate=True)
    send_notification("tytul", "skonfigurowano screeny", False, timeout=2)

@lazy.function
def start_vpn(_):
    qtile.groups_map['0-9'].toscreen()
    qtile.spawn("alacritty -e /home/habibi/.config/bin/start_vpn")


def volume_up(*args, **kwargs):
    qtile.spawn(VOLUME_UP_COMMAND)

def volume_down(*args, **kwargs):
    qtile.spawn(VOLUME_DOWN_COMMAND)

def volume_mute(*args, **kwargs):
    qtile.spawn(VOLUME_MUTE_COMMAND)

@lazy.function
def increase_gap(_):
    qtile.current_layout.margin += 5
    qtile.current_group.layout_all()

@lazy.function
def decrease_gap(_):
    qtile.current_layout.margin -= 5
    qtile.current_group.layout_all()
    if qtile.current_layout.margin < 0:
        send_notification('Marginesy', 'Uwaga: margines okien poniżej zera')

@lazy.function
def move_to_screen(_):
    dest_screen = 0 if qtile.current_screen.index == 1 else 1
    current_group = qtile.current_group.label
    dest_group = f'{dest_screen}-{current_group}'
    qtile.current_window.togroup(dest_group)
    qtile.to_screen(dest_screen)

@lazy.function
def go_to_screen(_):
    qtile.next_screen()

@lazy.function
def go_to_repo(_):
    qtile.spawn( os.environ['HOME'] + '/.config/bin/go_to_repo')

@lazy.function
def run_ssh(_):
    qtile.spawn('rofi -show ssh')

@lazy.function
def run_menu(_):
    qtile.spawn('rofi -show run')

keys = [
    # moving focus
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # moving windows
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # growing windows
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "space", lazy.next_layout(), desc="Next layout"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.group.next_window(), desc="Next window"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "w", lazy.spawn(BROWSER), desc="Launch browser"),
    Key([mod], "b", lazy.spawn("dbeaver"), desc="DBeaver"),
    Key([mod], "v", start_vpn, desc="Start vpn"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod, "shift"],
        "s",
        lazy.spawn(
            "scrot -s '%Y-%m-%d_$wx$h.png' -e 'mv $f /tmp/shot.png && xclip -selection clipboard -t image/png -i /tmp/shot.png && notify-send \"screenshot copied to clipboard\"'"
        ),
    ),
    # Key(
    #     [mod, "shift"],
    #     "f",
    #     lazy.spawn(
    #         f"scrot -s '%Y-%m-%d_$wx$h.png' -M {qtile.current_screen.index} -e 'mv $f /tmp/shot.png && xclip -selection clipboard -t image/png -i /tmp/shot.png && notify-send \"screenshot copied to clipboard\"'"
    #     ),
    # ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", run_menu, desc="Spawn a command using a prompt widget"),
    Key([mod], "s", run_ssh, desc="setup screens"),
    Key([mod], "d", screens_setup, desc="setup screens"),
    Key([mod, "shift"], "u", lazy.function(volume_up), desc="Volume down"),
    Key(
        [mod, "shift"],
        "d",
        lazy.function(volume_down),
        desc="Volume down",
    ),
    Key([mod], "u", increase_gap, desc="Increase layout gap"),
    Key([mod], "i", decrease_gap, desc="Decrease layout gap"),
    Key([mod, "shift"], "o", move_to_screen, desc="Move window to other screen"),
    Key([mod], "o", go_to_screen, desc="Go to screen"),
    Key([mod], "c", go_to_repo, desc="Go to repo"),
    Key([mod, "shift"], "q", lazy.function(show_power_menu)),
    KeyChord([mod], "a", [
        Key([mod], "t", lazy.spawn("/home/habibi/.config/bin/add_todo"))
    ])
]


# groups = [Group(i) for i in "123456789"]

groups = []
for screen_index in range(len(display_info)):
    for i in "123456789":
        groups.append(
            Group(name=f'{screen_index}-{i}', label=str(i))
        )

def go_to_group(group_index):
    @lazy.function
    def _go_to_function(_):
        screen_index = qtile.current_screen.index
        group_name = f'{screen_index}-{group_index}'
        qtile.groups_map[group_name].toscreen()
    return _go_to_function()

def move_to_group(group_index):
    @lazy.function
    def _move_to_function(_):
        screen_index = qtile.current_screen.index
        group_name = f'{screen_index}-{group_index}'
        qtile.current_window.togroup(group_name)
    return _move_to_function()

for group_index in "123456789":
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                group_index,
                go_to_group(group_index),
                desc="Switch to group {}".format(group_index),
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                group_index,
                move_to_group(group_index),
                desc="Switch to & move focused window to group {}".format(group_index),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(**LAYOUT_DEFAULTS),
    layout.Max(**LAYOUT_DEFAULTS),
    layout.Matrix(**LAYOUT_DEFAULTS),
    layout.MonadTall(**LAYOUT_DEFAULTS,ratio=.7),
    layout.MonadWide(**LAYOUT_DEFAULTS,ratio=.7),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.ScreenSplit(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# extension_defaults = widget_defaults.copy()

# right side decorations
right_decorations = {
    'decorations': [
        PowerLineDecoration(
            path= 'forward_slash',
            # padding_y = 2
            # padding_x = 15
        )
    ]
}

# left side decorations
left_decorations = {
    'decorations': [
        PowerLineDecoration(
            path= 'back_slash',
            # padding_x = 15
        )
    ]
}

class MouseOverClock(widget.Clock):
    defaults = [
        (
            "long_format",
            "%A %d %B %Y | %H:%M",
            "Format to show when mouse is over widget."
        )
    ]

    def __init__(self, **config):
        widget.Clock.__init__(self, **config)
        self.add_defaults(MouseOverClock.defaults)
        self.short_format = self.format

    def mouse_enter(self, *args, **kwargs):
        pass
        # self.format = self.long_format
        # self.bar.draw()

    def mouse_leave(self, *args, **kwargs):
        pass
        # self.format = self.short_format
        # send_notification('mouse over', 'leave')
        # self.bar.draw()

def create_widgets(index, screen_info):
    return [
        widget.Prompt(**WIDGET_DEFAULTS),
        widget.GroupBox(
            padding_x=10,
            background=get_nth_color(3),
            active=FG,
            rounded=False,
            highlight_method="line",
            # highlight_color=get_nth_color(1),
            highlight_color=get_nth_color(1),
            # inactive=get_nth_color(7),
            # **widget_defaults,
            fontsize=FONT_SIZE,
            this_current_screen_border=BG,
            this_screen_border=get_nth_color(3),
            other_current_screen_border=FG,
            other_screen_border=get_nth_color(3),
            visible_groups=[f'{index}-{i}' for i in "123456789"],
            **right_decorations,
        ),
        widget.WindowName(
            **WIDGET_DEFAULTS,
            **right_decorations,
            foreground=FG,
            max_chars=30,
            format='{name}'
        ),
        # widget.Volume(theme_path="/usr/share/icons/Papirus-Dark/16x16/panel"),
        # widget.Systray(),
        # widget.DF(
        #     partition='/',
        #     **WIDGET_DEFAULTS,
        #     **right_decorations,
        #     background=get_nth_color(3)
        # ),
        widget.CryptoTicker(
            **WIDGET_DEFAULTS,
            **right_decorations,
            crypto='ETH',
            format='{crypto}: {amount:.2f}{symbol}',
            background=get_nth_color(6)
        ),
        widget.Memory(
            **WIDGET_DEFAULTS,
            **right_decorations,
            measure_mem='G',
            format='Mem: {MemUsed:.0f}{mm}',
            background=get_nth_color(4)
        ),
        widget.CPU(
            **WIDGET_DEFAULTS,
            **right_decorations,
            format='CPU: {load_percent}%',
            background=get_nth_color(3)
        ),
        widget.NvidiaSensors(
            **WIDGET_DEFAULTS,
            **right_decorations,
            background=get_nth_color(3)
        ),
        widget.OpenWeather(
            location='Warsaw',
            **WIDGET_DEFAULTS,
            **right_decorations,
            format='{location_city}: {main_temp: .0f} °{units_temperature} {icon}',
            background=get_nth_color(2)
        ),
        MouseOverClock(
            **WIDGET_DEFAULTS, 
            format="%Y-%m-%d %a %I:%M %p",
            background=get_nth_color(3),
            **right_decorations
        ),
        widget.CurrentScreen(
            **WIDGET_DEFAULTS,
            **right_decorations,
        ),
        widget.CurrentLayoutIcon(
            # **WIDGET_DEFAULTS,
            **right_decorations,
            scale=.7,
            padding=7
        ),
        # widget.StatusNotifier(**WIDGET_DEFAULTS, **right_decorations),
        widget.BatteryIcon(
            background=get_nth_color(0),
            **WIDGET_DEFAULTS,
            **right_decorations
        ),
        widget.Volume(
            **WIDGET_DEFAULTS,
            **right_decorations,
            emoji=True,
            background=get_nth_color(0),
            step=5,
            # theme_path="/usr/share/icons/Qogir/16/panel"
            # padding=20,
            # update_interval=0.2,
            # fontsize=20,
            volume_app="pactl",
            check_mute_command=("pactl " "get-sink-mute " "@DEFAULT_SINK@"),
            get_volume_command=("pactl " "get-sink-volume " "@DEFAULT_SINK@"),
            mouse_callbacks={"Button1": volume_mute,"Button4": volume_up, "Button5": volume_down},
            volume_down_command=(VOLUME_DOWN_COMMAND),
            volume_up_command=(VOLUME_UP_COMMAND),
        ),
        widget.Image(
            filename="/usr/share/icons/Papirus-Dark/64x64/apps/system-shutdown.svg",
            mouse_callbacks = {
                'Button1': lazy.function(show_power_menu)
            }
        )
        # widget.QuickExit(
        #     background=BG,
        #     **WIDGET_DEFAULTS,
        # ),
    ]


def create_bar(index, screen_info):
    return bar.Bar(
        create_widgets(index, screen_info),
        BAR_SIZE,
        **BAR_DEFAULTS
    )

def create_screen(index, screen_info):
    return Screen(
        top=create_bar(index, screen_info)
    )

def create_screens():
    myscreens = []
    for index, screen_info in enumerate(display_info):
        myscreens.append(create_screen(index, screen_info))
    return myscreens

screens = create_screens()

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

@hook.subscribe.startup_once
def autostart():
    wallpaper = os.path.expanduser("/home/habibi/.config/bin/random_wallpaper")
    subprocess.Popen([wallpaper])
    keyboard = os.path.expanduser("/home/habibi/.config/bin/keyboard_setup")
    subprocess.Popen([keyboard])
    picom = os.path.expanduser("/home/habibi/.config/bin/start_picom")
    subprocess.Popen([picom])


dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
