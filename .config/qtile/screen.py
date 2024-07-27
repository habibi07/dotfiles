import subprocess
import os
import json
from pathlib import Path
from Xlib import display
from Xlib.ext import randr
from constants import SCREENS_CONFIG_FILE

direction_map = {
    'Lewo': '--left-of',
    'Prawo': '--right-of',
    'Gora': '--above',
    'Dol': '--below'
}

def find_mode(id, modes):
   for mode in modes:
       if id == mode.id:
           return "{}x{}".format(mode.width, mode.height)

def get_current_screens_size():
    command = 'xrandr --listmonitors | tail -n +2'
    output = subprocess.Popen(command,shell=True, stdout=subprocess.PIPE).communicate()[0]
    resp = {}
    for line in output.decode().rstrip().split('\n'):
        splitted = line.split(' ')
        name = splitted[-1]
        resolution = splitted[3]
        resolution_splitted = resolution.split('/')
        width = resolution_splitted[0]
        height = resolution_splitted[1].split('x')[1]
        resp[name] = [width, height]
    return resp

def get_display_info():
    d = display.Display(':0')
    d.sync()
    screen_count = d.screen_count()
    default_screen = d.get_default_screen()
    result = []
    screen = 0
    info = d.screen(screen)
    window = info.root

    res = randr.get_screen_resources(window)
    for output in res.outputs:
        params = d.xrandr_get_output_info(output, res.config_timestamp)
        if not params.crtc:
           continue
        crtc = d.xrandr_get_crtc_info(params.crtc, res.config_timestamp)
        modes = []
        for mode in set(params.modes):
            found_mode = find_mode(mode, res.modes)
            if found_mode:
                splitted = found_mode.split('x')
                x, y = int(splitted[0]), int(splitted[1])
                if x > 1000 and y > 1000:
                    modes.append({'x': x, 'y': y, 'text': f'{x}x{y}'})
        if params.connection == 0:
            result.append({
                'name': params.name,
                'width': crtc.width,
                'height': crtc.height,
                'available_resolutions': sorted(modes, key=lambda mode: mode['x'], reverse=True)
            })

    return result

# def get_current_screens_config():
#     if Path(SCREENS_CONFIG_FILE).exists():
#         return json.load(open(SCREENS_CONFIG_FILE, 'r'))

def get_rofi_part_cmd(title):
    font = "JetBrainsMono Nerd Font"
    rofi_params = f'-fn "{font}:style=Normal:pixelsize=20" -l 8 -dim 2'
    return f'" | rofi -dmenu -p "{title}" {rofi_params}'

def get_rofi_options_cmd(options: list) -> str:
    return 'echo "' + '\n'.join(options)

def get_rofi_cmd(title: str, options: list) -> str:
    return get_rofi_options_cmd(options) + get_rofi_part_cmd(title)

def shell_cmd_with_output(cmd):
    return subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE).stdout.read().decode().strip()

def run_rofi_in_shell(title: str, options: list) -> str:
    cmd = get_rofi_cmd(title, options)
    return shell_cmd_with_output(cmd)

def dump_config(config):
    json.dump(config, open(SCREENS_CONFIG_FILE, 'w'))

def screens_questions():
    display_info = get_display_info()
    user_resp = {}
    is_primary_selected = False
    for display in display_info:
        name = display['name']
        resolutions = sorted(set(elem['text'] for elem in display['available_resolutions']), reverse=True)
        resp = run_rofi_in_shell(name, resolutions)
        if resp:
            user_resp[name] = {
                'resolution': resp,
                'primary': False
            }
            if not is_primary_selected:
                if len(display_info) > 1:
                    primary_selection = run_rofi_in_shell('Czy jest to ekran główny ?', ['Tak', 'Nie'])
                else:
                    primary_selection = 'Tak'
                if primary_selection and primary_selection == 'Tak':
                    is_primary_selected = True
                    user_resp[name]['primary'] = True

            if not user_resp[name]['primary']:
                options = ['Lewo', 'Prawo', 'Gora', 'Dol']
                direction = run_rofi_in_shell('Wskaż kierunek od ekranu głównego: ', options)
                user_resp[name]['direction'] = direction

    if user_resp.keys():
        dump_config(user_resp)

def get_screns_config():
    if Path(SCREENS_CONFIG_FILE).exists():
        return json.load(open(SCREENS_CONFIG_FILE, 'r'))

def get_primary_screen_name():
    config = get_screns_config()
    primary = None

    if config:
        # poszukiwanie glownego ekranu
        if len(config.keys()) > 1:
            for k,v in config.items():
                if v['primary']:
                    return k
        else:
            return config.keys()[0]
    else:
        info = get_display_info()
        return info[0]['name']


def config_to_cmd():
    '''
    xrandr --output eDP-1-1 --primary --mode 1920x1080 --output HDMI-0 --right-of eDP-1-1 --mode 1920x1080
    tlumaczy konfiguracje screenow na polecenie xrandr
    '''
    if Path(SCREENS_CONFIG_FILE).exists():
        config = get_screns_config()
        cmd = ['xrandr']
        primary = None

        # poszukiwanie glownego ekranu
        if config and len(config.keys()) > 1:
            for k,v in config.items():
                if v['primary']:
                    primary=k
                    break

        for k,v in config.items():
            cmd.append(f'--output {k}')
            cmd.append(f'--mode {v["resolution"]}')

            # jesli tylko jeden monitor to ustaw jako glowny
            # w przeciwnym razie sprawdz czy jest glowny
            if v['primary'] or primary:
                cmd.append('--primary')

            direction = v.get('direction', None)
            # jesli jest pole direction i mamy wiecej niz jeden monitor
            # wtedy jest sens ustawiania kierunku
            if direction and primary:
                direction_flag = direction_map[direction]
                cmd.append(f'{direction_flag} {primary}')
            
        return ' '.join(cmd)

def setup_screens(recreate=False):
    if recreate:
        screens_questions()
    cmd = config_to_cmd()
    shell_cmd_with_output(cmd)


