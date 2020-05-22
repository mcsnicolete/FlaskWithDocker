#Rodando um aplicativo Flask com docker:

A principio, vamos criar 2 arquivos, o `Dockerfile` e um `run.sh`, para que possamos rodar nossa implantação no Docker. O `Dockerfile`  nada mais é que que um arquivo de texto que comtém os comandos necessários para a execução montagem da imagem. Já no arquivo `run.sh` teremos um script que irá construir uma imagem e criará um container do `Dockerfile`.

Tenho um diretório com meu aplicativo Flask `/app/myflaskapp`, precisamos criar o `Dockerfile` lá dentro.

```
$ sudo nano /app/myflaskapp/Dockerfile
```
Dentro do `Dockerfile`, adicionaremos os comando necessários para construção da imagem, juntamente com os requisitos extras a serem incluídos dentro da imagem.
Utilizaremos a imagem existente `tiangolo/uwsgi-nginx-flask` que está no **Dockerhub**, para contruir nossa imagem.
```
#instalação da imagem
FROM FROM tiangolo/uwsgi-nginx-flask:python3.6-alpine3.7

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
```

