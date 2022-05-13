#!/usr/bin/env bash

CURRENT_PATH=$(pwd)
PREVIOUS_PATH=$(dirname "$CURRENT_PATH") 

function initMenu() {
    welcomeMessageDialog

    projectNameDialog

    # projectPathDialog

    # progressDialog

    passwordGenerator

    configEnvFiles

    configNewPath

    finalDialog
}

function welcomeMessageDialog() {
    dialog                                                                          \
        --title 'Bem vindo!'                                                        \
        --msgbox 'Esse é o menu para configuração do seu projeto em Laravel.'       \
        6 40
}

function projectNameDialog() {
    PROJECT_NAME=$(dialog                                                           \
        --title 'Nome do Projeto'                                                   \
        --inputbox 'Informe o nome do projeto em kebab case ex: nome-do-projeto'    \
        6 40 --output-fd 1)                                                         
}

function projectPathDialog() {
    PROJECT_PATH=$(dialog                                                           \
        --title 'Digite o path do projeto'                                          \
        --fselect $PREVIOUS_PATH                                                    \
        6 40 --output-fd 1)
}

function progressDialog() {
    (
        counter=10
        while [ $counter -ne 110 ]
        do
            ((counter+=10))
            sleep 1
        done
    ) | dialog                                                                              \
            --title 'Copiando arquivos'                                                     \
            --gauge "\nCopiando arquivos para:  ${PROJECT_PATH}/${PROJECT_NAME}"            \
            6 40 0
}

function finalDialog() {
    dialog                                                                                  \
        --title 'Tudo pronto!'                                                              \
        --msgbox 'Seu projeto foi criado e configurado com sucesso.'                        \
        6 40
}

function passwordGenerator() {
    MYSQL_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
    MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
}

function configEnvFiles() {
    cp $CURRENT_PATH/.env.example $CURRENT_PATH/.env
    sed -i "s/PROJECT_NAME=.*/PROJECT_NAME=$PROJECT_NAME/g" $CURRENT_PATH/.env
    sed -i "s/MYSQL_DATABASE=.*/MYSQL_DATABASE=${PROJECT_NAME}_db/g" $CURRENT_PATH/.env
    sed -i "s/MYSQL_USER=.*/MYSQL_USER=docker/g" $CURRENT_PATH/.env
    sed -i "s/MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$MYSQL_PASSWORD/g" $CURRENT_PATH/.env
    sed -i "s/MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD/g" $CURRENT_PATH/.env
    
    cp $CURRENT_PATH/www/.env.example $CURRENT_PATH/www/.env
    sed -i "s/APP_NAME=.*/APP_NAME=${PROJECT_NAME}/g" $CURRENT_PATH/www/.env
    sed -i "s/LOG_CHANNEL=.*/LOG_CHANNEL=daily/g" $CURRENT_PATH/www/.env
    sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=mysql/g" $CURRENT_PATH/www/.env
    sed -i "s/DB_HOST=.*/DB_HOST=database/g" $CURRENT_PATH/www/.env
    sed -i "s/DB_PORT=.*/DB_PORT=3306/g" $CURRENT_PATH/www/.env
    sed -i 's/DB_DATABASE=.*/DB_DATABASE="${MYSQL_DATABASE}"/g' $CURRENT_PATH/www/.env
    sed -i 's/DB_USER=.*/DB_USER="${MYSQL_USER}"/g' $CURRENT_PATH/www/.env
    sed -i 's/DB_PASSWORD=.*/DB_PASSWORD="${MYSQL_PASSWORD}"/g' $CURRENT_PATH/www/.env
}

function configNewPath() {
    NEW_PATH="${PREVIOUS_PATH}/${PROJECT_NAME}"

    mv $CURRENT_PATH $NEW_PATH 

    cd $NEW_PATH

    rm -rf ./.git

    rm ./init.sh

    rm ./README.md

    touch ./README.md

    git init

    git add .

    git commit -m "Initial commit"
    
}


initMenu 

clear
