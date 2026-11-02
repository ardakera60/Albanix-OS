#!/usr/bin/env python3
# albanix-welcome.py — Albanix OS welcome application.
# Python + PyQt6. Pages: greeting, language, keyboard, timezone, theme,
# optional software groups, privacy, tips, links.
# Runs on the INSTALLED system (normal user).
# User-facing strings are wrapped in _() for gettext; .po files live in po/.
import sys
import os
import gettext
import subprocess
import shutil
from pathlib import Path

from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QLabel, QPushButton, QStackedWidget, QRadioButton, QButtonGroup,
    QCheckBox, QGroupBox, QScrollArea, QFrame, QSpacerItem, QSizePolicy
)
from PyQt6.QtCore import Qt, QSize, QTranslator, QLocale, QLibraryInfo
from PyQt6.QtGui import QFont, QPixmap, QPalette, QColor

APP_NAME = "albanix-welcome"
LOCALE_DIR = "/usr/share/locale"
THEME_SWITCHER = "/usr/bin/albanix-theme"
FIRST_LOGIN_FLAG = Path.home() / ".config/albanix-welcome.done"

# ---------------------------------------------------------------- i18n
def setup_translation(lang_code):
    """Install gettext translation for the given language code ('sq' or 'en')."""
    t = gettext.translation(APP_NAME, localedir=LOCALE_DIR, languages=[lang_code], fallback=True)
    t.install()
    return t.gettext

def _(message):
    return gettext.gettext(message)

# ---------------------------------------------------------------- helpers
def run(cmd, check=False):
    """Run a command, return (rc, stdout, stderr)."""
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, check=check)
        return p.returncode, p.stdout, p.stderr
    except FileNotFoundError:
        return 127, "", "command not found: " + cmd[0]

def set_locale(lang):
    """Write /etc/locale.conf for sq or en and regenerate."""
    if lang == "sq":
        content = (
            "LANG=sq_AL.UTF-8\n"
            "LC_COLLATE=C\n"
            "LC_TIME=sq_AL.UTF-8\n"
            "LC_NUMERIC=sq_AL.UTF-8\n"
            "LC_MONETARY=sq_AL.UTF-8\n"
            "LC_PAPER=sq_AL.UTF-8\n"
            "LC_MEASUREMENT=sq_AL.UTF-8\n"
        )
        tz = "Europe/Tirane"
    else:
        content = (
            "LANG=en_US.UTF-8\n"
            "LC_COLLATE=C\n"
            "LC_TIME=en_US.UTF-8\n"
            "LC_NUMERIC=en_US.UTF-8\n"
            "LC_MONETARY=en_US.UTF-8\n"
            "LC_PAPER=en_US.UTF-8\n"
            "LC_MEASUREMENT=en_US.UTF-8\n"
        )
        tz = "Europe/Tirane"
    Path("/etc/locale.conf").write_text(content)
    run(["sudo", "locale-gen"], check=False)
    run(["sudo", "timedatectl", "set-timezone", tz], check=False)
    run(["sudo", "timedatectl", "set-ntp", "true"], check=False)

def set_keyboard(layout):
    """Set X11/Wayland keyboard layout via localectl (KDE picks it up)."""
    run(["sudo", "localectl", "set-x11-keymap", layout], check=False)

def set_theme(theme):
    """Switch theme via albanix-theme if available."""
    if shutil.which("albanix-theme"):
        run(["albanix-theme", theme], check=False)

def mark_done():
    FIRST_LOGIN_FLAG.parent.mkdir(parents=True, exist_ok=True)
    FIRST_LOGIN_FLAG.write_text("done\n")

def is_first_login():
    return not FIRST_LOGIN_FLAG.exists()

# ---------------------------------------------------------------- UI
class WelcomePage(QWidget):
    def __init__(self, title, subtitle):
        super().__init__()
        self.title = title
        self.subtitle = subtitle
        self._build()

    def _build(self):
        lay = QVBoxLayout(self)
        lay.setContentsSpacing(24, 24, 24, 24)
        lay.setSpacing(16)

        bar = QFrame()
        bar.setFixedHeight(4)
        lay.addWidget(bar)

        t = QLabel(self.title)
        t.setFont(QFont("Inter", 22, QFont.Weight.Bold))
        lay.addWidget(t)

        s = QLabel(self.subtitle)
        s.setWordWrap(True)
        s.setFont(QFont("Inter", 12))
        lay.addWidget(s)

        self.content = QVBoxLayout()
        lay.addLayout(self.content)
        lay.addStretch(1)

        self.nav = QHBoxLayout()
        self.btn_back = QPushButton(_("Back"))
        self.btn_next = QPushButton(_("Next"))
        self.btn_next.setDefault(True)
        self.nav.addWidget(self.btn_back)
        self.nav.addStretch(1)
        self.nav.addWidget(self.btn_next)
        lay.addLayout(self.nav)

    def set_content(self, widget):
        # clear
        while self.content.count():
            item = self.content.takeAt(0)
            if item.widget():
                item.widget().deleteLater()
        self.content.addWidget(widget)

class WelcomeWindow(QMainWindow):
    def __init__(self, first_login=False):
        super().__init__()
        self.first_login = first_login
        self.lang = "sq"  # default Albanian
        self.theme = "red"
        self.timezone = "Europe/Tirane"
        self.keyboard = "al"
        self.groups = set()

        self.setWindowTitle(_("Mirë se vini në Albanix OS / Welcome to Albanix OS"))
        self.resize(900, 640)

        self.stack = QStackedWidget()
        self.setCentralWidget(self.stack)

        self.pages = {}
        self._add_page("greeting", self.build_greeting())
        self._add_page("language", self.build_language())
        self._add_page("keyboard", self.build_keyboard())
        self._add_page("timezone", self.build_timezone())
        self._add_page("theme", self.build_theme())
        self._add_page("groups", self.build_groups())
        self._add_page("privacy", self.build_privacy())
        self._add_page("tips", self.build_tips())
        self._add_page("done", self.build_done())

        self.stack.setCurrentWidget(self.pages["greeting"])
        self._update_nav()

    def _add_page(self, key, widget):
        self.pages[key] = widget
        self.stack.addWidget(widget)

    # ---------------- navigation ----------------
    def _update_nav(self):
        current = self.stack.currentWidget()
        for key, page in self.pages.items():
            if hasattr(page, "set_nav"):
                page.set_nav(current is page)

    def go(self, key):
        self.stack.setCurrentWidget(self.pages[key])
        self._update_nav()

    # ---------------- pages ----------------
    def build_greeting(self):
        page = WelcomePage(
            _("Mirë se vini në Albanix OS"),
            _("Fast. Beautiful. Albanian. — Shpejtë. E bukur. Shqiptare.")
        )
        intro = QLabel(
            _("Welcome to Albanix OS, the Albanian-first Arch Linux distribution "
              "with KDE Plasma 6. This assistant will help you choose your "
              "language, keyboard, timezone, theme and optional software groups.")
        )
        intro.setWordWrap(True)
        page.set_content(intro)

        def on_next():
            self.go("language")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.setVisible(False)
        return page

    def build_language(self):
        page = WelcomePage(
            _("Gjuhë / Language"),
            _("Choose the system language. Albanian is the default.")
        )
        group = QButtonGroup(page)
        rb_sq = QRadioButton(_("Shqip (Albanian) — default"))
        rb_en = QRadioButton(_("English"))
        rb_sq.setChecked(True)
        group.addButton(rb_sq)
        group.addButton(rb_en)

        def pick(btn):
            self.lang = "sq" if btn is rb_sq else "en"
        group.buttonToggled.connect(pick)

        box = QVBoxLayout()
        box.addWidget(rb_sq)
        box.addWidget(rb_en)
        frame = QFrame()
        frame.setLayout(box)
        page.set_content(frame)

        def on_next():
            global _
            _ = setup_translation(self.lang)
            set_locale(self.lang)
            self.setWindowTitle(_("Mirë se vini në Albanix OS / Welcome to Albanix OS"))
            self.go("keyboard")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.clicked.connect(lambda: self.go("greeting"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def build_keyboard(self):
        page = WelcomePage(
            _("Tastaturë / Keyboard"),
            _("Albanian (al) + English (us). Alt+Shift switches; AltGr/compose types ë and ç.")
        )
        group = QButtonGroup(page)
        rb_al = QRadioButton(_("Shqip (al)"))
        rb_us = QRadioButton(_("Anglisht (us)"))
        rb_al.setChecked(self.keyboard == "al")
        rb_us.setChecked(self.keyboard == "us")
        group.addButton(rb_al)
        group.addButton(rb_us)

        def pick(btn):
            self.keyboard = "al" if btn is rb_al else "us"
        group.buttonToggled.connect(pick)

        note = QLabel(
            _("On a US keyboard: AltGr+e = ë, AltGr+c = ç (compose). "
              "Week starts Monday, dates dd.MM.yyyy, 24-hour clock.")
        )
        note.setWordWrap(True)

        box = QVBoxLayout()
        box.addWidget(rb_al)
        box.addWidget(rb_us)
        box.addSpacing(12)
        box.addWidget(note)
        frame = QFrame()
        frame.setLayout(box)
        page.set_content(frame)

        def on_next():
            set_keyboard(self.keyboard)
            self.go("timezone")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.clicked.connect(lambda: self.go("language"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def build_timezone(self):
        page = WelcomePage(
            _("Orë / Timezone"),
            _("Default Europe/Tirane (Albania). Kosovo users may choose Europe/Belgrade.")
        )
        group = QButtonGroup(page)
        rb_tir = QRadioButton(_("Europe/Tirane — Shqipëri (default)"))
        rb_bel = QRadioButton(_("Europe/Belgrade — Kosovë"))
        rb_tir.setChecked(self.timezone == "Europe/Tirane")
        rb_bel.setChecked(self.timezone == "Europe/Belgrade")
        group.addButton(rb_tir)
        group.addButton(rb_bel)

        def pick(btn):
            self.timezone = "Europe/Tirane" if btn is rb_tir else "Europe/Belgrade"
        group.buttonToggled.connect(pick)

        note = QLabel(_("Both zones share UTC+1 / CEST. NTP will be enabled."))
        note.setWordWrap(True)

        box = QVBoxLayout()
        box.addWidget(rb_tir)
        box.addWidget(rb_bel)
        box.addSpacing(12)
        box.addWidget(note)
        frame = QFrame()
        frame.setLayout(box)
        page.set_content(frame)

        def on_next():
            run(["sudo", "timedatectl", "set-timezone", self.timezone], check=False)
            run(["sudo", "timedatectl", "set-ntp", "true"], check=False)
            self.go("theme")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.clicked.connect(lambda: self.go("keyboard"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def build_theme(self):
        page = WelcomePage(
            _("Temë / Theme"),
            _("Choose your Albanix theme. The whole system switches: Plasma, SDDM, "
              "Plymouth, wallpaper, Konsole, fastfetch, starship.")
        )
        group = QButtonGroup(page)

        # Red preview
        red_box = QVBoxLayout()
        rb_red = QRadioButton(_("Albanix Red — black & red (Albanian flag motif)"))
        rb_red.setChecked(self.theme == "red")
        group.addButton(rb_red)
        red_lbl = QLabel(_("Red #E41E20 • Black #0B0B0F • Gold #D4A537"))
        red_box.addWidget(rb_red)
        red_box.addWidget(red_lbl)

        # Blue preview
        blue_box = QVBoxLayout()
        rb_blue = QRadioButton(_("Albanix Blue — navy & gold (Kosovo flag motif)"))
        rb_blue.setChecked(self.theme == "blue")
        group.addButton(rb_blue)
        blue_lbl = QLabel(_("Blue #244AA5 • Navy #07101F • Gold #D0A650"))
        blue_box.addWidget(rb_blue)
        blue_box.addWidget(blue_lbl)

        def pick(btn):
            self.theme = "red" if btn is rb_red else "blue"
        group.buttonToggled.connect(pick)

        row = QHBoxLayout()
        row.addLayout(red_box)
        row.addSpacing(24)
        row.addLayout(blue_box)
        frame = QFrame()
        frame.setLayout(row)
        page.set_content(frame)

        def on_next():
            self.theme = "red" if rb_red.isChecked() else "blue"
            set_theme(self.theme)
            self.go("groups")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.clicked.connect(lambda: self.go("timezone"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def build_groups(self):
        page = WelcomePage(
            _("Paketë opsionale / Optional software"),
            _("Select groups to install now. You can add more later with the albanix CLI.")
        )
        cb_dev = QCheckBox(_("Developer — git, node, pnpm, python, rustup, docker, podman, VS Code OSS"))
        cb_game = QCheckBox(_("Gaming — steam, proton-ge, gamemode, mangohud, lutris"))
        cb_cre = QCheckBox(_("Creator — obs, kdenlive, krita, gimp, inkscape, blender"))
        cb_off = QCheckBox(_("Office — libreoffice, okular"))
        cb_pri = QCheckBox(_("Privacy — wireguard-tools, tor browser launcher"))

        def toggle(cb, name):
            if cb.isChecked():
                self.groups.add(name)
            else:
                self.groups.discard(name)
        cb_dev.stateChanged.connect(lambda s: toggle(cb_dev, "developer"))
        cb_game.stateChanged.connect(lambda s: toggle(cb_game, "gaming"))
        cb_cre.stateChanged.connect(lambda s: toggle(cb_cre, "creator"))
        cb_off.stateChanged.connect(lambda s: toggle(cb_off, "office"))
        cb_pri.stateChanged.connect(lambda s: toggle(cb_pri, "privacy"))

        box = QVBoxLayout()
        for cb in (cb_dev, cb_game, cb_cre, cb_off, cb_pri):
            box.addWidget(cb)
        frame = QFrame()
        frame.setLayout(box)
        page.set_content(frame)

        def on_next():
            if self.groups:
                run(["sudo", "albanix", "install-group", ",".join(sorted(self.groups))], check=False)
            self.go("privacy")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.clicked.connect(lambda: self.go("theme"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def build_privacy(self):
        page = WelcomePage(
            _("Përfatësia / Privacy"),
            _("Albanix OS has no telemetry, no ads and no tracking. Nothing phones "
              "home except configured package mirrors and NTP servers.")
        )
        text = QLabel(
            _("We do not collect or transmit any personal data. The only network "
              "contacts are the pacman mirrors you configure, NTP time servers, "
              "and Flathub for Flatpak updates — all optional and opt-outable.")
        )
        text.setWordWrap(True)
        page.set_content(text)

        def on_next():
            self.go("tips")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.clicked.connect(lambda: self.go("groups"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def build_tips(self):
        page = WelcomePage(
            _("Këshilla / Tips"),
            _("Open a terminal to see fastfetch. Switch themes anytime with "
              "albanix-theme red|blue. Benchmark with albanix-bench.")
        )
        tips = [
            _("Terminal: fastfetch runs on first open (per theme)."),
            _("Theme switcher: albanix-theme red | albanix-theme blue."),
            _("Benchmark: albanix-bench (prints a Markdown table)."),
            _("Snapshots: snapper is configured; a snapshot is taken before every pacman upgrade."),
            _("Firewall: ufw is enabled (deny incoming, allow outgoing)."),
        ]
        box = QVBoxLayout()
        for tip in tips:
            lab = QLabel("• " + tip)
            lab.setWordWrap(True)
            box.addWidget(lab)
        frame = QFrame()
        frame.setLayout(box)
        page.set_content(frame)

        def on_next():
            self.go("done")
        page.btn_next.setText(_("Continue"))
        page.btn_next.clicked.connect(on_next)
        page.btn_back.clicked.connect(lambda: self.go("privacy"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def build_done(self):
        page = WelcomePage(
            _("Mbarim / Done"),
            _("Albanix OS is ready. Enjoy!")
        )
        text = QLabel(
            _("Your choices have been applied. Reopen this app anytime from the "
              "application menu (Albanix Welcome).")
        )
        text.setWordWrap(True)
        page.set_content(text)

        def on_finish():
            if self.first_login:
                mark_done()
            self.accept() if hasattr(self, "accept") else self.close()
        page.btn_next.setText(_("Finish"))
        page.btn_next.clicked.connect(on_finish)
        page.btn_back.clicked.connect(lambda: self.go("tips"))
        page.set_nav = lambda active: page.btn_back.setVisible(active)
        return page

    def closeEvent(self, event):
        if self.first_login:
            # On first login, don't let the user skip; mark done only at finish.
            event.ignore()
        else:
            event.accept()

# ---------------------------------------------------------------- main
def main():
    app = QApplication(sys.argv)
    app.setApplicationName(APP_NAME)
    app.setOrganizationName("Albanix OS")

    first_login = is_first_login()

    # Default language: Albanian.
    global _
    _ = setup_translation("sq")

    win = WelcomeWindow(first_login=first_login)
    win.show()
    sys.exit(app.exec())

if __name__ == "__main__":
    main()