FROM blang/latex:ubuntu

RUN ln -snf /usr/share/zoneinfo/Etc/UTC /etc/localtime \
    && echo "Etc/UTC" > /etc/timezone 

WORKDIR /data

ENTRYPOINT [ "/bin/sh", "-c", "pdflatex -output-directory=menu/out menu/menu.tex"]
