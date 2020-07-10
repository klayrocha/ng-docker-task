### Primeira parte, build do projeto ###

# Imagem base com NodeJS utilizada para o build da aplicação

FROM node:10.19.0 as builder

# Define o diretório base na imagem

RUN mkdir /usr/src/app

WORKDIR /usr/src/app

# Adiciona `/usr/src/app/node_modules/.bin` ao $PATH para acesso aos executáveis

ENV PATH /usr/src/app/node_modules/.bin:$PATH

# Instala as dependências

COPY package.json /usr/src/app/package.json

RUN npm install

RUN npm install -g @angular/cli@1.7.1 --unsafe

# Adiciona o código fonte ao diretório da aplicação

COPY . /usr/src/app

# Executa o build para compilar e gerar os arquivos finais do projeto

RUN ng build --prod

### Parte 2 - criação da imagem de produção ###

# Imagem base com Nginx

FROM nginx:1.13.9-alpine

# Copia os arquivos do projeto gerados no passo anterior para a nova imagem

COPY --from=builder /usr/src/app/dist/ng-docker-task /usr/share/nginx/html

# Expõe a porta 80 na imagem

EXPOSE 80

# Inicializa o Nginx

CMD ["nginx", "-g", "daemon off;"]
