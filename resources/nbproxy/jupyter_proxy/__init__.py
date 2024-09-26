# Copyright 2020 CS GROUP - France, http://www.c-s.fr
# All rights reserved

"""
Return config on servers

See https://jupyter-server-proxy.readthedocs.io/en/latest/server-process.html
for more information.
"""
import os
import shutil
import shlex


def setup_codeserver():
    # Make sure codeserver is in $PATH
    def _codeserver_command(port):
        full_path = shutil.which("code-server")
        if not full_path:
            raise FileNotFoundError("Can not find code-server in $PATH")
        working_dir = os.getenv("CODE_WORKINGDIR", None)
        if working_dir is None:
            working_dir = os.path.expanduser("~")
        if working_dir is None:
            working_dir = os.getenv("JUPYTER_SERVER_ROOT", ".")

        return [
            full_path,
            "--port=" + str(port),
            "--auth",
            "none",
            "--disable-telemetry",
            "--extensions-dir",
            os.path.join(os.path.join(working_dir, ".vscode"), "extensions"),
            working_dir,
        ]

    return {
        "command": _codeserver_command,
        "timeout": 20,
        "launcher_entry": {
            "title": "VS Code IDE",
            "icon_path": os.path.join(
                os.path.dirname(os.path.abspath(__file__)), "icons", "vscode.svg"
            ),
        },
        "new_browser_tab": True,
    }


def setup_novnc():
    def _novnc_command(port):

        vnc_command = " ".join(shlex.quote(p) for p in ([
            "vncserver",
            "-rfbport", str(port),
            "-verbose",
            "-xstartup", "/usr/bin/dbus-launch xfce4-session",
            "-geometry", "1680x1050",
            "-SecurityTypes", "None",
            "-fg"
        ]))

        return [
            "websockify", "-v",
            "--web", "/opt/noVNC-1.2.0",
            "--heartbeat", "30",
            str(port),
            "--",
            "/bin/sh", "-c", f"{vnc_command}"
        ]

    return {
        "command": _novnc_command,
        "timeout": 20,
        "launcher_entry": {
            "title": "Desktop",
            "icon_path": os.path.join(
                os.path.dirname(os.path.abspath(__file__)), "icons", "xfce.svg"
            ),
            "path_info": "desktop/vnc.html?autoconnect=true"
        },
        "mappath": {"/": "/vnc.html"},
        "new_browser_tab": True,
    }
