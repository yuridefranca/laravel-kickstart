# Laravel Kickstart

Repositório com o kickstart para projetos em Laravel

<br>

## Pré-requisitos

Para fazer o uso desse projeto você precisará ter em seu computador as seguintes ferramentas:

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

<br>

### Modo de usar
``` bash
# Clone o repositório
$ git clone git@github.com:yuridefranca/laravel-kickstart.git

# Entre no diretório do kickstart
$ cd laravel-kickstart

# Execute o seguinte comando
$ ./init.sh

# Abrirá um menu para onde será definido as configurações do projeto

```

### Instruções Menu <br>

Preencha o nome do projeto em kebab-case ex:

![Dialog Nome do Projeto](/images/dialog-nome-do-projeto.png)

Escolha a ferramenta que será usada no frontend:

![Dialog Nome do Projeto](/images/dialog-ferramenta-frontend.png)

<br>

### Instruções Docker

``` bash
# Para "subir" o docker execute o seguinte script:
$ ./startDocker.sh

# Para parar o docker execute o seguinte script:
$ ./stopDocker.sh

```
