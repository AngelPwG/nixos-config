"""Apply only the reviewed substitutions to the pinned JES assets."""
from pathlib import Path
import sys


def replace_once(text, old, new):
    if text.count(old) != 1:
        raise SystemExit(f"Expected exactly one occurrence: {old[:100]!r}")
    return text.replace(old, new, 1)


MEDIA = '''    id: mediaVars
    property string selectedPlayerName: ""
    readonly property var players: Mpris.players.values
    readonly property var activePlayer: {
        const all = players
        const selected = all.find(p => p.dbusName === selectedPlayerName)
        if (selected) return selected
        return all.find(p => p.playbackState === MprisPlaybackState.Playing)
            || all.find(p => p.playbackState === MprisPlaybackState.Paused)
            || null
    }
    readonly property var plr: ({
        artist: activePlayer ? (activePlayer.trackArtist || "") : "",
        title: activePlayer ? (activePlayer.trackTitle || activePlayer.identity || "Sin título") : "Sin reproducción",
        art: activePlayer && activePlayer.trackArtUrl
            ? activePlayer.trackArtUrl : Qt.resolvedUrl("bar/images/music.webp").toString(),
        status: activePlayer && activePlayer.isPlaying ? "󰏤" : "󰐊",
        player: activePlayer ? activePlayer.identity : "Sin reproductor"
    })
    property var sysStats: ({})

    function mediaAction(action) {
        const player = activePlayer
        if (!player) return
        if (action === "play-pause" && player.canTogglePlaying) player.togglePlaying()
        else if (action === "next" && player.canGoNext) player.next()
        else if ((action === "prev" || action === "previous") && player.canGoPrevious) player.previous()
    }

    function cyclePlayer(direction) {
        const all = players
        if (!all.length) return
        const current = all.indexOf(activePlayer)
        const next = (current + direction + all.length) % all.length
        selectedPlayerName = all[next].dbusName
    }
'''

METRICS = '''                // One stream in Variables.qml, shared by all monitors.
                Item {
                    anchors.verticalCenter: parent.verticalCenter
                    width: statsText.implicitWidth + 16
                    height: panel.height - root.margins * 2 - root.wtw
                    Rectangle {
                        anchors.fill: parent
                        radius: mainRad - root.margins
                        color: col.backgroundAlt1
                        opacity: 0.65
                    }
                    Text {
                        id: statsText
                        anchors.centerIn: parent
                        text: "CPU " + (vars.sysStats.cpu_percent == null ? "…" : vars.sysStats.cpu_percent + "%")
                            + "  RAM " + (vars.sysStats.ram_used_gib == null ? "…" : Number(vars.sysStats.ram_used_gib).toFixed(1) + "G")
                        color: col.font
                        font.family: fontFamily
                        font.pixelSize: Math.min(14, fontSize - 2)
                    }
                }

'''


def main(root, python):
    variables_path = root / "Variables.qml"
    variables = variables_path.read_text()
    variables = replace_once(variables, "import QtQuick\n", "import QtQuick\nimport Quickshell.Services.Mpris\n")
    variables = replace_once(variables, "    property var plr: ({})\n", MEDIA)
    start = variables.index("    JsonListen {\n        id: plrStream")
    end = variables.index("    JsonListen {\n        id: calStream", start)
    variables = variables[:start] + f'''    JsonListen {{
        command: "{python} " + localPath(Qt.resolvedUrl("scripts/system-stats.py"))
        onDataChanged: mediaVars.sysStats = data
    }}

''' + variables[end:]

    bar_path = root / "bar/BaseBar.qml"
    bar = bar_path.read_text()
    bar = replace_once(bar, "                // player\n", METRICS + "                // player\n")
    for action in ["play-pause", "next", "previous"]:
        bar = replace_once(bar, f'Quickshell.execDetached(["sh", "-c", "playerctl {action}"])',
                           f'vars.mediaAction("{action}")')
    # Give the title a fixed maximum width so long browser titles stay bounded.
    start = bar.index("                            width: vars.plr.title?.length")
    end = bar.index("                            Component {", start)
    bar = bar[:start] + '''                            width: panel.width >= 2560 ? 180 : 80
                            sourceComponent: textComp

''' + bar[end:]
    bar = replace_once(bar, '                                    text: vars.plr.title ?? ""\n',
        '''                                    width: titleLoader.width
                                    elide: Text.ElideRight
                                    textFormat: Text.PlainText
                                    text: vars.plr.title ?? ""
''')

    popup_path = root / "bar/components/PlayerPopup.qml"
    popup = popup_path.read_text()
    old_art = 'vars.plr.art ? "file://" + vars.plr.art + "?v=" + vars.plr.ver : ""'
    if popup.count(old_art) != 2:
        raise SystemExit("Unexpected album-art bindings")
    popup = popup.replace(old_art, 'vars.plr.art || ""')
    popup = replace_once(popup,
        'Quickshell.execDetached([localPath(Qt.resolvedUrl("../../scripts/music")), "prev-player"])',
        'vars.cyclePlayer(-1)')
    popup = replace_once(popup,
        'Quickshell.execDetached([localPath(Qt.resolvedUrl("../../scripts/music")), "next-player"])',
        'vars.cyclePlayer(1)')
    popup = replace_once(popup,
        'Quickshell.execDetached([localPath(Qt.resolvedUrl("../../scripts/music")), modelData.cmd])',
        'vars.mediaAction(modelData.cmd)')

    # Only write after all substitutions succeed.
    variables_path.write_text(variables)
    bar_path.write_text(bar)
    popup_path.write_text(popup)


if __name__ == "__main__":
    main(Path(sys.argv[1]), sys.argv[2])
