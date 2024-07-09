import os
import subprocess
from typing import Iterable
import click
from livereload import Server, shell
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer


# TODO: there is a bug and I don't know where it is coming from
class RebuildHandler(FileSystemEventHandler):
    def __init__(self, build_command_template):
        self.build_command_template = build_command_template

    def on_modified(self, event):
        if not event.is_directory:
            changed_folder = os.path.dirname(event.src_path)
            relative_folder = os.path.relpath(changed_folder, "slides")
            print(f"Deteched change in {event.src_path}, rebuilding {relative_folder}...")
            self.rebuild(relative_folder)

    def rebuild(self, folder):
        # Purge the specific folder
        print("rebuild is called", folder)
        subprocess.run(['sh_scripts/purge_build.sh', folder])
        # Build the specific folder
        build_command = self.build_command_template.format(folder=folder)
        subprocess.run(build_command,
                       shell=True)


@click.command()
@click.option('--folder', default='slides', help='source of the HTML directory')
@click.option('--port', default=8000, help='Port to serve on')
def live_server(folder: str, port: int) -> None:
    """
    Starts a live server to serve files from the specified folder.

    Args:
        folder (str): The path to the folder containing the files to be served.
        port (int): The port number on which the server should listen.

    Returns:
        None
    """
    server = Server()

    root = "build"
    paths: Iterable[str] = (
            "config.yml",
            "Makefile",
            "*.md",
            "imgs/*",
            "example/*",
            "slides/**/*"
            # TODO: add nested folders

            )
    build_command_template = "make build PROJECT={folder}"

    rebuild_handler = RebuildHandler(build_command_template)
    observer = Observer()
    observer.schedule(rebuild_handler, path=folder, recursive=True)
    observer.start()

    # Re-build when the watch files change
    for file in paths:
        server.watch(file, shell(
            build_command_template.format(folder=folder)
            ))
        # We will handle rebuild in the obser

    server.serve(root=root, port=port, open_url_delay=1)

    try:
        observer.join()
    except KeyboardInterrupt:
        observer.stop()
    observer.join()


if __name__ == "__main__":
    live_server()
