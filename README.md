# Vamos preparar nossos arquivos Flask

Primeiro vamos criar nosso diretório para nosso aplicativo flask. No m eu caso eu criei um diretórico com o nome `myflaskapp` dentro de `/app`, mas nesse caso fica livre a escolha do nome.
```
 $ sudo mkdir /app/myflaskapp
```
Entre no diretório:
```
$ cd /app/myflaskapp
```

Precisamos criar dentro desse diretório, uma estrutura de diretórios para nosso aplicativo Flask, esse diretório tem como objetivo armazenar os arquivos relacionados ao nosso app flask, como Blueprints e Views:

```
$ sudo mkdir -p app/static app/templates 
```
Ao colocar o -p eu idico que o comando mkdir criará os diretórios da estrturua completa caso não existam. No meu caso, o mkdir criará o diretório pai app além dos static e templates.

Em app/static ficará armazenados arquivos como javaxcripts, CSS e Imagens. 

Em app/templates deverá ficar os modelos HTML do projeto.

Como já criei a estrutura base do projeto, precisamos criar o arquivo de execução do nosso aplicativo Flask. 
Vamos criar nosso arquivo de inicialização dentro de app o arquyivo deve se chamar __init__.py. O arquivo __init__.py tem como obejtivo, informar o interpretador que aquele diretório app tem que ser tratado como um pacote.

Execute:
```
$ sudo nano /app/myflaskapp/__init__.py
```
Na sequencia coloque o trecho de código abaixo, dentro do seu __init__.py, esse trecho de código tem como objetivo, importa a lógica para o arquivo view.py e criar uma insância de Flask:

```
from flask import Flask
app = Flask(__name__)
from app import views
```
Salve o arquivo e saia do nano.
 Após a criação do arquivo `__init__.py`, podemos seguir para a criação do arquivo `views.py` no diretório `app`. No arquivo views.py fica a logica da aplicação.
 
```
$ sudo nano /app/myflaskapp/app/views.py
```

conteudo inicial do nosso views.py:

```
from app import app

@app.route('/')
def home():
   return "É TETRA! É TETRA!"
```
Esse código irá retornar uma string na tela `É TETRA! É TETRA!`

Após o `views.py`, o proximo passo é criar `uwsgi.ini`. Dentro do arquivo `uwsgi.ini` temos as opções de implantação do `Nginx` `uWSGI`, que trata-se de um `App Server` e um protocolo ao mesmo tempo, o `App Server`, além de atender no protocolo `uWSGI`, atende também nos protocolos `FastCGI` e `HTTP`.

Criando o `uwsgi.ini`:

```
$ sudo nano /app/myflaskapp/uwsgi.ini
```
Adicione o seguinte conteudo ao arquivo:

```
[uwsgi]
module = main
callable = app
master = true
```

Dentro do arquivo `uwsgi.ini` temos o `module`, que trata-se do módulo que vai servir o nosso App flask, que nesse caso, trata-se do arquivo `main.py`(que vamos criar na próxima etapa), no `uwsgi.ini` eu referencio ele apenas como `main`. Temos no arquivo uma outra linha que tem o nome de `callable` que nesse caso eu falo para o uWSGI usar a instância com o nome `app`que será exportada do app principal. Por ultimo temos a linha do `master`, essa por sua vez permite que o nosso app tenho o tempo de paralização reduzido ao recarrega-lo por inteiro.

A proxima etapa é criar o arquivo `main.py`:

```
$ sudo nano /app/myflaskapp/main.py
```
Adicionar o seguinte conteúdo ao arquivo novo:

```
from app import app
```

Agora que criamos o ponto de entrada do nosso app, o uWSGI já terá uma forma de interação com o aplicativo.

Agora por fim vamos especificar as dependências que o `pip` instalara em sua implantação dentro do Docker, vamos criar o nosso arquivo `requirements.txt` dentro de `app`.
 ```
$ sudo nano /app/myflaskapp/app/requirements.txt
```
 Dentro do arquivo, deve conter: 
 
 ```
 Flask==1.1.2
 ```

Quando eu estava escrevendo isso, a versão `1.1.2` era a LTS, por isso selecionei.




## Rodando um aplicativo Flask com docker:

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


