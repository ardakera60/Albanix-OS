#!/usr/bin/env python3
# albanix-optional-groups.py — Calamares custom module backend (optional groups)
# Runs on the LIVE ISO.
# Stores selected optional-group IDs to storage_file; shellprocess installs them.

import json
import os
from PyQt6.QtCore import QObject, pyqtProperty, pyqtSignal, pyqtSlot

class OptionalGroupsJob(QObject):
    groupsChanged = pyqtSignal()

    def __init__(self):
        super().__init__()
        self._groups = []
        self._storage_file = "/var/lib/calamares/albanix-groups"

    @pyqtProperty("QStringList", notify=groupsChanged)
    def groups(self):
        return self._groups

    @pyqtSlot(str, bool)
    def toggle(self, group_id, checked):
        if checked and group_id not in self._groups:
            self._groups.append(group_id)
            self.groupsChanged.emit()
        elif not checked and group_id in self._groups:
            self._groups.remove(group_id)
            self.groupsChanged.emit()

    @pyqtSlot()
    def save(self):
        os.makedirs(os.path.dirname(self._storage_file), exist_ok=True)
        with open(self._storage_file, "w") as f:
            json.dump({"groups": self._groups}, f)

def create_job():
    return OptionalGroupsJob()
