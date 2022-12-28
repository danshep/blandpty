FROM ubuntu:latest

RUN ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && echo "Etc/UTC" > /etc/timezone \
    && apt-get update && apt-get upgrade -y \
    && apt-get install texlive-latex-base texlive-xetex texlive-latex-extra texlive-fonts-recommended xzdec -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /data/menu

ENTRYPOINT [ "/bin/sh", "-c", "xelatex -output-directory=out menu.tex"]
