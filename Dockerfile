#instalação da imagem
FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine3.11

#add bash e nano na imagem
RUN apk --update add bash nano

#estou definindo minha url dos meus arquivos estáticos CSS, javaScripts e imagens
ENV STATIC_URL /static

#estou definindo que aquela url responde nessa pasta /app/myflaskapp/app/static.
ENV STATIC_PATH /app/myflaskapp/app/static

#copiando o arquivo requirements.txt do nosso App flask para dentro do meu container
COPY ./requirements.txt /app/myflaskapp/app/requirements.txt

#executando o arquivo requitements.txt
RUN pip install -r /app/myflaskapp/app/requirements.txt