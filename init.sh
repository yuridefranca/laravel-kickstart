#!/usr/bin/env bash

CURRENT_PATH=$(pwd)
PREVIOUS_PATH=$(dirname "$CURRENT_PATH") 

function passwordGenerator() {
    MYSQL_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
    MYSQL_ROOT_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
}

function userExit() {
    exit 1
}

function initMenu() {
    welcomeMessageDialog

    projectNameDialog

    projectFrontendToolDialog

    setUpProject
}

function projectNameDialog() {
    PROJECT_NAME=$(                                                                                         \
                dialog                                                                                      \
                    --title "Nome do Projeto"                                                               \
                    --inputbox "Digite o nome do Projeto:"                                                  \
                    8 50                                                                                    \
                    $PROJECT_NAME                                                                           \
                    3>&1 1>&2 2>&3 3>&-
	) || userExit
}

function projectFrontendToolDialog() {
    PROJECT_TYPE=$(                                                                                         \
            dialog                                                                                          \
                --clear                                                                                     \
                --title "Frontend:"                                                                         \
                --menu "Escolha a ferramenta que será utilizada para construir o frontend da aplicação"     \
                12 50 10                                                                                    \
                1 "Laravel Blade"                                                                           \
                2>&1 >/dev/tty
    ) || userExit

    case $PROJECT_TYPE in
        1) 
            PROJECT_BRANCH=feature/laravel-blade
            ;;
        2) 
            PROJECT_BRANCH=feature/vue
            ;;
        3) 
            PROJECT_BRANCH=feature/react
            ;;
    esac   
}

function setUpProject() {
    NEW_PATH="${PREVIOUS_PATH}/${PROJECT_NAME}"

    cp -r $CURRENT_PATH $NEW_PATH
    
    cd $NEW_PATH

    git fetch

    git pull origin $PROJECT_BRANCH

    git checkout -f $PROJECT_BRANCH

    rm -rf .git

    git init

    sed -i "s/PROJECT_NAME=.*/PROJECT_NAME=$PROJECT_NAME/g" $NEW_PATH/.env.example
    sed -i "s/MYSQL_DATABASE=.*/MYSQL_DATABASE=${PROJECT_NAME}_db/g" $NEW_PATH/.env.example
    sed -i "s/MYSQL_HOST=.*/MYSQL_HOST=database/g" $NEW_PATH/.env.example
    sed -i "s/MYSQL_PORT=.*/MYSQL_PORT=3306/g" $NEW_PATH/.env.example
    sed -i "s/MYSQL_USER=.*/MYSQL_USER=docker/g" $NEW_PATH/.env.example

    cp $NEW_PATH/.env.example $NEW_PATH/.env

    sed -i "s/MYSQL_PASSWORD=.*/MYSQL_PASSWORD=$MYSQL_PASSWORD/g" $NEW_PATH/.env
    sed -i "s/MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD/g" $NEW_PATH/.env

    cp $NEW_PATH/www/.env.example $NEW_PATH/www/.env

    sed -i "s/APP_NAME=.*/APP_NAME=${PROJECT_NAME}/g" $NEW_PATH/www/.env.example
    sed -i "s/LOG_CHANNEL=.*/LOG_CHANNEL=daily/g" $NEW_PATH/www/.env.example
    sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=mysql/g" $NEW_PATH/www/.env.example
    sed -i "s/DB_HOST=.*/DB_HOST=database/g" $NEW_PATH/www/.env.example
    sed -i "s/DB_PORT=.*/DB_PORT=3306/g" $NEW_PATH/www/.env.example
    sed -i 's/DB_DATABASE=.*/DB_DATABASE="${MYSQL_DATABASE}"/g' $NEW_PATH/www/.env.example
    sed -i 's/DB_USER=.*/DB_USER="${MYSQL_USER}"/g' $NEW_PATH/www/.env.example
    sed -i 's/DB_PASSWORD=.*/DB_PASSWORD="${MYSQL_PASSWORD}"/g' $NEW_PATH/www/.env.example

    sed -i "s/\"name\":.*/\"name\": \"${PROJECT_NAME}\",/g" $NEW_PATH/www/package.json

    git add .

    git commit -m "chore: :tada: setup project"

    git branch -m main

    code .
}

passwordGenerator

initMenu 

cd $NEW_PATH
