import itertools
import os
from typing import Iterable
import click
from livereload import Server, shell 


__all__ = ["os"]

@click.command()
@click.option("--folder", default=".", help="The folder to watch.")
@click.option("--port", default=8000, help="The port to serve on.")
@click.option(
    "--top",
    is_flag=True,
    default=False,
    help="Whether to serve the top-level folder.",
)
def main(folder: str, port: int, top: bool) -> None:
    """The main function."""
    server = Server()

    root = "build"
    paths: Iterable[str] = (
        "config.yaml",
        "Makefile",
        "*.md",
        "imgs/*",
    )
    command = "make build"  # /entrypoint.sh build-deck {folder}"

    if top:
        paths = ("*/{_}" for _ in paths)

        # watch index.md if on top-level if it exists
        if os.path.exists("index.md"):
            path = itertools.chain(path, ("index.md",))
        
        command = "make build"
    
    # Re-build the when watched files change
    for file in path:
        server.watch(file, 
            shell(command, cwd=folder, output="build.log"),
        )


    # Server on host localhost and port 8000
    # TODO: port needs to be specified as a string
    server.serve(root=root, port="8000", host="0.0.0.0")

