local t = {
  manager = { "Manadżer okien", "Window manager" };
  screen = { "Ekran", "Screen" };
  tag = { "Tag", "Tag" };
  client = { "Okno", "Client" };
  programs = { "Programy", "Programs" };
  terminal = { "Terminal", "Terminal" };
  layout = { "Układ", "Layout" };
  show_help = { "Pokaż pomoc", "Show me help" };
  show_browser = { "Uruchom przeglądarkę", "Show browser" };
  show_menu = { "Pokaż menu", "Show menu" };
  focus_next_client = { "Następne okno", "Next client" };
  focus_prev_client = { "Poprzednie okno", "Previous client" };
  swap_next_client = { "Zamień z następnym oknem", "Swap next client" };
  swap_prev_client = { "Zamień z następnym oknem", "Swap previous client" };
  focus_next_screen = { "Następny ekran", "Next screen" };
  focus_prev_screen = { "Poprzedni ekran", "Previous screen" };
  jump_urgent = { "Idź do pilnego okna",  "Jump to urgent"};
  show_terminal = { "Pokaż terminal",  "Show terminal"};
  reload = { "Reload awesome", "Reload awesome" };
  quit = { "Zamknij",  "Quit awesome"};
  increase_master_width = { "Zwiększ szerokość mastera",  "Increase master width factor"};
  decrease_master_width = { "Zmniejsz szerokość mastera",  "Decrease master width factor"};
  increase_masters = { "Zwiększ liczbę masterów",  "increase the number of master clients"};
  decrease_masters = { "Zwiększ liczbę masterów",  "decrease the number of master clients"};
  inc_columns = { "Zwiększ liczbę kolumn",  "increase the number of columns"};
  dec_columns = { "Zmniejsz liczbę kolumn",  "decrease the number of columns"};
  next_layout = { "Następny layout",  "Next layout"};
  prev_layout = { "Poprzedni layout",  "Previous layout"};
  restore_minimized = { "Przywróć zminimalizowane okno",  "Restore minimized"};
  run_prompt = { "Wykonaj polecenie",  "Run prompt"};
  launcher = { "Launcher", "Launcher" };
  prompt_text = { "Wykonaj: ",  "Run: "};
  run_lua_code = { "Wykonaj kod lua",  "Run lua code"};
  run_lua_code_text = { "Wykonaj kod lua: ",  "Run Lua code: "};
  show_menubar = { "Pokaż menu",  "Show menubar"};
  client_fullscreen = { "Pełny ekran",  "Toggle fullscreen"};
  close = { "Zamknij",  "Close"};
  toggle_floating = { "Przełącz na tryb pływający",  "Toggle floating"};
  move_to_master = { "Przenieś do mastera", "move to master" };
  move_to_screen = { "Przenieś do ekranu", "move to screen"};
  keep_on_top = { "Przełącz na górę", "toggle keep on top"};
  minimize = { "Minimalizuj", "Minimalize" };
  unmaximize = { "Odmaksymalizuj", "(un)maximize" };
  maximize_vertically = { "Maxymalizuj wertykalnie", "(un)maximize vertically"};
  maximize_horizontally = { "Maksymalizuj horyzontalnie", "(un)maximize horizontally"};
  view_tag = { "Pokaż tag", "view tag #"};
  toggle_tag = { "Przełącz tag", "toggle tag #"};
  move_focused_to_tag = { "Przenieś aktywne okno do tagu", "move focused client to tag #"};
  toggle_focused_on_tag = { "Przełącz aktywne okno na tagu", "toggle focused client on tag #"};
  increase_gap = { "Zwiększ odstępy", "Increase gap"};
  decrease_gap = { "Zmniejsz odstępy", "Decrease gap"};
}

local trans = { pl = {}; en = {} }

for key, value in pairs(t) do
  trans.pl[key] = value[1]
  trans.en[key] = value[2]
end

-- description translations
return trans
