// org.albanix.red.layout.js — Albanix Red Plasma layout
// Runs in the LIVE ISO and on installed systems (Plasma 6).
// Floating bottom dock panel + desktop configuration.
var panel = new Panel;
panel.location = "bottom";
panel.alignment = "center";
panel.height = 60;
panel.thickness = 40;
panel.floating = true;
panel.edgeScreenMargin = 40;
panel.margins = { left: 40, right: 40, top: 0, bottom: 40 };

var launcher = panel.addWidget("org.kde.plasma.kickoff");
launcher.currentConfigGroup = ["General"];
launcher.writeConfig("customMenu", false);

var pager = panel.addWidget("org.kde.plasma.pager");
var taskmanager = panel.addWidget("org.kde.plasma.taskmanager");
taskmanager.currentConfigGroup = ["General"];
taskmanager.writeConfig("showOnlyCurrentScreen", true);

var systray = panel.addWidget("org.kde.plasma.systemtray");
var clock = panel.addWidget("org.kde.plasma.digitalclock");
clock.currentConfigGroup = ["General"];
clock.writeConfig("timeFormat", "HH:mm");

panel.show();