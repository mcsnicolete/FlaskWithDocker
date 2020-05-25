#instalação da imagem
FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7

#add bash e nano na imagem
RUN apk --update add bash nano

# Isso é uma tag com informnações do maintainer da aplicação
LABEL maintainer="Marcos Nicolete <mcsnicolete@gmail.com>"


# Esse será o workdir do container
WORKDIR /app2/myflaskapp

#estou definindo minha url dos meus arquivos estáticos CSS, javaScripts e imagens
ENV STATIC_URL /static

#estou definindo que aquela url responde nessa pasta /app2/myflaskapp/app/static.
ENV STATIC_PATH $PWD/app/static

#copiando o arquivo requirements.txt do nosso App flask para dentro do meu container
COPY ./requirements.txt /app2/myflaskapp/app/requirements.txt

#executando o arquivo requitements.txt
RUN pip install -r $PWD/app/requirements.txt
