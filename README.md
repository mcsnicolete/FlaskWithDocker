# Rodando um aplicativo Flask com docker:

A principio, vamos criar 2 arquivos, o `Dockerfile` e um `run.sh`, para que possamos rodar nossa implantação no Docker. O `Dockerfile`  nada mais é que que um arquivo de texto que comtém os comandos necessários para a execução montagem da imagem. Já no arquivo `run.sh` teremos um script que irá construir uma imagem e criará um container do `Dockerfile`.

Tenho um diretório com meu aplicativo Flask `/app/myflaskapp`, precisamos criar o `Dockerfile` lá dentro.

```
$ sudo nano /app/myflaskapp/Dockerfile
```
Dentro do `Dockerfile`, adicionaremos os comando necessários para construção da imagem, juntamente com os requisitos extras a serem incluídos dentro da imagem.
Utilizaremos a imagem existente `tiangolo/uwsgi-nginx-flask` que está no **Dockerhub**, para contruir nossa imagem.

Exemplo do Dockerfile abaixo:
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
Agora que temos um Dockerfile funcional, precisamos avançar para a proxima etapa, que é a criação do nosso `run.sh`, que tera como objetivo criar o nosso contêiner do Docker. Mas antes, precisamos verificarmos uma porta disponível, no meu caso vou escolher a porta `54321`. O comando para que possamos ver se uma porta está livre é:

```
$ sudo nc localhost 54321 < /dev/null; echo $?
$ 1
```
Após a execução ele deve retornar `1`, isso significa que a porta está disponível para uso. Caso retorne algo diferente disso, deverá selecionar outras porta.

```
#!/bin/bash
app="myflaskapp"
docker build -t ${app} .
docker run -d -p 54321:80 \
  --name=${app} \
  -v $PWD:/app ${app}
```
