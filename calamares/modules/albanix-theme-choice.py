#!/usr/bin/env python3
# albanix-theme-choice.py — Calamares custom module backend (theme choice)
# Runs on the LIVE ISO.
# Stores the user's theme choice (red|blue) to storage_file so the
# shellprocess post-install step can apply it to the target system.

import sys
import os
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot

# Calamares provides the job/api via its Python bindings; we expose a
# QObject that the QML UI talks to.

class ThemeChoiceJob(QObject):
    themeChanged = pyqtSignal()

    def __init__(self):
        super().__init__()
        self._theme = "red"
        self._storage_file = "/var/lib/calamares/albanix-theme"

    @pyqtProperty(str, notify=themeChanged)
    def theme(self):
        return self._theme

    @theme.setter
    def theme(self, value):
        if value in ("red", "blue") and value != self._theme:
            self._theme = value
            self.themeChanged.emit()

    @pyqtSlot(str, result=str)
    def previewImage(self, theme):
        if theme == "blue":
            return "/usr/share/calamares/branding/albanix/theme-preview-blue.svg"
        return "/usr/share/calamares/branding/albanix/theme-preview-red.svg"

    @pyqtSlot(str)
    def save(self, theme):
        self._theme = theme
        os.makedirs(os.path.dirname(self._storage_file), exist_ok=True)
        with open(self._storage_file, "w") as f:
            f.write(theme + "\n")

# Calamares entry point: returns the job object.
def create_job():
    return ThemeChoiceJob()
