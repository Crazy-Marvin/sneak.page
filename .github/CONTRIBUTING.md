# Setup

### 🐧 Linux
- [Install Elm](https://github.com/elm/compiler/blob/master/installers/linux/README.md)

  - curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz

  - gunzip elm.gz

  - chmod +x elm

  - sudo mv elm /usr/local/bin/

- Install [Visual Studio Code](https://code.visualstudio.com/)

  - sudo snap install code --classic

  - Enable the ```elmtooling.elm-ls-vscode``` extension

  - sudo apt install npm

  - sudo npm install -g elm-test elm-format elm-review

### Gitpod

- Go to [https://gitpod.io/#https://github.com/Crazy-Marvin/sneak.page](https://gitpod.io/#https://github.com/Crazy-Marvin/sneak.page)
- Run `npx install -g elm elm-test elm-format`
- Always add `npx` before a command which you wouldn't do locally (e.g. `npx elm reactor` instead of `elm reactor`)


### Windows

 - [Install Elm](https://github.com/elm/compiler/releases/download/0.19.1/installer-for-windows.exe)
    - Put the ```elm-format.exe``` from [avh4/elm-format](https://github.com/avh4/elm-format/releases) into ```C:\Program Files (x86)\Elm\0.19.1\bin```
 - Install [Visual Studio Code](https://code.visualstudio.com/) 
    - Enable the ```elmtooling.elm-ls-vscode``` extension

# Running

elm reactor

# CI & tests

GitHub Actions

# Deployment

Hosting: GitHub Pages
Backend: Supabase

Secrets are stored on GitHub

# Bug Reports

Use the template

# Feature Request

Use the template

# Security Vulnerabilities

E-Mail

# Support

E-Mail
